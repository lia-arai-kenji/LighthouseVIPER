//
//  WebApiServiceDI.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/02/16.
//

import Swinject

struct WebAPISerivceDI {
    
    static func register() -> Container {
        let service = Container()
        // この状態だと新規インタンスになるため、
        // Appから持ち回した Resolver で resolve すると一意のrepository を引き続き参照できる
        service.register(AppRepository.self) { _ in AppRepository() }
            .inObjectScope(.container)
        
        service.register(WebApiWrapper.self) { _ in WebApiWrapperImpl() }

        service.register(WebApiService.self) { r in

            WebApiServiceImpl(
                repository: r.require(AppRepository.self),
                wrapper: r.require(WebApiWrapper.self)
            )
        }
        return service
    }
}
