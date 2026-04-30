//
//  LoginInteractorMock.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/27.
//

@testable import LighthouseVIPER

class LoginInteractorMock: AuthUseCases.Login {

    var isSuccess: Bool = false
    
    func execute(_ input: AuthUseCases.LoginParams) async throws {
        if await !isSuccess {
            throw AuthError()
        }
        return
    }
}
