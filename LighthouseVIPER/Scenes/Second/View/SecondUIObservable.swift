//
//  SecondUIObservable.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/03/30.
//

import SwiftUI
import Combine

@MainActor
class SecondUIObservable: ObservableObject {
    
    var presenter: any SecondPresentation
    var cancellables = LiAsyncStream.Cancellables()
    
    @Published var viewState = SecondViewState()
    
    init(presenter: any SecondPresentation) {
        self.presenter = presenter
        self.viewState = presenter.viewState.value
        self.bind()
    }
    
    func bind() {
        presenter.output.update.sink { [weak self] viewState in
            guard let self else { return }
            Task {
                self.viewState = viewState
            }
        }
        .store(in: &cancellables)
    }
    
    deinit {
        cancellables.cancelAll()
        cancellables.removeAll()
    }
}


// MARK: SwiftUI Preview

extension SecondUIObservable {
    
    static func preview(viewState: SecondViewState) -> SecondUIObservable {
        let presenter = SecondAssembler.preview(reply: "")
        presenter.viewState.value = viewState
        return SecondUIObservable(presenter: presenter)
    }
}
