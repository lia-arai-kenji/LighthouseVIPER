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

class SecondRouter: SecondRouting {

    weak var instance: SecondViewController?
    weak var hosting: UIHostingController<SecondUI>?
    
    let container: Container
    
    init(instance: SecondViewController, hosting: UIHostingController<SecondUI>?, container: Container) {
        LogUtil.debug()
        self.instance = instance
        self.hosting = hosting
        self.container = container
    }
    
    func goBack() {
        LogUtil.debug()
        Task { @MainActor in
            instance?.navigationController?.popViewController(animated: true)
        }
    }
    
    func goUIBack() {
        Task { @MainActor in
            hosting?.navigationController?.popViewController(animated: true)
        }
    }
}


// MARK: Preview

class PreviewSecondRouter: SecondRouting {
    
    func goBack() {}
    
    func goUIBack() {}
}
