//
//  SecondSceneAssembler.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/04/16.
//

import UIKit
import SwiftUI
import Swinject
import RswiftResources

final class SecondAssembler {
    
    let container: Container
    let instance: SecondViewController
    var hosting: UIHostingController<SecondUI>?
    
    init(_ container: Container) {
        self.container = Container(parent: container)
        self.instance = SecondAssembler.instantiate()
    }
    
    @MainActor
    func viewController(reply: String) -> SecondViewController {
        SecondSceneDI().assemble(container: container)
        instance.presenter = assemble(reply: reply)
        return instance
    }
    
    private static func instantiate() -> SecondViewController {
        guard let instance = R.storyboard.main.secondViewController() else {
            fatalError("fatalError SecondViewController is nil.")
        }
        return instance
    }
    
    @MainActor
    func swiftUI(reply: String) -> UIHostingController<SecondUI> {
        let observable = SecondUIObservable(presenter: assemble(reply: reply))
        let ui = SecondUI(observable: observable)
        let result = UIHostingController(rootView: ui)
        self.hosting = result
        let presenter = observable.presenter as? SecondPresenter
        presenter?.router = assemble()
        return result
    }
    
    private func assemble(reply: String) -> any SecondPresentation {
        return SecondPresenter(
            reply: reply,
            useCase: assemble(),
            router: assemble(),
            mainFlowMediator: container.require(AuthFlowMediator.self)
        )
    }
        
    private func assemble() -> SecondUseCase {
        return SecondUseCase(
            login: container.require(AuthLoginUseCase.self),
            signUp: container.require(AuthSignUpUseCase.self),
        )
    }
    
    private func assemble() -> SecondRouting {
        let registry = container.require(SecondRouterRegistry.self)
        return registry(instance, hosting)
    }    
}

extension SecondAssembler {
    
    @MainActor
    static func preview(reply: String) -> SecondPresentation {
        let container = Container()
        PreviewSecondSceneDI().assemble(container: container)
        let hosting = SecondAssembler(container).swiftUI(reply: reply)
        return hosting.rootView.observable.presenter
    }
}

