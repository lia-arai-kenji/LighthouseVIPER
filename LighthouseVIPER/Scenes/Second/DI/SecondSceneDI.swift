//
//  SecondSceneDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/13.
//

import UIKit
import SwiftUI
import Swinject


typealias SecondRouterRegistry = @MainActor (
    _ instance: SecondViewController,
    _ hosting: UIHostingController<SecondUI>?,
) -> SecondRouting

struct SecondSceneDI: Assembly {
    
    func assemble(container: Container) {
        container.register(SecondRouterRegistry.self) { [unowned container] _ in
            { @MainActor instance, hosting in
                SecondRouter(instance: instance, hosting: hosting, container: container)
            }
        }
    }
}

struct SecondUseCaseDI: Assembly {
    
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


// MARK: SwiftUI Preview

struct PreviewSecondSceneDI: Assembly {
    
    func assemble(container: Container) {
        AppScope().assemble(container: container)
        MainFlowScope().assemble(container: container)
        SecondUseCaseDI().assemble(container: container)
        container.register(SecondRouterRegistry.self) { _ in
            { @MainActor _, _ in
                PreviewSecondRouter()
            }
        }
    }
}
