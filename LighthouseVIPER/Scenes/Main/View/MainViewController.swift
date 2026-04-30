//
//  MainViewController.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import Combine

@MainActor
final class MainViewController: BaseViewController {
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!

    var presenter: MainPresentation!
        
    var cancellables = LiAsyncStream.Cancellables()
    
    override func viewDidLoad() {
        configureViews()
        render()
        presenter.input.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.input.onViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    deinit {
        cancellables.cancelAll()
        cancellables.removeAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        presenter.input.focusOut(id: idField.text, password: passwordField.text)
    }
    
    private func configureViews() {
        idField.delegate = self
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
    }

    private func render() {
        presenter.output.update
            .render(\.id, to: idField, \.text)
            .store(in: &cancellables)
        
        presenter.output.update
            .render(\.password, to: passwordField, \.text)
            .store(in: &cancellables)

        presenter.output.update
            .render(\.noticeLabelHidden, to: noticeLabel, \.isHidden)
            .store(in: &cancellables)
        
        presenter.output.update
            .render(\.loginButtonEnable, to: loginButton, \.isEnabled)
            .store(in: &cancellables)
    }
    
    @IBAction func tappedLogin(_ sender: Any) {
        LogUtil.debug()
        // テストコードでは実施結果を取得してAssertするが、プロダクトコードでは取得しないで投げっぱなし
        _ = presenter.input.tappedLogin()
        LogUtil.debug()
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        presenter.input.focusOut(id: idField.text, password: passwordField.text)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        presenter.input.focusOut(id: idField.text, password: passwordField.text)
    }
}
