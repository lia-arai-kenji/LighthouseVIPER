//
//  LoginInterctorMock.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02/27.
//

@testable import LighthouseVIPER

class LoginInteractorMock: AuthContracts.Login.UseCase {
    
    var isSuccess: Bool = false
    
    func execute(_ input: AuthContracts.Login.Params) async throws {
        if !isSuccess {
            throw AuthError()
        }
        return
    }
}
