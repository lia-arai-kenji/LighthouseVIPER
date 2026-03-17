//
//  SecondUseCase.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import Foundation

class SecondUseCase {

    var login: AuthLoginUseCase
    var signUp: AuthSignUpUseCase
    
    init(login: AuthLoginUseCase, signUp: AuthSignUpUseCase) {
        self.login = login
        self.signUp = signUp
    }
}
