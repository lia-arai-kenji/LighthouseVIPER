//
//  MainUseCase.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/05.
//

import Foundation

class MainUseCase {
    
    var login: AuthLoginUseCase
    var signUp: AuthSignUpUseCase
        
    init(login: AuthLoginUseCase, signUp: AuthSignUpUseCase) {
        self.login = login
        self.signUp = signUp
    }
}
