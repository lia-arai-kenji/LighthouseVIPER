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
protocol MainPresenterInput {
    
    func onViewDidLoad()
    
    func onViewWillAppear()
    
    func focusOut(id: String?, password: String?)
    
    func tappedLogin() -> LiTaskHandler

    func onViewDidDisappear()
    
    func onDeinit()
}

protocol MainPresenterOutput {
        
    var update: LiAsyncStream.Subject<MainViewState> { get }
}


protocol MainPresentation {
    
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
    let mainFlowPresenter: MainFlowPresenter
    
    var streamCancellables = LiAsyncStream.Cancellables()
    var tappedLoginHandler = Set<LiTaskHandler>()
    
    init(
        viewState: MainViewState,
        useCase: MainUseCase,
        router: MainRouting,
        mainFlowPresenter: MainFlowPresenter,
    ) {
        LogUtil.debug()
        self.viewState = LiAsyncStream.Latest(viewState)
        self.useCase = useCase
        self.router = router
        self.mainFlowPresenter = mainFlowPresenter
        subscribeMainFlowInput()
    }
    
    deinit {
        streamCancellables.cancelAll()
        streamCancellables.removeAll()
        tappedLoginHandler.forEach { $0.cancel() }
        tappedLoginHandler.removeAll()
    }
}

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
    
    func tappedLogin() -> LiTaskHandler {
        LogUtil.debug("tappedLogin")
        return LiTaskHandler { await self.requestLogin() }
            .cancelPrevious(in: &tappedLoginHandler)
            .store(in: &tappedLoginHandler)
    }
    
    private func requestLogin() async {
        LogUtil.debug("requestLogin")
        do {
            try await useCase.login.execute(
                AuthContracts.Login.Params(
                    id: viewState.value.id,
                    password: viewState.value.password
                )
            )
            if Task.isCancelled { return }
            LogUtil.debug("login success")
            viewState.value.noticeLabelHidden = true
            router.goNext(reply: viewState.value.id)
        } catch {
            if Task.isCancelled { return }
            LogUtil.debug("login failure")
            viewState.value.setInvalidInputState()
            output.update.yield(viewState.value)
        }
    }

    func onViewDidDisappear() {
        
    }
    
    func onDeinit() {

    }
    
    func subscribeMainFlowInput() {
        
        mainFlowPresenter.popValue
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
