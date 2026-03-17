//
//  MainPresenterTestAssembler.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/01/16.
//

import UIKit
import Swinject
@testable import LighthouseVIPER

class MainPresenterTestAssembler: MainAssemblerProtocol {

    var container: Container
    var instance: MainViewController
    let mockRouter = MainRouterMock()
    var mainFlowPresenter: MainFlowPresenter!
    
    init(container: Container) {
        self.container = container
        self.instance = MainViewController()
    }
    
    func assemble() -> MainViewController {
        instance
    }
    
    func assemble() -> any MainPresentation {
        mainFlowPresenter = container.resolve(MainFlowPresenter.self)!
        return MainPresenter(
            viewState: MainViewState(),
            useCase: assemble(),
            router: assemble(),
            mainFlowPresenter: mainFlowPresenter
        )
    }

    func assemble() -> MainUseCase {
        MainUseCasesMockDI().assemble(container: container)
        return MainUseCase(
            login: container.resolve(AuthLoginUseCase.self)!,
            signUp: container.resolve(AuthSignUpUseCase.self)!
        )
    }
    
    func assemble() -> any MainRouting {
        mockRouter
    }
}
