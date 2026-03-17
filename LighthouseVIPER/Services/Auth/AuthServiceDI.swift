//
//  AuthServiceDI.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02/25.
//

import Swinject

struct AuthServiceDI: Assembly {
    
    func assemble(container: Container) {
        // wrapper
        container.register(AuthWrapper.self) { _ in AuthWrapperImpl() }
        
        // service
        container.register(AuthService.self) { r in
            AuthServiceImpl(
                repository: r.resolve(AuthRepository.self)!,
                wrapper: r.resolve(AuthWrapper.self)!,
            )
        }
    }
}
