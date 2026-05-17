//
//  WebApiServiceMock.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/01/23.
//

import Foundation
@testable import LighthouseVIPER

final class WebApiServiceMock: WebApiService {
    
    var abc: String = ""
    func getGreetingSentence(word: String) async -> String {
        return abc
    }
    
    func fetchGreetingReply(greeting: String) async -> String {
        return ""
    }
}
