//
//  AuthUseCasesDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/05.
//



import Swinject


struct AuthUseCasesDI: Assembly {

    func assemble(container: Container) {
        AuthServiceDI().assemble(container: container)
        container.register(AuthWrapper.self) { _ in AuthWrapperImpl() }
        
        container.register(AuthLoginUseCase.self) { r in
            LoginInteractor(
                repository: r.require(AuthRepository.self),
                service: r.require(AuthService.self),
            )
        }
        container.register(AuthSignUpUseCase.self) { r in
            SignUpInteractor(
                repository: r.require(AuthRepository.self),
                service: r.require(AuthService.self),
            )
        }
    }
}
