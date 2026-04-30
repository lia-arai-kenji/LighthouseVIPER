//
//  AuthServiceTestDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/03.
//

import Swinject
@testable import LighthouseVIPER

class AuthServiceTestDI: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthWrapperMock.self) { _ in AuthWrapperMock() }
            .inObjectScope(.container)
        container.register(AuthWrapper.self) { r in
            r.require(AuthWrapperMock.self)
        }
        
        container.register(AuthService.self) { r in
            AuthServiceImpl(
                repository: r.require(AuthRepository.self),
                wrapper: r.require(AuthWrapper.self),
            )
        }
    }
}
