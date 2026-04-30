//
//  SecondPresenter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import Foundation
import Combine
import SwiftUI

/**
 ユーザーストーリ
  1. 
  2. ボタンタップで stateを２個出力して sharedPresenter.callBack に通知する
  3. 画面を閉じて遷移元に戻ったら、sharedPresenter.callback の通知を受信して stateLabel を更新する
 */

protocol SecondPresenterInput {
    
    func onViewDidLoad()
    func tapCallBack()
}

protocol SecondPresenterOutput {
    var update: LiAsyncStream.Subject<SecondViewState> { get }
}

protocol SecondPresentation {
    
    var input: SecondPresenterInput { get }
    var output: SecondPresenterOutput { get }
    var viewState: LiAsyncStream.Latest<SecondViewState> { get }
}

final class SecondPresenter: SecondPresentation, SecondPresenterOutput {
    
    // input
    var input: (any SecondPresenterInput) { return self }

    // output
    var output: (any SecondPresenterOutput) { return self }
    internal let update = LiAsyncStream.Subject<SecondViewState>()
    
    // viewState
    internal let viewState: LiAsyncStream.Latest<SecondViewState>
        
    @Published  var state: SecondViewState
    // 参照UseCaseの設定をこれに閉じ込めている
    private let useCase: SecondUseCase
    var router: SecondRouting
    
    // 共通Presenter は画面のpresenterにコンポジションする。assemblerからinit時に注入する
    private let mainFlowMediator: MainFlowMediator
    
    init(
        viewState: SecondViewState,
        useCase: SecondUseCase,
        router: SecondRouting,
        mainFlowMediator: MainFlowMediator,
    ) {
        LogUtil.debug()
        self.viewState = LiAsyncStream.Latest(viewState)
        self.state = viewState
        self.useCase = useCase
        self.router = router
        self.mainFlowMediator = mainFlowMediator
    }
}

extension SecondPresenter: SecondPresenterInput {
    
    func onViewDidLoad() {
        if !viewState.value.isViewDidLoaded {
            output.update.yield(viewState.value)
            viewState.value.isViewDidLoaded = true
        }            
    }
    
    func tapCallBack() {
        LogUtil.debug()
        router.goBack()
        router.goUIBack()
        let id = viewState.value.id
        viewState.value.id += id
        output.update.yield(viewState.value)
        mainFlowMediator.popValue.yield("戻りました！")
    }
}
