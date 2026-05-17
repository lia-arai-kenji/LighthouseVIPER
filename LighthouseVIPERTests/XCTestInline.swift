//
//  TestHelper.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/11.
//

import XCTest

    
func waitUntil(
    timeout: TimeInterval,
    interval: TimeInterval = 0.01,
    condition: @escaping () -> Bool
) async throws {
    let deadline = Date().addingTimeInterval(timeout)
    
    while Date() < deadline {
        if condition() { return }
        try await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    }
    
    XCTFail("Condition was not satisfied within \(timeout) seconds.")
}

func assertEventually(
    timeout: TimeInterval = 1.0,
    interval: TimeInterval = 0.01,
    file: StaticString = #filePath,
    line: UInt = #line,
    _ condition: @escaping () -> Bool
) async {
    let deadline = Date().addingTimeInterval(timeout)
    
    while Date() < deadline {
        if condition() { return }
        try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
    }
    
    XCTFail("Condition was not satisfied within \(timeout) seconds", file: file, line: line)
}
