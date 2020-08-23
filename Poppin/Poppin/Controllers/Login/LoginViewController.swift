//
//  LoginViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/16/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Login Page UI Controller.
final class LoginViewController: UIViewController {
    
    // Firebase Auth wrapper.
    lazy private var authController = AuthController()
    
    /// Overrides superclass method to initialize the root view with a custom UI.
    override func loadView() {
        
        self.view = LoginView()
        
    }

    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LoginView else { return }
        
        // 2. Setting targets and delegation.
        _ = [view.emailTextField, view.passwordTextField].map { $0.delegate = self }
        
        view.forgotPasswordButton.addTarget(self, action: #selector(transitionToPasswordRecovery), for: .touchUpInside)
        view.signUpButton.addTarget(self, action: #selector(transitionToSignUp), for: .touchUpInside)
        view.loginButton.addTarget(self, action: #selector(performLogin(sender:)), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to reset input fields.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LoginView else { return }
        
        // 2. Resets previously entered credentials if any.
        view.resetInputFields()
        
    }
    
    // Pushes a new sign up page or pops to a previous one if found.
    @objc private func transitionToSignUp() {
        
        if let firstAfterRootVC = navigationController?.viewControllers[1] as? SignUpFirstPageViewController {
            
            navigationController?.popToViewController(firstAfterRootVC, animated: true)
            
        } else {
            
            navigationController?.pushViewController(SignUpFirstPageViewController(), animated: true)
            
        }
        
    }
    
    // Presents a password recovery page.
    @objc private func transitionToPasswordRecovery() {
        
        present(PasswordRecoveryViewController(), animated: true, completion: nil)
        
    }
    
    // Performs login with the inputed credentials. If successful, it dismisses the login page.
    @objc private func performLogin(sender: LoadingButton) {
        
        // 1. Safe cast root view to custom view.
        guard let view = view as? LoginView else { return }
        
        // 2. Empty input safe check. If fails, show error.
        if let email = view.emailTextField.text, let password = view.passwordTextField.text, email != "", password != "" {
            
            // 3. Login button shows loading indicator.
            view.loginButton.startLoading()
            
            // 4. Perform sign in (firebase).
            authController.signIn(email, password) { [weak self] (result, error, errorTitle, errorMessage) in
                
                guard let self = self else { return }
                
                // 5. Error found. Stop showing loading indicator and display error.
                if error != nil {
                    
                    view.loginButton.stopLoading()
                    
                    let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
                    let alertVC = AlertViewController(alertTitle: errorTitle, alertMessage: errorMessage, alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    
                    // 7. Email verification check. If fails, stop loading, show error.
                    if !result!.user.isEmailVerified {
                        
                        // 8. Core Data.
                        
//                        DataController.eraseAll(forEntity: "User")
//                        DataController.addUser(notificationName: .userSignedIn)
//                        DataController.eraseAll(forEntity: "OtherAccounts")
//                        DataController.eraseAll(forEntity: "RecentSearches")
//
//
//                        let orgRef = Firestore.firestore().collection("users")
//
//                        orgRef.document(Auth.auth().currentUser!.uid).getDocument{ (document, error) in
//                            if let document = document, document.exists {
//                                let data = document.data()
//                                let orgs = data?["orgs"] as? [String: Any] ?? [:]
//                                let userIDs: [String] = Array(orgs.keys)
//
//                                if userIDs.isEmpty {
//                                    return
//                                }
//
//                                for userId in userIDs {
//
//                                    orgRef.document(userId).getDocument{ (document, error) in
//                                        let data = document?.data()
//
//                                        let username = data?["username"] as? String ?? ""
//                                        let uid = userId
//                                        let bio = data?["bio"] as? String ?? ""
//                                        let fullName = data?["fullName"] as? String ?? ""
//
//                                        DataController.addAccount(bio: bio, username: username, fullName: fullName, uid: uid)
//                                    }
//
//                                }
//
//                            } else {
//                                print("Document does not exist")
//                            }
//                        }
                        
                        // 9. Close login page.
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        
                    } else {
                        
                        view.loginButton.stopLoading()
                        
                        let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
                        
                        let button2 = AlertButton(alertTitle: "Resend", alertButtonAction: { [weak self] in
                         
                            guard let self = self else { return }
                            
                            // 10. Email verification link re-sent. Show query result after.
                            self.authController.sendEmailVerification { (error) in
                                
                                if error != nil {
                                 
                                    let button3 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
                                    
                                    let alertVC = AlertViewController(alertTitle: AlertViewController.defaultAlertTitle, alertMessage: AlertViewController.defaultAlertMessage, alertButtons: [button3])
                                    
                                    self.present(alertVC, animated: true, completion: nil)
                                    
                                } else {
                                    
                                    let button3 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
                                 
                                    let alertVC = AlertViewController(alertTitle: "Verification sent!", alertMessage: "Check your email for a verification link. If you do not receive one, check your spam folder.", alertButtons: [button3])
                                    
                                    self.present(alertVC, animated: true, completion: nil)
                                    
                                }
                                    
                                
                            }
                            
                        })
                        
                        let alertVC = AlertViewController(alertTitle: "Email not verified", alertMessage: "If you did not get a verification email, check your spam folder or click resend.", alertButtons: [button1, button2])
                        
                        self.present(alertVC, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
            let alertVC = AlertViewController(alertTitle: AlertViewController.defaultAlertTitle, alertMessage: AlertViewController.defaultAlertMessage, alertButtons: [button1])
            
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    /**
    Delegate function triggered by the return button on the keyboard. Hops to the next input field or peforms the login.

    - Parameters:
        - textField: Input field that returned
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LoginView else { return true }
        
        textField.resignFirstResponder()
        
        if textField == view.emailTextField {
            
            view.passwordTextField.becomeFirstResponder()
            
        } else if textField == view.passwordTextField {
            
            performLogin(sender: view.loginButton)
            
        }
        
        return true
        
    }
    
}


