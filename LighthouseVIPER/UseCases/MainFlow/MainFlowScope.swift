//
//  MainFlowAssembly.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/10.
//

import Swinject

struct MainFlowScope: Assembly {
    
    func assemble(container: Container) {
        container.register(MainFlowMediator.self) { r in MainFlowMediator() }
            .inObjectScope(.container)
    }
}
