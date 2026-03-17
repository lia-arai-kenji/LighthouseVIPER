//
//  AppAssembly.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02/16.
//

import Swinject

// アプリ全体を通して保持したい要素を定義する
struct AppAssembly: Assembly {
    
    func assemble(container: Container) {
                
        container.register(AuthRepository.self) { _ in AuthRepository() }
            .inObjectScope(.container) // singleton
        
        container.register(AppRepository.self) { _ in AppRepository() }
            .inObjectScope(.container) // singleton        
    }
}

