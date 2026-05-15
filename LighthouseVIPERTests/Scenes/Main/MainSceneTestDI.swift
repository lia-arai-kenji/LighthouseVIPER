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
        MainModulesDI().assemble(container: container)
//        // 参照側で簡易に取得したため Mock は実態を一旦DIする
//        container.register(MainRouting.self) { [unowned container ] r in
//            r.requir.self)(nil)
//            MainRouter(instance: nil, container: container)
//        }.inObjectScope(.container)
//        container.register(MainRouterRegistry.self) { r in
//            { _ in
//                r.require(MainRouting.self)
//            }
//        }
    }
}



