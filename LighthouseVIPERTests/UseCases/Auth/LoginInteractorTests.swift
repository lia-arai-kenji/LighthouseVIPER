//
//  LoginInteractorTests.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/19.
//

import XCTest
import Swinject
@testable import LighthouseVIPER

class LoginInteractorTests: XCTestCase {
    
    var LoginInteractor: LoginInteractor!
    var repository: AuthRepository!
    var wrapper: AuthWrapper!
    
    override func setUp() {
        super.setUp()
        let container = Container()
        AppScope().assemble(container: container)
        repository = container.require(AuthRepository.self)


        
    }
        
}
