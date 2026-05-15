//
//  AuthServiceTests.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/05.
//

import Cuckoo
import XCTest
import Swinject
@testable import LighthouseVIPER

class AuthServiceTests: XCTestCase {

    var service: AuthService!
    var repository: AuthRepository!
    var wrapper: MockAuthWrapper!
    
    override func setUp() {
        let container = Container()
        AppScope().assemble(container: container)
        AuthServiceTestDI().assemble(container: container)
        service = container.require(AuthService.self)
        repository = container.require(AuthRepository.self)
        wrapper = (container.require(AuthWrapper.self) as? MockAuthWrapper)
    }
    
    override func tearDown() {
        service = nil
    }
    
    func test_authenticationSuccess() async throws {
        // given
        wrapper.givenAuthentication()
//        wrapper.id = "id"
//        wrapper.password = "password"
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
        wrapper.givenAuthentication()
//        wrapper.id = "id"
//        wrapper.password = "password"
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
