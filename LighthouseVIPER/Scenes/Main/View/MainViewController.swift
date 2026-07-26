//
//  MainViewController.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/02/10.
//

import UIKit
import Combine


/// ViewController の共通処理定義、例）テキストフィールドの共通処理など
protocol ExampleProtocol: AnyObject where Self: UIViewController {
    
    var ideField: UITextField! { get }
}

/// 表記揺れなどで protocol に適合しない場合に、適合させるための拡張
extension ExampleProtocol where Self: MainViewController {
    @MainActor
    var ideField: UITextField! {
        return passwordField
    }
}
extension ExampleProtocol where Self: SecondViewController {

    var ideField: UITextField! {
        return UITextField()
    }
}

/// 共通処理の実装
extension ExampleProtocol {
    @MainActor
    func exampleMethod() {
        ideField.text = "Hello"
    }
}

extension MainViewController: ExampleProtocol {}

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
        exampleMethod()
    }
    
    deinit {
        cancellables.cancelAll()
        cancellables.removeAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        presenter.input.focusOut(id: idField.text, password: passwordField.text)
    }
    
    private func configureViews() {
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
        // 非同期あり、完了を待たない
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
