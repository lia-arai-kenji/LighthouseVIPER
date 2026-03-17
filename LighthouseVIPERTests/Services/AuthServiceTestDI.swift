//
//  AuthServiceTestDI.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/03.
//

import Swinject
@testable import LighthouseVIPER

class AuthServiceTestDI: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthWrapper.self) { _ in AuthWrapperMock() }
            .inObjectScope(.container)
        
        container.register(AuthService.self) { r in
            AuthServiceImpl(
                repository: r.resolve(AuthRepository.self)!,
                wrapper: r.resolve(AuthWrapper.self)!,
            )
        }
    }
}
