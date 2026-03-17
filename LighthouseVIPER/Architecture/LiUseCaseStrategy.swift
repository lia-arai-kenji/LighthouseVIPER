//
//  LiUseCaseStrategy.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import Foundation

enum LiUseCaseStrategy {
    
    /// 実装時にデータ型を確定する前の仮のデータ型設定
    protocol AssociatedTypeIO {
        associatedtype Input
        associatedtype Output
    }
    
    /// Strategy パターンの適用で1メソッド1クラスを実現する
    
    // MARK: SyncUseCase
    protocol Execute<Input, Output>: AssociatedTypeIO {
        
        func execute(_ input: Input) -> Output
    }
    protocol Get<Input, Output>: AssociatedTypeIO {
        
        func get(_ input: Input) -> Output
    }
    protocol Set<Input, Output>: AssociatedTypeIO {
        
        func set(_ input: Input)
    }
    protocol GetSet<Input, Output>: Get, LiUseCaseStrategy.Set {}
    
    // MARK: AsyncUseCase
    protocol AsyncExecute<Input, Output>: AssociatedTypeIO {
        
        func execute(_ input: Input) async -> Output
    }
    protocol AsyncGet<Input, Output>: AssociatedTypeIO {
        
        func get(_ input: Input) async -> Output
    }
    protocol AsyncSet<Input, Output>: AssociatedTypeIO {
        
        func set(_ input: Input) async
    }
    protocol AsyncGetSet<Input, Output>: AsyncGet, AsyncSet {}
    
    // MARK: ThrowsUseCase
    protocol ThrowsExecute<Input, Output>: AssociatedTypeIO {
        
        func execute(_ input: Input) throws -> Output
    }
    protocol ThrowsGet<Input, Output>: AssociatedTypeIO {
        
        func get(_ input: Input) throws -> Output
    }
    protocol ThrowsSet<Input, Output>: AssociatedTypeIO {
        
        func set(_ input: Input) throws
    }
    protocol ThrowsGetSet<Input, Output>: ThrowsGet, ThrowsSet {}
    
    // MARK: AsyncThrowsUseCase
    protocol AsyncThrowsExecute<Input, Output>: AssociatedTypeIO {
        
        func execute(_ input: Input) async throws -> Output
    }
    protocol AsyncThrowsGet<Input, Output>: AssociatedTypeIO {
        
        func get(_ input: Input) async throws -> Output
    }
    protocol AsyncThrowsSet<Input, Output>: AssociatedTypeIO {
        
        func set(_ input: Input) async throws
    }
    protocol AsyncThrowsGetSet<Input, Output>: AsyncThrowsGet, AsyncThrowsSet {}
    
}
// MARK: input void extension
extension LiUseCaseStrategy.Execute where Input == Void {
    
    func execute() -> Output { execute(()) }
}
extension LiUseCaseStrategy.Get where Input == Void {
    
    func get() -> Output { get(()) }
}

extension LiUseCaseStrategy.AsyncExecute where Input == Void {
    
    func execute() async -> Output { await execute(()) }
}
extension LiUseCaseStrategy.AsyncGet where Input == Void {
    
    func get() async -> Output { await get(()) }
}

extension LiUseCaseStrategy.ThrowsExecute where Input == Void {
    
    func execute() throws -> Output { try execute(()) }
}
extension LiUseCaseStrategy.ThrowsGet where Input == Void {
    
    func get() throws -> Output { try get(()) }
}

extension LiUseCaseStrategy.AsyncThrowsExecute where Input == Void {
    
    func execute() async throws -> Output { try await execute(()) }
}
extension LiUseCaseStrategy.AsyncThrowsGet where Input == Void {
    
    func get() async throws -> Output { try await get(()) }
}
