//
//  LiAsyncStream.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/01/27.
//

import Foundation

/// Swift Concurrency の 非同期/リアクティブプログラミングツールの独自拡張クラス

public enum LiAsyncStream {
    
    public enum Delivery: Sendable {
        case current
        case mainActor
    }
    
    // MARK: Subject Definition
    public final class Subject<T: Sendable>: @unchecked Sendable {

        private let lock = NSLock()
        private var continuations: [UUID: AsyncStream<T>.Continuation] = [:]
        private var isFinished = false
        private var upstreamCancellables: LiAsyncStream.Cancellables = []

        init() {}
    }
    
    public final class Latest<Value>: @unchecked Sendable {
        
        private var latest: Value
        private let lock = NSLock()
        
        init(_ initialValue: Value) {
            self.latest = initialValue
        }
    }
    
    // MARK: Cancellable Definition
    public struct Cancellable: Sendable {
        
        private let state: CancellationState
        
        init(subject: AnyObject, id: UUID, task: Task<Void, Never>, unsubscribe: @escaping @Sendable (UUID) -> Void) {
            self.state = CancellationState(
                subject: subject,
                id: id,
                task: task,
                unsubscribe: unsubscribe
            )
        }
    }
    
    typealias Cancellables = [LiAsyncStream.Cancellable]
}

// MARK: Subject Implements

extension LiAsyncStream.Subject {
    
    public func yield(_ value: T) {
        lock.lock()
        if isFinished {
            lock.unlock()
            return
        }
        let targets = Array(continuations.values)
        lock.unlock()
        for c in targets {
            c.yield(value)
        }
    }
    
    @discardableResult
    public func bind<Object: AnyObject, Wrapped: Sendable>(
        _ keyPath: KeyPath<T, Wrapped>,
        to object: Object,
        _ target: ReferenceWritableKeyPath<Object, Wrapped>,
        on delivery: LiAsyncStream.Delivery = .mainActor
    ) -> LiAsyncStream.Cancellable {
        self.map(keyPath).sink(on: delivery) { [weak object] value in
            object?[keyPath: target] = value
        }
    }
    @discardableResult
    public func bind<Object: AnyObject, Wrapped: Sendable>(
        _ keyPath: KeyPath<T, Wrapped>,
        to object: Object,
        _ target: ReferenceWritableKeyPath<Object, Wrapped?>,
        on delivery: LiAsyncStream.Delivery = .mainActor
    ) -> LiAsyncStream.Cancellable {
        self.map(keyPath).sink(on: delivery) { [weak object] value in
            object?[keyPath: target] = value
        }
    }
    
    @MainActor
    @discardableResult
    public func render<Object: AnyObject, Wrapped: Sendable&Equatable>(
        _ keyPath: KeyPath<T, Wrapped>,
        to object: Object,
        _ target: ReferenceWritableKeyPath<Object, Wrapped>
    ) -> LiAsyncStream.Cancellable {
        self.map(keyPath).sink(on: .mainActor) { [weak object] value in
            guard let object else { return }
            // UIに設定済みの値と比較し、同値なら更新をスキップする
            if object[keyPath: target] != value {
                object[keyPath: target] = value
            }
        }
    }
    
    @MainActor
    @discardableResult
    public func render<Object: AnyObject, Wrapped: Sendable&Equatable>(
        _ keyPath: KeyPath<T, Wrapped>,
        to object: Object,
        _ target: ReferenceWritableKeyPath<Object, Wrapped?>,
    ) -> LiAsyncStream.Cancellable {
        self.map(keyPath).sink(on: .mainActor) { [weak object] value in
            guard let object else { return }
            if object[keyPath: target] != value {
                object[keyPath: target] = value
            }
        }
    }

    public func finish() {
        LogUtil.debug()
        lock.lock()
        if isFinished {
            lock.unlock()
            return
        }
        isFinished = true
        let targets = Array(continuations.values)
        continuations.removeAll()
        var ups = upstreamCancellables
        lock.unlock()
        for c in targets {
            c.finish()
        }
        ups.cancelAll()
    }
    
    public func map<Value: Sendable>(_ keyPath: KeyPath<T, Value>) -> LiAsyncStream.Subject<Value> {
        let subject = LiAsyncStream.Subject<Value>()
        let c = self.sink { t in
            subject.yield(t[keyPath: keyPath])
        }
        subject.storeUpstream(c)
        return subject
    }
    
    func unwrap<Wrapped: Sendable>() -> LiAsyncStream.Subject<Wrapped> where T == Wrapped? {
        let subject = LiAsyncStream.Subject<Wrapped>()
        let c = self.sink { value in
            if let v = value {
                subject.yield(v)
            }
        }
        subject.storeUpstream(c)
        return subject
    }

