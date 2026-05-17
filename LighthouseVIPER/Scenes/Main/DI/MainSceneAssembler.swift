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
    
    var container: Container
    var instance: MainViewController?
    
    init(_ container: Container) {
        self.container = Container(parent: container)
    }
    
    @MainActor
    private static func instantiate() -> MainViewController {
        guard let instance = R.storyboard.main.mainViewController() else {
            fatalError("fatalError MainViewController is nil.")
        }
        return instance
    }
    
    @MainActor
    func viewController() -> MainViewController? {
        self.instance = MainSceneAssembler.instantiate()
        self.instance?.presenter = presenter()
        return instance
    }
    
    @MainActor
    func navigationController() -> UINavigationController? {
        guard let vc = viewController() else {
            return nil
        }
        return UINavigationController(rootViewController: vc)
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
