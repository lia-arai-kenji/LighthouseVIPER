//
//  AssemblyExtension.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/04/16.
//

import Swinject

extension Resolver {
    
     func require<Service>(_ serviceType: Service.Type, file: StaticString = #fileID, line: UInt = #line) -> Service {
        guard let service = resolve(serviceType) else {
            fatalError("Failed to resolve \(serviceType)", file: file, line: line)
        }
        return service
    }
}