    // コールバックを参照元のスレッドで処理するsink
    public func sink(
        on  delivery: LiAsyncStream.Delivery = .current,
        bufferingPolicy: AsyncStream<T>.Continuation.BufferingPolicy = .unbounded,
        priority: TaskPriority? = nil,
        _ receiveValue: @escaping (T) -> Void
    ) -> LiAsyncStream.Cancellable {
        let id = UUID()
        // 購読者ごとに stream を作る
        let pair = AsyncStream<T>.makeStream(bufferingPolicy: bufferingPolicy)
        lock.lock()
        if isFinished {
            lock.unlock()
            // 終了済みなら即finishしてからの購読を返す(Taskも即終了)
            let task = Task(priority: priority) {}
            return LiAsyncStream.Cancellable(subject: self, id: id, task: task, unsubscribe: { _ in })
        }
        continuations[id] = pair.continuation
        lock.unlock()
        // 受信Task(ここを止めたいのがあなたの目的)
        let task = Task(priority: priority) {
            for await value in pair.stream {
                if Task.isCancelled { break }
                switch delivery {
                case .current:
                    receiveValue(value)
                case .mainActor:
                    await MainActor.run { receiveValue(value) }
                }
            }
        }
        return LiAsyncStream.Cancellable(subject: self, id: id, task: task)
        { [weak self] subId in
            self?.unsubscribe(subId)
        }
    }
    
    /// upstream の値をこの LiAsyncStream に流し込む（橋渡し）
    /// - Returns: 橋渡しを止めるための cancellable
    public func forward(to downStream: LiAsyncStream.Subject<T>) -> LiAsyncStream.Cancellable {
        self.sink { downStream.yield($0) }
    }
        
    private func unsubscribe(_ id: UUID) {
        lock.lock()
        let c = continuations.removeValue(forKey: id)
        lock.unlock()
        // 解放された購読ストリームを終了させる(受信Taskを自然終了させる)
        c?.finish()
    }
    
    fileprivate func storeUpstream(_ c: LiAsyncStream.Cancellable) {
        lock.lock()
        upstreamCancellables.append(c)
        lock.unlock()
    }
}

// MARK: Latest Implements

extension LiAsyncStream.Latest {
    
    public var value: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return latest
        }
        set {
            lock.lock()
            latest = newValue
            lock.unlock()
        }
    }
    
    /// ちょい便利：更新処理を１箇所に閉じ込めたい時用
    public func mutate(_ transform: (inout Value) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        transform(&latest)
    }
}

// MARK: Cancellable Implements

extension LiAsyncStream.Cancellable {
    
    var isCancelled: Bool {
        state.isCancelled
    }

    func cancel() {
        state.cancel()
    }
    
    func store(in array: inout LiAsyncStream.Cancellables) {
        array.append(self)
    }
}

public extension Array where Element == LiAsyncStream.Cancellable {
 
    mutating func cancelAll() {
        forEach { $0.cancel()}
    }
}

private final class CancellationState: @unchecked Sendable {
    private let lock = NSLock()
    // subject 自体の寿命を延ばしすぎないため weak にしたいが、
    // Swiftの弱参照は class型でないと持てないので AnyObject として保持
    private weak var subject: AnyObject?
    private let id: UUID
    private var task: Task<Void, Never>?
    private let unsubscribe: @Sendable (UUID) -> Void
    
    private(set) var isCancelled: Bool = false
    
    init(subject: AnyObject, id: UUID, task: Task<Void, Never>, unsubscribe: @escaping @Sendable (UUID) -> Void) {
        self.subject = subject
        self.id = id
        self.task = task
        self.unsubscribe = unsubscribe
    }
    
    func cancel() {
        lock.lock()
        guard !isCancelled else {
            lock.unlock()
            return
        }
        isCancelled = true
        let t = task
        task = nil
        let hasSubject = (subject != nil)
        lock.unlock()
        
        // 先に購読解除 -> stream finish -> for await が自然に終わる
        if hasSubject {
            unsubscribe(id)
        }
        t?.cancel()
    }
}

// MARK: LITaskHandler
typealias LiTaskHandler = Task<Void, Never>

extension Task where Success == Void, Failure == Never {
    
    func cancelPrevious(in cancellables: inout Set<LiTaskHandler>) -> LiTaskHandler {
        if let first = cancellables.first  {
            LogUtil.debug("cancel previous task")
            first.cancel()
            cancellables.remove(first)
        }
        return self
    }
    
    func store(in cancellables: inout Set<LiTaskHandler>) -> LiTaskHandler {
        cancellables.insert(self)
        return self
    }
}

