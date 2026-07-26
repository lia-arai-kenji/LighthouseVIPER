//
//  MainSceneAssembler.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/04/16.
//

import UIKit
import Swinject
import RswiftResources

final class MainSceneAssembler {
    
    let instance: MainViewController
    let container: Container
    
    init(_ container: Container) {
        self.instance = MainSceneAssembler.instantiate()
        self.container = Container(parent: container)
        AuthFlowScope().assemble(container: self.container)
    }
    
    private static func instantiate() -> MainViewController {
        guard let instance = R.storyboard.main.mainViewController() else {
            fatalError("fatalError MainViewController is nil.")
        }
        return instance
    }
    
    @MainActor
    func viewController() -> MainViewController {
        MainSceneDI().assemble(container: self.container)
        self.instance.presenter = presenter()
        return instance
    }
    
    @MainActor
    func navigationController() -> UINavigationController? {
        return UINavigationController(rootViewController: viewController())
    }
    
    func presenter() -> MainPresentation {
        MainPresenter(
            useCase: useCase(),
            router: router(),
            mainFlowMediator: container.require(AuthFlowMediator.self)
        )
    }
    
    func useCase() -> MainUseCase {
        MainUseCase(
            login: container.require(AuthLoginUseCase.self),
            signUp: container.require(AuthSignUpUseCase.self),
        )
    }
    
    func router() -> MainRouting {
        container.require(MainRouterRegistry.self)(instance)
    }
}


// MARK: Dummy Resource for SwiftUI Preview and Unit Test

extension MainSceneAssembler {
    
    static func dummyResource() -> Container {
        let container = Container()
        AppScope().assemble(container: container)
        AuthFlowScope().assemble(container: container)
        return container
    }
}
