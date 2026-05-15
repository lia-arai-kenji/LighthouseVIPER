//
//  AuthServiceTestDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/03.
//

import Cuckoo
import Swinject
@testable import LighthouseVIPER

class AuthServiceTestDI: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthWrapper.self) { _ in MockAuthWrapper() }
            .inObjectScope(.container)
        
        container.register(AuthService.self) { r in
            AuthServiceImpl(
                repository: r.require(AuthRepository.self),
                wrapper: r.require(AuthWrapper.self),
            )
        }
    }
}
