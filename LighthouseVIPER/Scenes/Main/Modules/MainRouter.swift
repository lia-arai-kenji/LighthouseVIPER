//
//  MainRouter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import SwiftUI
import Swinject

protocol MainRouting: AnyObject {
    
    func goNext(reply: String)
    func goSecondUI(reply: String)
}

class MainRouter: MainRouting {
    
    weak var instance: MainViewController?
    let container: Container
    
    init(instance: MainViewController?, container: Container) {
        LogUtil.debug()
        self.instance = instance
        self.container = container
    }
    
    func goNext(reply: String) {
        LogUtil.debug()
        Task { @MainActor in
            // 画面間のデータ受け渡しはassmble経由で行う
            SecondSceneDI().assemble(container: container)
            let vc = SecondAssembler(container).viewController(reply: reply)
            instance?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goSecondUI(reply: String) {
        LogUtil.debug()
        Task { @MainActor in
            SecondSceneDI().assemble(container: container)
            let hosting = SecondAssembler(container).swiftUI(reply: reply)
            instance?.navigationController?.pushViewController(hosting, animated: true)
        }
    }
}
