//
//  AppConfig.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/04/13.
//

import Foundation

enum AppEnvironment: String {
    case production
    case stub
}

enum AppConfig {
    static var environment: AppEnvironment {
        let value = Bundle.main.object(forInfoDictionaryKey: "AppEnvironment") as? String ?? "production"
        return AppEnvironment(rawValue: value) ?? .production
    }

    static var useStub: Bool {
        let value = Bundle.main.object(forInfoDictionaryKey: "UseStub") as? String ?? "NO"
        return value == "YES"
    }

    static var apiBaseURL: String {
        Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String ?? ""
    }
}
