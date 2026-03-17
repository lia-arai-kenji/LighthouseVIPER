//
//  MainViewState.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/01/23.
//

import Foundation

// MainView状態と初期値
struct MainViewState {
    var transaction: Int = 0
    var screenId: ScreenId?
    /// idField
    var id: String = ""
    /// passwordField
    var password: String = ""
    /// noticeLabel
    var noticeLabelHidden: Bool = true
    /// loginButton
    var loginButtonEnable: Bool = false
    
    mutating func setLoginButtonEnable() {
        guard !id.isEmpty && !password.isEmpty else {
            loginButtonEnable = false
            return
        }
        loginButtonEnable = true
    }
        
    mutating func setInvalidInputState() {
        id = ""
        password = ""
        noticeLabelHidden = false
        loginButtonEnable = false
    }
}
