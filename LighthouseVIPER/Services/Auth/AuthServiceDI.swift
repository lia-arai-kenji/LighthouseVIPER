//
//  AuthServiceDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/25.
//

import Swinject

struct AuthServiceDI: Assembly {
    
    func assemble(container: Container) {
        // wrapper
        container.register(AuthWrapper.self) { _ in AuthWrapperImpl() }
        
        // service
        container.register(AuthService.self) { r in
            AuthServiceImpl(
                repository: r.require(AuthRepository.self),
                wrapper: r.require(AuthWrapper.self),
            )
        }
    }
}
