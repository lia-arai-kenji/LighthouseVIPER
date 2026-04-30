//
//  MainSceneDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/13.
//

import UIKit
import Swinject

/// Swinject register を使って後から必要な要素を注入するための typeAlias
typealias MainRouterRegistry = (_ instance: MainViewController) -> MainRouting

struct MainSceneDI: Assembly {
    
    func assemble(container: Container) {
        MainFlowScope().assemble(container: container)
        MainUseCaseDI().assemble(container: container)
        container.register(MainRouterRegistry.self) { [unowned container] _ in
            { instance in
                MainRouter(instance: instance, container: container)
            }
        }
    }
}

struct MainUseCaseDI: Assembly {
    
    func assemble(container: Container) {
        AuthServiceDI().assemble(container: container)
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

