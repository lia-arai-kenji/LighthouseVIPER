//
//  SecondPresenter.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import Foundation
import Combine


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
    var input: any SecondPresenterInput { return self }

    // output
    var output: any SecondPresenterOutput { return self }
    let update = LiAsyncStream.Subject<SecondViewState>()
    
    // viewState
    let viewState: LiAsyncStream.Latest<SecondViewState>
        
    // 参照UseCaseの設定をこれに閉じ込めている
    let useCase: SecondUseCase
    let router: SecondRouting
    
    // 共通Presenter は画面のpresenterにコンポジションする。assemblerからinit時に注入する
    let mainFlowPresenter: MainFlowPresenter
    
    init(
        viewState: SecondViewState,
        useCase: SecondUseCase,
        router: SecondRouting,
        mainFlowPresenter: MainFlowPresenter,
    ) {
        LogUtil.debug()
        self.viewState = LiAsyncStream.Latest(viewState)
        self.useCase = useCase
        self.router = router
        self.mainFlowPresenter = mainFlowPresenter
    }
}

extension SecondPresenter: SecondPresenterInput {
    
    func onViewDidLoad() {
        output.update.yield(viewState.value)
    }
    
    func tapCallBack() {
        LogUtil.debug()
        router.goBack()
        mainFlowPresenter.popValue.yield("戻りました！")
    }
}
