//
//  WebApiWrapper.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/12.
//

import Foundation

protocol WebApiWrapper {
    
    func getGreetingSentence(word: String) async -> String
    
    func fetchGreetingReply(greeting: String) async -> String
}

final class WebApiWrapperImpl: WebApiWrapper {
    
    func getGreetingSentence(word: String) async -> String {
        LogUtil.debug(word)
        return "Hello \(word) !!"
    }
    
    func fetchGreetingReply(greeting: String) async -> String {
        LogUtil.debug(greeting)
        return "Hey !! \(greeting) !!"
    }
}
