//
//  SecondRouter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import Swinject

protocol SecondRouting {
    
    func goBack()
}

@MainActor
class SecondRouter: SecondRouting {
    
    var instance: SecondViewController
    var container: Container
        
    init(instance: SecondViewController, container: Container) {
        LogUtil.debug()
        self.instance = instance
        self.container = container
    }
    
    func goBack() {
        LogUtil.debug()
        instance.navigationController?.popViewController(animated: true)
    }
    
}
