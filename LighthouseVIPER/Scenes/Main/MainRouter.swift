//
//  MainRouter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import Swinject

protocol MainRouting {
    
    func goNext(reply: String)
}

class MainRouter: MainRouting {
    
    @MainActor
    weak var instance: MainViewController?
    let container: Container
    
    init(instance: MainViewController, container: Container) {
        LogUtil.debug()
        self.instance = instance
        self.container = container
    }
    
    func goNext(reply: String) {
        LogUtil.debug()
        Task { @MainActor in
            // 画面間のデータ受け渡しはassmble経由で行う
            let vc = SecondAssembler(container).assemble(reply: reply)
            instance?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
