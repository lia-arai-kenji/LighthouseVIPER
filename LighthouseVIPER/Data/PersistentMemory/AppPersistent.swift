//
//  AppPersistent.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/05/19.
//

protocol AppPersistent: AnyObject {
    
    var isLoggedIn: Bool { get set }
}

final class AppPersistentImpl: AppPersistent {
    
    var isLoggedIn: Bool = false
    
}
