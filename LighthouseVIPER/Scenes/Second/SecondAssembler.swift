//
//  SecondAssembler.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/13.
//

import UIKit
import Swinject

@MainActor
final class SecondAssembler {
    
    let container: Container
    let instance: SecondViewController
    
    init(_ container: Container) {
        self.container = Container(parent: container)
        self.instance = SecondAssembler.instantiate()
    }
    
    func assemble(reply: String) -> SecondViewController {
        instance.presenter = assemble(reply: reply)
        return instance
    }

    private static func instantiate() -> SecondViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let instance = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else {
            fatalError("fatalError SecondViewController is nil.")
        }
        return instance
    }
    
    private func assemble(reply: String) -> SecondPresentation {
        return SecondPresenter(
            viewState: SecondViewState(id: reply),
            useCase: assemble(),
            router: assemble(),
            mainFlowPresenter: container.resolve(MainFlowPresenter.self)!
        )
    }
    
    private func assemble() -> SecondUseCase {
        SecondUseCaseDI().assemble(container: container)
        return SecondUseCase(
            login: container.resolve(AuthLoginUseCase.self)!,
            signUp: container.resolve(AuthSignUpUseCase.self)!,
        )
    }
    
    private func assemble() -> SecondRouting {
        return SecondRouter(instance: instance, container: container)
    }
}
