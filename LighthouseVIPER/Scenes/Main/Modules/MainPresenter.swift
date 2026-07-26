//
//  MainPresenter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import Foundation
import Combine

/**
 ユーザーストーリ
  1. ユーザは、id, password を入力する
  2. 入力後にフォーカスが外れると ログインボタンの活性状態を判定する
  3. ログインボタンをタップすると、ログイン処理を行う
  4. ログインが成功すると次画面を表示する
  5. ログイン失敗するとエラーワーディングを表示する
 */
protocol MainPresenterInput: AnyObject {
    
    func onViewDidLoad()
    
    func onViewWillAppear()
    
    func focusOut(id: String?, password: String?)
    
    func tappedLogin() -> LiTaskHandler

    func onViewDidDisappear()
}

protocol MainPresenterOutput: AnyObject {
        
    var update: LiAsyncStream.Subject<MainViewState> { get }
}

protocol MainPresentation: AnyPresenter {
    
    var input: MainPresenterInput { get }
    
    var output: MainPresenterOutput { get }
    
    var viewState: LiAsyncStream.Latest<MainViewState> { get }
}

final class MainPresenter: MainPresentation, MainPresenterOutput {
    
    // input
    var input: MainPresenterInput { return self }
    
    // output
    var output: MainPresenterOutput { return self }
    let update = LiAsyncStream.Subject<MainViewState>()
        
    // viewState
    let viewState: LiAsyncStream.Latest<MainViewState>
    
    let useCase: MainUseCase
    let router: MainRouting
    
    // 共通Presenter は画面のpresenterにコンポジションする。assemblerからinit時に注入される
    private let mainFlowMediator: AuthFlowMediator
    
    private var streamCancellables = LiAsyncStream.Cancellables()
    private var tappedLoginHandler = Set<LiTaskHandler>()
    
    init(
        useCase: MainUseCase,
        router: MainRouting,
        mainFlowMediator: AuthFlowMediator,
        viewState: MainViewState = MainViewState(),
    ) {
        LogUtil.debug()
        self.useCase = useCase
        self.router = router
        self.mainFlowMediator = mainFlowMediator
        self.viewState = LiAsyncStream.Latest(viewState)
        subscribeMainFlowInput()
    }
    
    deinit {
        streamCancellables.cancelAll()
        streamCancellables.removeAll()
        tappedLoginHandler.forEach { $0.cancel() }
        tappedLoginHandler.removeAll()
    }
}

// MARK: MainPresenterInput

extension MainPresenter: MainPresenterInput {

    func onViewDidLoad() {
    }
    
    func onViewWillAppear() {
        viewState.value.setLoginButtonEnable()
        output.update.yield(viewState.value)
    }
    
    func focusOut(id: String?, password: String?) {
        viewState.value.id = id ?? ""
        viewState.value.password = password ?? ""
        viewState.value.setLoginButtonEnable()
        output.update.yield(viewState.value)
    }
    
    func tappedLogin() -> Task<Void, Never> {
        LogUtil.debug("tappedLogin")
        return Task { [weak self] in
            guard let self else { return }
            await requestLogin()
        }
        .refresh(in: &tappedLoginHandler)
    }
    
    private func requestLogin() async {
        LogUtil.debug("requestLogin")
        do {
            try await useCase.login.execute(.init(
                id: viewState.value.id,
                password: viewState.value.password
            ))
            if Task.isCancelled { return }
            LogUtil.debug("login success")
            viewState.value.noticeLabelHidden = true
            router.goSecondUI(reply: viewState.value.id)
        } catch {
            if Task.isCancelled { return }
            LogUtil.debug("login failure")
            viewState.value.setInvalidInputState()
            output.update.yield(viewState.value)
        }
    }
    
    func onViewDidDisappear() {
        
    }
    
    func subscribeMainFlowInput() {
        
        mainFlowMediator.popValue
            .sink { [weak self] value in
                guard let self else { return }
                LogUtil.debug()
                viewState.value.id = value
                output.update.yield(viewState.value)
                LogUtil.debug()
            }
            .store(in: &streamCancellables)
    }
    
}
