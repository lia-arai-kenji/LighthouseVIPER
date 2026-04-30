//
//  MainSceneTestDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/01/16.
//

import Swinject
@testable import LighthouseVIPER

class MainSceneTestDI: Assembly {
    
    func assemble(container: Container) {
        MainFlowScope().assemble(container: container)
        MainUseCasesMockDI().assemble(container: container)
        // Mock は実態を一旦DIする
        container.register(MainRouterMock.self) { _ in
            MainRouterMock()
        }.inObjectScope(.container)
        container.register(MainRouterRegistry.self) { r in
            { _ in r.require(MainRouterMock.self) }
        }
    }
}

class MainUseCasesMockDI: Assembly {
    
    func assemble(container: Container) {
        AuthServiceTestDI().assemble(container: container)
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
