//
//  SignUpInteractor.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/24.
//

import Foundation

class SignUpInteractor: AuthUseCases.SignUp {

    var repository: AuthRepository
    var service: any AuthService
    
    init(repository: AuthRepository, service: any AuthService) {
        self.repository = repository
        self.service = service
    }
    
    func execute(_ input: AuthUseCases.SignUpParams) async throws -> () {
        
    }
}
