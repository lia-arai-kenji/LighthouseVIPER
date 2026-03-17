//
//  MainRotureMock.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/01/16.
//

@testable import LighthouseVIPER

final class MainRouterMock: MainRouting {
    
    var isGoNextCalled = false
    
    func goNext(reply: String) {
        isGoNextCalled = true
    }
    
    
}
