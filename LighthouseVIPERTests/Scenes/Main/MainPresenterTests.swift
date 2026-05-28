//
//  MainPresenterTests.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/01/16.
//

import Cuckoo
import XCTest
import Swinject
@testable import LighthouseVIPER

final class MainPresenterTests: XCTestCase {
    
    var presenter: MainPresentation!
    var routerMock: MainRouting!
    var mockAuthWrapper: MockAuthWrapper!
    var mainFlowMediator: MainFlowMediator!
    var authRepository: AuthRepository!
    var cancellables = LiAsyncStream.Cancellables()
    var container: Container!
    
    override func setUp() {
        container = Container()
        AppScope().assemble(container: container)
        MainFlowScope().assemble(container: container)
        MainSceneTestDI().assemble(container: container)
        let assembler = MainSceneAssembler(container)
        presenter = assembler.presenter()
        routerMock = container.require(MainRouterRegistry.self)(nil)
        mainFlowMediator = container.require(MainFlowMediator.self)
        authRepository = container.require(AuthRepository.self)
        mockAuthWrapper = container.require(AuthWrapper.self) as? MockAuthWrapper
    }
    
    override func tearDown() {
        container = nil
        presenter = nil
        routerMock = nil
        mockAuthWrapper = nil
        mainFlowMediator = nil
        authRepository = nil
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
        mockAuthWrapper.givenAuthentication()
        
        // when
        let task = presenter.input.tappedLogin()
        let task2 = presenter.input.tappedLogin()
        await task.value
        await task2.value
        
        // then
        XCTAssertTrue(presenter.viewState.value.noticeLabelHidden)
//        XCTAssertTrue(routerMock.)
        XCTAssertEqual(authRepository.id, "id")
        XCTAssertEqual(authRepository.password, "password")
    }
    
    func test_onTappedLogin_failure() async throws {
        // given
        presenter.viewState.value.id = "any"
        presenter.viewState.value.password = "any"
        mockAuthWrapper.givenAuthentication()
        // when
        let task = presenter.input.tappedLogin()
        await task.value

        // then
        XCTAssertEqual(presenter.viewState.value.id, "")
        XCTAssertEqual(presenter.viewState.value.password, "")
        XCTAssertFalse(presenter.viewState.value.noticeLabelHidden)
        XCTAssertFalse(presenter.viewState.value.loginButtonEnable)
//        XCTAssertFalse(routerMock.isGoNextCalled)
    }
    
    func test_nextScreen_back() {
        // given
        let otherFLowMediator = container.require(MainFlowMediator.self)
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
        otherFLowMediator.popValue.yield("any")
        
        // then
        wait(for: [exp], timeout: 5)
        XCTAssertEqual(actualValue, "any")
    }
    
    @MainActor
    func test_MainAssemblySuccess() throws {
        // given
        // TODO: MainSceneDIの実施順序は、MainSceneAssemblerのnavigationController()を呼び出す前でなければならないため、Test用に変えて本番環境を使うテストは別モジュールで実施する
        // when
        let navi = MainSceneAssembler(container).navigationController()
        //
        let vc = try XCTUnwrap(navi?.viewControllers.first as? MainViewController)
        XCTAssertNotNil(vc.presenter)
    }
    
    @MainActor
    func test_SecondDI_resolve_Success() {
        
        // given
        // MainFLowScope が立ち上がったcontainer を引き継いでSecondViewを assembleする
        SecondSceneDI().assemble(container: container)
        // when
        // SecondViewを生成する際に、MainFlowScopeのmediatorをSecondPresenterに注入する。
        // これができていれば、SecondViewはMainFlowScopeのmediatorを通じてMainViewと通信できる。
        let vc = SecondAssembler(container).viewController(reply: "any")
        // then
        let viewState = vc.presenter.viewState.value as SecondViewState
        XCTAssertEqual(viewState.id, "any")
    }
}
