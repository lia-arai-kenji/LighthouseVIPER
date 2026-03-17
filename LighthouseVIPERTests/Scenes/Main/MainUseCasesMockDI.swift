
//
//  MainUseCasesMockDI.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/06.
//

import Swinject
@testable import LighthouseVIPER

class MainUseCasesMockDI: Assembly {
    
    func assemble(container: Container) {
        AuthServiceTestDI().assemble(container: container)
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
