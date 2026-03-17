//
//  MainPresenterTests.swift
//  LighthouseVIPER
//
//  Created by udwiqut on 2026/01/16.
//

import XCTest
import Swinject
@testable import LighthouseVIPER

final class MainPresenterTests: XCTestCase {
    
    var presenter: MainPresentation!
    var loginMock: LoginInteractorMock!
    var routerMock: MainRouterMock!
    var authWrapperMock: AuthWrapperMock!
    var mainFlowPresenter: MainFlowPresenter!
    var cancellables = LiAsyncStream.Cancellables()
    var container: Container!
    
    override func setUp() {
        container = Container()
        AppAssembly().assemble(container: container)
        MainFlowAssembly().assemble(container: container)
        let assembler = MainPresenterTestAssembler(container: container)
        presenter = assembler.assemble()
        routerMock = assembler.mockRouter
        mainFlowPresenter = assembler.mainFlowPresenter
        authWrapperMock = assembler.container.resolve(AuthWrapper.self) as? AuthWrapperMock
    }
    
    override func tearDown() {
        presenter = nil
        loginMock = nil
        routerMock = nil
        authWrapperMock = nil
        mainFlowPresenter = nil
        container = nil
        cancellables.cancelAll()
        cancellables.removeAll()
    }
    
    func test_onViewWillAppear() throws {
        // given
        let expectation = XCTestExpectation(description: "test_onViewDidLoad")
        var actualEntity: MainViewState?
        presenter.output.update
            .sink { entity in
                actualEntity = entity
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        presenter.input.onViewWillAppear()
        
        // then
        wait(for: [expectation], timeout: 0.1)
        let safeEntity = try XCTUnwrap(actualEntity)
        XCTAssertEqual(safeEntity.id, presenter.viewState.value.id)
        XCTAssertEqual(safeEntity.password, presenter.viewState.value.password)
        XCTAssertEqual(safeEntity.noticeLabelHidden, presenter.viewState.value.noticeLabelHidden)
    }
    
    func test_focusOut() throws {
        // when
        presenter.input.focusOut(id: "", password: "")
        // then
        XCTAssertFalse(presenter.viewState.value.loginButtonEnable)
    }
    
    func test_onTappedLogin_success() async throws {
        // given
        presenter.viewState.value.id = "id"
        presenter.viewState.value.password = "password"
        authWrapperMock.id = "id"
        authWrapperMock.password = "password"
        
        // when
        let task = presenter.input.tappedLogin()
        let task2 = presenter.input.tappedLogin()
        await task.value
        await task2.value

        // then
        XCTAssertTrue(presenter.viewState.value.noticeLabelHidden)
        XCTAssertTrue(routerMock.isGoNextCalled)
    }
    
    func test_onTappedLogin_failure() async throws {
        presenter.viewState.value.id = "id"
        presenter.viewState.value.password = "password"
        authWrapperMock.id = "any"
        authWrapperMock.password = "any"
        
        // when
        let task = presenter.input.tappedLogin()
        await task.value

        // then
        XCTAssertEqual(presenter.viewState.value.id, "")
        XCTAssertEqual(presenter.viewState.value.password, "")
        XCTAssertFalse(presenter.viewState.value.noticeLabelHidden)
        XCTAssertFalse(presenter.viewState.value.loginButtonEnable)
        XCTAssertFalse(routerMock.isGoNextCalled)
    }
    
    func test_nextScreen_back() {
        // given
        let otherFLowPresenter = container.resolve(MainFlowPresenter.self)
        presenter.viewState.value.id = "id"
        
        let exp = expectation(description: "test_nextScreen_back")
        var actualValue: String?
        presenter.output.update
            .sink { value in
                actualValue = value.id
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        otherFLowPresenter?.popValue.yield("any")
        
        // then
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(actualValue, "any")
    }
}

