//
//  SignUpInteractorMock.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/03.
//

@testable import LighthouseVIPER

struct SignUpInteractorMock: AuthUseCases.SignUp {
        
    func execute(_ input: AuthUseCases.SignUpParams) async throws -> () {
        
    }
}

