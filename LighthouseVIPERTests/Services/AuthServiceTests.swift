//
//  AuthServiceTests.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/03/05.
//

import XCTest
import Swinject
@testable import LighthouseVIPER

class AuthServiceTests: XCTestCase {

    var service: AuthService!
    var repository: AuthRepository!
    var wrapper: AuthWrapperMock!
    
    override func setUp() {
        let container = Container()
        AppAssembly().assemble(container: container)
        AuthServiceTestDI().assemble(container: container)
        service = container.resolve(AuthService.self)
        repository = container.resolve(AuthRepository.self)
        wrapper = (container.resolve(AuthWrapper.self) as? AuthWrapperMock)
    }
    
    override func tearDown() {
        service = nil
    }
    
    func test_authenticationSuccess() async throws {
        // given
        wrapper.id = "id"
        wrapper.password = "password"
        // when
        do {
            try await service.authentication(id: "id", password: "password")
            // then
            XCTAssertEqual(repository.id, "id")
            XCTAssertEqual(repository.password, "password")
        } catch {
            XCTFail()
        }
    }
    
    func test_authenticationFailure() async throws {
        // given
        wrapper.id = "id"
        wrapper.password = "password"
        // when
        do {
            try await service.authentication(id: "any", password: "any")
            // then
            XCTFail()
        } catch let error {
            // then
            XCTAssertNotNil(error as? AuthError)
            XCTAssertNil(repository.id)
            XCTAssertNil(repository.password)
        }
    }
}
