//
//  AuthWrapperMock.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02//27.
//

import Foundation
@testable import LighthouseVIPER

class AuthWrapperMock: AuthWrapper {
    
    var id: String?
    var password: String?

    func authentication(id: String, password: String) async throws {
        
        guard await self.id == id, await self.password == password else {
            throw AuthError()
        }
    }
}
