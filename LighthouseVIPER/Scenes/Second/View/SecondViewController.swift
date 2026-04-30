//
//  SecondViewController.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import Combine

@MainActor
final class SecondViewController: UIViewController {
    
    @IBOutlet weak var replyLabel: UILabel!
    
    var presenter: SecondPresentation!
    var cancellables = LiAsyncStream.Cancellables()

    override func viewDidLoad() {
        configureViews()
        render()
        presenter.input.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogUtil.debug()
        presenter = nil
    }
    
    func configureViews() {
    }
    
    func render() {
        presenter.output.update
            .render(\.id, to: replyLabel, \.text)
            .store(in: &cancellables)
    }
    
    @IBAction func tapCallback(_ sender: Any) {
        presenter.input.tapCallBack()
    }
    
    deinit {
        LogUtil.debug()
    }
}
