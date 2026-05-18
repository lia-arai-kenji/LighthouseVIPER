//
//  AuthService.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/03.
//

import Foundation

class AuthError: Error {}

protocol AuthService {
    
    func authentication(id: String, password: String) async throws
}

struct AuthServiceImpl: AuthService {
    
    let repository: AuthRepository
    let wrapper: AuthWrapper
    
    init(repository: AuthRepository, wrapper: AuthWrapper) {
        self.repository = repository
        self.wrapper = wrapper
    }
    
    func authentication(id: String, password: String) async throws {
        LogUtil.debug()            
        do {
            try await wrapper.authentication(id: id, password: password)
            repository.id = id
            repository.password = password
            LogUtil.debug()
        } catch {
            LogUtil.debug()
            throw AuthError()
        }
    }
}
