//
//  LoginInteractor.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/03.
//

import Foundation

struct LoginInteractor: AuthUseCases.Login {

    let repository: AuthRepository
    let service: AuthService
    
    /// Parameters:
    ///   id: String,
    ///   password: String
    func execute(_ input: AuthUseCases.LoginParams) async throws -> () {
        try await service.authentication(id: input.id, password: input.password)
    }
}

struct Auth1Interactor: AuthUseCases.Login {
    
    let repository: AuthRepository
    let service: AuthService
        
    /// Parameters:
    ///   id: String,
    ///   password: String
    func execute(_ input: AuthUseCases.LoginParams) async throws -> () {
        try await service.authentication(id: input.id, password: input.password)
    }
}
    
    

