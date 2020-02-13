//
//  LoginViewController.swift
//  gsTask0213
//
//  Created by hdymacuser on 2020/02/12.
//  Copyright © 2020 GentaNakahara. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tapSignUpButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        if email.isEmpty {
            showErrorAlert(text: "メールアドレスを入力してください")
            return
        }
        if password.isEmpty {
            showErrorAlert(text: "パスワードを入力してください")
            return
        }
        emailSignUp(email: email, password: password)
    }
    
    @IBAction func tapLogInButton(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        if email.isEmpty {
            showErrorAlert(text: "メールアドレスを入力してください")
            return
        }
        if password.isEmpty {
            showErrorAlert(text: "パスワードを入力してください")
            return
        }
        emailLogIn(email: email, password: password)
    }
    
    func emailSignUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.signUpErrorAlert(error)
                } else {
                    self.presentTaskListPage()
                }
            }
        }
        
        func emailLogIn(email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    self.logInErrorAlert(error)
                } else {
                    self.presentTaskListPage()
                }
            }
        }
        
        func signUpErrorAlert(_ error: Error){
            if let errCode = AuthErrorCode(rawValue: error._code) {
                var message = ""
                switch errCode {
                case .invalidEmail:
                    message = "有効なメールアドレスを入力してください"
                case .emailAlreadyInUse:
                    message = "既に登録されているメールアドレスです"
                case .weakPassword:
                    message = "パスワードは６文字以上で入力してください"
                default:
                    message = "エラー: \(error.localizedDescription)"
                }
                showErrorAlert(text: message)
            }
        }
        
        func logInErrorAlert(_ error: Error){
            if let errCode = AuthErrorCode(rawValue: error._code) {
                var message = ""
                switch errCode {
                    case .userNotFound:
                        message = "アカウントが見つかりませんでした"
                    case .wrongPassword:
                        message = "パスワードを確認してください"
                    case .userDisabled:
                        message = "アカウントが無効になっています"
                    case .invalidEmail:
                        message = "Eメールが無効な形式です"
                    default: message = "エラー: \(error.localizedDescription)"
                }
                showErrorAlert(text: message)
            }
        }
        
        func presentTaskListPage() {
            // xib で作るよりも長くなる...
            // 開発現場では 1Storyboard1VC が基本
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateInitialViewController() else {
                print("viewController がないよ。。。")
                return
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        
    }
