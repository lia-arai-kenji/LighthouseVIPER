//
//  AuthDomainsDI.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/05.
//



import Swinject


struct AuthDomainsDI: Assembly {

    func assemble(container: Container) {
        AuthServiceDI().assemble(container: container)
        container.register(AuthWrapper.self) { _ in AuthWrapperImpl() }
        
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
