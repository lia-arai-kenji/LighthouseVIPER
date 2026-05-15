//
//  SecondSceneDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/13.
//

import UIKit
import SwiftUI
import Swinject

typealias SecondRouterRegistry = (
    _ instance: SecondViewController,
    _ hosting: UIHostingController<SecondUI>?,
) -> SecondRouting

struct SecondSceneDI: Assembly {
    
    func assemble(container: Container) {
        AuthServiceDI().assemble(container: container)
        SecondModulesDI().assemble(container: container)
    }
}

struct SecondModulesDI: Assembly {
    
    func assemble(container: Container) {
        // SecondUseCases
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
        // SecondRouting
        container.register(SecondRouterRegistry.self) { [unowned container] _ in
            { instance, hosting in
                SecondRouter(instance: instance, hosting: hosting, container: container)
            }
        }
    }
}


// MARK: SwiftUI Preview

struct PreviewSecondSceneDI: Assembly {
    
    func assemble(container: Container) {
        AppScope().assemble(container: container)
        MainFlowScope().assemble(container: container)
        SecondModulesDI().assemble(container: container)
        container.register(SecondRouterRegistry.self) { _ in
            { _, _ in
                PreviewSecondRouter()
            }
        }
    }
}
