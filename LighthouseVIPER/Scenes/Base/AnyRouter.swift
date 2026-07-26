//
//  AnyRouter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/06/05.
//

import UIKit

protocol AnyRouter: AnyObject {
    var indicator: IndicatorRouting { get }
    var dialog: DialogRouting { get }
}

// MARK: NavigationRouting
protocol NavigationRouting: AnyObject {
    func push(vc: UIViewController)
    func present(modal: UIViewController)
    func pop()
}

class NavigationRouter: NavigationRouting {
    
    private let instance: UIViewController?
    
    init(instance: UIViewController?) {
        self.instance = instance
    }
    
    func push(vc: UIViewController) {
        Task { @MainActor in
            instance?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func pop() {
        Task { @MainActor in
            instance?.navigationController?.popViewController(animated: true)
        }
    }
    
    func present(modal: UIViewController) {
        Task { @MainActor in
            instance?.present(modal, animated: true)
        }
    }
    
    func dismiss() {
        Task { @MainActor in
            instance?.dismiss(animated: true)
        }
    }
}

// MARK: IndicatorRouting
protocol IndicatorRouting {
    func show()
    func hide()
}

class IndicatorRouter: IndicatorRouting {

    private weak var instance: UIViewController?
    
    init(instance: UIViewController?) {
        self.instance = instance
    }
    
    func show() {
        LogUtil.debug()
    }
    
    func hide() {
        LogUtil.debug()
    }
}

protocol DialogRouting {
    func show() async -> Bool
}

class DialogRouter: DialogRouting {
    
    private weak var instance: UIViewController?
    
    init(instance: UIViewController?) {
        self.instance = instance
    }
    
    func show() async -> Bool {
        return false
    }
}
