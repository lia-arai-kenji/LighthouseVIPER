//
//  AuthWrapper.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/05.
//

protocol AuthWrapper {
    
    func authentication(id: String, password: String) async throws
}

class AuthWrapperImpl: AuthWrapper {
    
    func authentication(id: String, password: String) async throws {
        if id == "id" && password == "password" {
            return
        }
        throw AuthError()
    }
}
