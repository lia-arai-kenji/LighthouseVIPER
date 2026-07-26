//
//  MainRouter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import SwiftUI
import Swinject

protocol MainRouting: AnyRouter {
    
    func goNext(reply: String)
    func goSecondUI(reply: String)
}

class MainRouter: MainRouting {
    
    weak var instance: UIViewController?
    let container: Container

    let navigation: any NavigationRouting
    let indicator: any IndicatorRouting
    let dialog: any DialogRouting
    
    init(instance: MainViewController?, container: Container) {
        LogUtil.debug()
        self.instance = instance
        self.container = container
        self.navigation = NavigationRouter(instance: instance)
        self.indicator = IndicatorRouter(instance: instance)
        self.dialog = DialogRouter(instance: instance)
    }
    
    func goNext(reply: String) {
        LogUtil.debug()
        SecondSceneDI().assemble(container: container)
        Task { @MainActor in
            // 画面間のデータ受け渡しはassmbler経由で行う
            let vc = SecondAssembler(container).viewController(reply: reply)
            navigation.push(vc: vc)
        }
    }
    
    func goSecondUI(reply: String) {
        let second = SecondAssembler(container)
        Task { @MainActor in
            let hosting = second.swiftUI(reply: reply)
            navigation.push(vc: hosting)
        }
    }
}
