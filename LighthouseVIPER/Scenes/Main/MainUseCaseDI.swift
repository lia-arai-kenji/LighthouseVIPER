//
//  MainUseCaseDI.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/05.
//

import Swinject

struct MainUseCaseDI: Assembly {
    
    func assemble(container: Container) {
        AuthServiceDI().assemble(container: container)
        container.register(AuthLoginUseCase.self) { r in
            LoginInteractor(
                repository: r.resolve(AuthRepository.self)!,
                service: r.resolve(AuthService.self)!,
            )
        }
        container.register(AuthSignUpUseCase.self) { r in
            SignUpInteractor(
                repository: r.resolve(AuthRepository.self)!,
                service: r.resolve(AuthService.self)!,
            )
        }
    }
}
