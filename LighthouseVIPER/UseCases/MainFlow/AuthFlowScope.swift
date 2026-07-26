//
//  MainFlowAssembly.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/10.
//

import Swinject

struct AuthFlowScope: Assembly {
    
    func assemble(container: Container) {
        container.register(AuthFlowMediator.self) { _ in AuthFlowMediator() }
            .inObjectScope(.container)
    }
}
