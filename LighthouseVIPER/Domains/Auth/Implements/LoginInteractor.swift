//
//  LoginInteractor.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02/03.
//

import Foundation

class LoginInteractor: AuthContracts.Login.UseCase {

    let repository: AuthRepository
    let service: AuthService
    
    init(repository: AuthRepository, service: AuthService) {
        self.repository = repository
        self.service = service
    }
        
    /// Parameters:
    ///   id: String,
    ///   password: String
    func execute(_ input: AuthContracts.Login.Params) async throws -> () {
//        try await Task.sleep(nanoseconds: UInt64(1_000_000_000))
        try await service.authentication(id: input.id, password: input.password)
    }
}
