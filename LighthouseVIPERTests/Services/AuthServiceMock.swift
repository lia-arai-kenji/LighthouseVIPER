//
//  AuthServiceMock.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02//27.
//

import Foundation
@testable import LighthouseVIPER

class AuthServiceMock: AuthService {
    
    func authentication(id: String, password: String) async throws {
        guard id == "id", password == "password" else {
            throw AuthError()
        }
    }
}
