//
//  LiUseCaseStrategy.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import Foundation
    
/// 実装時にデータ型を確定する前の仮のデータ型設定
protocol AssociatedTypeIO {
    associatedtype Input
    associatedtype Output
}

/// Strategy パターンの適用で1メソッド1クラスを実現する

// MARK: SyncUseCase
protocol Executor<Input, Output>: AssociatedTypeIO {
    
    func execute(_ input: Input) -> Output
}
protocol Getter<Input, Output>: AssociatedTypeIO {
    
    func get(_ input: Input) -> Output
}
protocol Setter<Input, Output>: AssociatedTypeIO {
    
    func set(_ input: Input)
}
protocol GetSet<Input, Output>: Getter, Setter {}

// MARK: AsyncUseCase
protocol AsyncExecutor<Input, Output>: AssociatedTypeIO {
    
    func execute(_ input: Input) async -> Output
}
protocol AsyncGetter<Input, Output>: AssociatedTypeIO {
    
    func get(_ input: Input) async -> Output
}
protocol AsyncSetter<Input, Output>: AssociatedTypeIO {
    
    func set(_ input: Input) async
}
protocol AsyncGetterSetter<Input, Output>: AsyncGetter, AsyncSetter {}

// MARK: ThrowsUseCase
protocol ThrowsExecutor<Input, Output>: AssociatedTypeIO {
    
    func execute(_ input: Input) throws -> Output
}
protocol ThrowsGetter<Input, Output>: AssociatedTypeIO {
    
    func get(_ input: Input) throws -> Output
}
protocol ThrowsSetter<Input, Output>: AssociatedTypeIO {
    
    func set(_ input: Input) throws
}
protocol ThrowsGetterSetter<Input, Output>: ThrowsGetter, ThrowsSetter {}

// MARK: AsyncThrowsUseCase
protocol AsyncThrowsExecutor<Input, Output>: AssociatedTypeIO {
    
    func execute(_ input: Input) async throws -> Output
}
protocol AsyncThrowsGetter<Input, Output>: AssociatedTypeIO {
    
    func get(_ input: Input) async throws -> Output
}
protocol AsyncThrowsSetter<Input, Output>: AssociatedTypeIO {
    
    func set(_ input: Input) async throws
}
protocol AsyncThrowsGetSet<Input, Output>: AsyncThrowsGetter, AsyncThrowsSetter {}
    
// MARK: input void extension
extension Executor where Input == Void {
    
    func execute() -> Output { execute(()) }
}
extension Getter where Input == Void {
    
    func get() -> Output { get(()) }
}

extension AsyncExecutor where Input == Void {
    
    func execute() async -> Output { await execute(()) }
}
extension AsyncGetter where Input == Void {
    
    func get() async -> Output { await get(()) }
}

extension ThrowsExecutor where Input == Void {
    
    func execute() throws -> Output { try execute(()) }
}
extension ThrowsGetter where Input == Void {
    
    func get() throws -> Output { try get(()) }
}

extension AsyncThrowsExecutor where Input == Void {
    
    func execute() async throws -> Output { try await execute(()) }
}
extension AsyncThrowsGetter where Input == Void {
    
    func get() async throws -> Output { try await get(()) }
}
