//
//  MainFlowAssembly.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/10.
//

import Swinject

struct MainFlowAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MainFlowPresenter.self) { r in MainFlowPresenter() }
            .inObjectScope(.container)
    }
}
