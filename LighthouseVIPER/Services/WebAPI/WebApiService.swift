//
//  WebApiRepository.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/12.
//

import Foundation

// MARK: protocol
protocol WebApiService {
    
    func getGreetingSentence(word: String) async -> String
    
    func fetchGreetingReply(greeting: String) async -> String
}

// MARK: Implements
extension WebApiServiceImpl {

    func getGreetingSentence(word: String) async -> String {
        LogUtil.debug(word)
        return await withCheckedContinuation { (continuation: CheckedContinuation<String, Never>) in
            Task {
                let result = await wrapper.getGreetingSentence(word: word)
                continuation.resume(returning: "Hello, \(result)!")
            }
        }
    }

    func fetchGreetingReply(greeting: String) async -> String {
        LogUtil.debug()
        return await wrapper.fetchGreetingReply(greeting: greeting)
    }
}

// MARK: class definition
final class WebApiServiceImpl: WebApiService {
    
    let repository: AppRepository
    let wrapper: WebApiWrapper
    
    init(repository: AppRepository, wrapper: WebApiWrapper) {
        self.repository = repository
        self.wrapper = wrapper
    }
    
}
