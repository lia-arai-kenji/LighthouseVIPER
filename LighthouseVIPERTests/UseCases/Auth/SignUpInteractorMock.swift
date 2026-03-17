//
//  SignUpInteractorMock.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/03.
//

@testable import LighthouseVIPER

struct SignUpInteractorMock: AuthContracts.SignUp.UseCase {
        
    func execute(_ input: LighthouseVIPER.AuthContracts.SignUp.Params) async throws -> () {
        
    }
}

