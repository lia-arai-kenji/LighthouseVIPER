//
//  AuthUseCases.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/03.
//

import Foundation

typealias AuthLoginUseCase = any AuthUseCases.Login
typealias AuthSignUpUseCase = any AuthUseCases.SignUp

enum AuthUseCases {
        
    /// Login UseCase
    /// - Parameters: id, password
    /// - returns: 成功時
    /// - throws: 失敗時
    struct LoginParams { let id: String, password: String }
    struct LoginError: Error { let message: String }
    protocol Login: AsyncThrowsExecute<LoginParams, Void> {}
    
    /// SignUp UseCase
    /// - Parameters: SignUpInteractor.Param
    ///   - email: String
    ///   - id: String
    /// - returns: 成功
    /// - throws:  失敗
    struct SignUpParams { let mail: String, id: String }
    protocol SignUp: AsyncThrowsExecute<SignUpParams, Void> {}
    
    struct SetExampleParams { let example: String }
    protocol SetExample: Setter<SetExampleParams, Void> {}
}

