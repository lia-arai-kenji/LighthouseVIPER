//
//  MainAssembler.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/13.
//

import UIKit
import Swinject

protocol MainAssemblerProtocol {
    
    var container: Container { get }
    var instance: MainViewController { get }
    func assemble() -> MainViewController
    func assemble() -> MainPresentation
    func assemble() -> MainUseCase
    func assemble() -> MainRouting
}

@MainActor
class MainAssembler: MainAssemblerProtocol {
    
    var container: Container
    let instance: MainViewController
    
    init(container: Container) {
        self.instance = MainAssembler.instantiate()
        self.container = Container(parent: container)
        MainViewAssembly(instance: instance).assemble(container: self.container)
    }
    
    private static func instantiate() -> MainViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let instance = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {
            fatalError("fatalError MainViewController is nil.")
        }
        return instance
    }

    func assemble() -> MainViewController {
        self.instance.presenter = assemble()
        return instance
    }
    
    func assemble() -> MainPresentation {
        return MainPresenter(
            viewState: MainViewState(),
            useCase: assemble(),
            router: assemble(),
            mainFlowPresenter: container.resolve(MainFlowPresenter.self)!
        )
    }
    
    func assemble() -> MainUseCase {
        MainUseCaseDI().assemble(container: container)
        return MainUseCase(
            login: container.resolve(AuthLoginUseCase.self)!,
            signUp: container.resolve(AuthSignUpUseCase.self)!
        )
    }
    
    func assemble() -> MainRouting {
        return MainRouter(instance: instance, container: container)
    }
}

struct MainViewAssembly: Assembly {
    
    let instance: MainViewController
    
    func assemble(container: Container) {
        container.register(MainRouting.self) { _ in
            MainRouter(instance: instance, container: container)
        }
        
        container.register(MainUseCase.self) { r in
            MainUseCase(
                login: r.resolve(AuthLoginUseCase.self)!,
                signUp: r.resolve(AuthSignUpUseCase.self)!
            )
        }
        
        container.register(MainPresentation.self) { r in
            MainPresenter(
                viewState: MainViewState(),
                useCase: r.resolve(MainUseCase.self)!,
                router: r.resolve(MainRouting.self)!,
                mainFlowPresenter: r.resolve(MainFlowPresenter.self)!
            )
        }
    }
}
