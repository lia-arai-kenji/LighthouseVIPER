//
//  SignUpInteractor.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02/24.
//

import Foundation

class SignUpInteractor: AuthContracts.SignUp.UseCase {

    var repository: AuthRepository
    var service: any AuthService
    
    init(repository: AuthRepository, service: any AuthService) {
        self.repository = repository
        self.service = service
    }
    
    func execute(_ input: AuthContracts.SignUp.Params) async throws -> () {
        
    }
}
