//
//  MainSceneTestDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/01/16.
//

import Swinject
@testable import LighthouseVIPER

class MainSceneTestDI: Assembly {
    
    func assemble(container: Container) {
        // Wrapper は Mock
        AuthServiceTestDI().assemble(container: container)
        // useCase はプロダクトコード
        MainUseCaseDI().assemble(container: container)
        // 参照側で簡易に取得したため Mock は実態を一旦DIする
        container.register(MainRouterMock.self) { _ in MainRouterMock() }
            .inObjectScope(.container)
        container.register(MainRouterRegistry.self) { r in
            { _ in
                r.require(MainRouterMock.self)
            }
        }
    }
}



