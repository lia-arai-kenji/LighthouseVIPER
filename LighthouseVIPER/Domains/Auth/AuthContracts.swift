//
//  AuthContracts.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02/03.
//

// MARK: typealias

typealias AuthLoginUseCase = any AuthContracts.Login.UseCase
typealias AuthSignUpUseCase = any AuthContracts.SignUp.UseCase

///
enum AuthContracts {
    
    /// Login UseCase
    /// - Parameters: id, password
    /// - returns: 成功時
    /// - throws: 失敗時
    enum Login {
        struct Params { let id: String, password: String }
        protocol UseCase: LiUseCaseStrategy.AsyncThrowsExecute<Params, Void> {}
    }
    
    /// SignUp UseCase
    /// - Parameters: SignUpInteractor.Param
    ///   - email: String
    ///   - id: String
    ///   - password: String
    /// - returns: 成功
    /// - throws:  失敗
    enum SignUp {
        struct Params {
            let mail: String
            let id: String
        }
        protocol UseCase: LiUseCaseStrategy.AsyncThrowsExecute<Params, Void> {}
    }
}

