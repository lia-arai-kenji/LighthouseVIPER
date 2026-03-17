//
//  AuthWrapperMock.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02//27.
//

import Foundation
@testable import LighthouseVIPER

class AuthWrapperMock: AuthWrapper {
    
    var id: String?
    var password: String?

    func authentication(id: String, password: String) async throws {
        guard self.id == id, self.password == password else {
            throw AuthError()
        }
    }
}
