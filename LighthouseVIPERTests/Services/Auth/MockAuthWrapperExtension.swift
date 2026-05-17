//
//  MockAuthWrapperExtension.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/05/15.
//

import Cuckoo
@testable import LighthouseVIPER

extension MockAuthWrapper {
    
    func givenAuthentication() {
        stub(self) { stub in
            when(stub.authentication(id: any(), password: any())).then { id, password in
                if id == "id" && password == "password" {
                    return
                } else {
                    throw AuthError()
                }
            }
        }
    }
}
