//
//  MainSceneAssembler.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/04/16.
//

import UIKit
import Swinject
import RswiftResources

@MainActor
final class MainSceneAssembler {
    
    var container: Container
    let instance: MainViewController
    
    init(_ container: Container) {
        self.instance = MainSceneAssembler.instantiate()
        self.container = Container(parent: container)
    }
    
    private static func instantiate() -> MainViewController {
        guard let instance = R.storyboard.main.mainViewController() else {
            fatalError("fatalError MainViewController is nil.")
        }
        return instance
    }
    
    func viewController() -> MainViewController {
        self.instance.presenter = presenter()
        return instance
    }
    
    func navigationController() -> UINavigationController {
        UINavigationController(rootViewController: viewController())
    }
    
    func presenter() -> MainPresentation {
        MainPresenter(
            viewState: MainViewState(),
            useCase: useCase(),
            router: router(),
            mainFlowMediator: container.require(MainFlowMediator.self)
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
        MainFlowScope().assemble(container: container)
        return container
    }
}
