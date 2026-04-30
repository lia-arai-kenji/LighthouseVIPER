//
//  SecondRouter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import Swinject
import SwiftUI

protocol SecondRouting {
    
    func goBack()
    func goUIBack()
}

@MainActor
class SecondRouter: @preconcurrency SecondRouting {
    
    var instance: SecondViewController
    var hosting: UIHostingController<SecondUI>?
    var container: Container
        
    init(instance: SecondViewController, hosting: UIHostingController<SecondUI>?, container: Container) {
        LogUtil.debug()
        self.instance = instance
        self.hosting = hosting
        self.container = container
    }
    
    func goBack() {
        LogUtil.debug()
        instance.navigationController?.popViewController(animated: true)
    }
    
    func goUIBack() {
        hosting?.navigationController?.popViewController(animated: true)
    }
}


// MARK: Preview

class PreviewSecondRouter: SecondRouting {
    
    func goBack() {}
    
    func goUIBack() {}
}
