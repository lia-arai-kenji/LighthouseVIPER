//
//  IndicatorPresenter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/06/04.
//

import UIKit
import Swinject

protocol AnyPresenter: AnyObject {}

protocol AnyPresentableProviding: AnyObject {}

protocol AnyPresentable where Self: AnyPresenter {
    
}
