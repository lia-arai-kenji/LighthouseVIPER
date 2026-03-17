//
//  WebAPIDI.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/02/16.
//

import Swinject

struct WebAPIAssembly {
    
    static func register() -> Container {
        let service = Container()
        // この状態だと新規インタンスになるため、
        // Appから持ち回した Resolver で resolve すると一意のrepository を引き続き参照できる
        service.register(AppRepository.self) { _ in AppRepository() }
            .inObjectScope(.container)
        
        service.register(WebApiWrapper.self) { _ in WebApiWrapperImpl() }

        service.register(WebApiService.self) { r in

            WebApiServiceImpl(
                repository: r.resolve(AppRepository.self)!,
                wrapper: r.resolve(WebApiWrapper.self)!
            )
        }
        return service
    }
}
