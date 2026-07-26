//
//  MockMainRouterExtension.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/05/25.
//

import Cuckoo
@testable import LighthouseVIPER

extension MockMainRouting {
    
    func givenGoNext(reply: String? = nil) {
        stub(self) { stub in
            let goNext = if let reply {
                when(stub.goNext(reply: reply))
            } else {
                when(stub.goNext(reply: any()))
            }
            goNext.thenDoNothing()
        }
    }
    
    func givenGoSecondUI(reply: String? = nil) {
        stub(self) { stub in
            let goSecondUI = if let reply {
                when(stub.goSecondUI(reply: reply))
            } else {
                when(stub.goSecondUI(reply: any()))
            }
            goSecondUI.thenDoNothing()
        }
    }
}
