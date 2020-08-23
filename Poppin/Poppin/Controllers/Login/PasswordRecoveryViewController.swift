//
//  PasswordRecoveryViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/21/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Password Recovery Page UI Controller.
final class PasswordRecoveryViewController: UIViewController {
    
    // Firebase Auth wrapper.
    lazy private var authController = AuthController()
    
    /**
    Overrides super class init to set the modal transition and presentation styles.

    - Parameters:
        - nibName: Nil since Storyboards are not used.
        - bundle: Nil since Bundles are not used.
     
    */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder from storyboard.
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Overrides superclass method to initialize the root view with a custom UI.
    override func loadView() {
        
        self.view = PasswordRecoveryView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? PasswordRecoveryView else { return }
        
        // 2. Setting targets and delegation.
        view.emailTextField.delegate = self
        
        view.sendLinkButton.addTarget(self, action: #selector(sendPasswordRecoveryLink), for: .touchUpInside)
        view.loginButton.addTarget(self, action: #selector(dismissPasswordRecovery), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to reset input fields.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? PasswordRecoveryView else { return }
        
        // 2. Resets previously entered credentials if any.
        view.resetInputFields()
        
    }
    
    // Once an email has been entered, this function sends a password recovery link.
    @objc private func sendPasswordRecoveryLink() {
        
        // 1. Safe cast root view to custom view.
        guard let view = view as? PasswordRecoveryView else { return }
        
        // 2. Empty input safe check. If fails, show error.
        if let email = view.emailTextField.text, email != "" {
            
            // 3. Send link button shows loading indicator.
            view.sendLinkButton.startLoading()
            
            // 4. Send link (firebase).
            authController.sendPasswordReset(email) { [weak self] (error, errorTitle, errorMessage) in
                
                guard let self = self else { return }
                
                // 5. Stop showing loading indicator.
                view.sendLinkButton.stopLoading()
                
                // 6. Error found. Display error.
                if error != nil {
                    
                    let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
                    let alertVC = AlertViewController(alertTitle: errorTitle, alertMessage: errorMessage, alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
                
                // 7. Link was sent successfully. Show query result.
                else {
                    
                    let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
                    let alertVC = AlertViewController(alertTitle: "Link sent!", alertMessage: "Check your email for a recovery link. If you do not receive one, check your spam folder.", alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
                
            }
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
            let alertVC = AlertViewController(alertTitle: AlertViewController.defaultAlertTitle, alertMessage: AlertViewController.defaultAlertMessage, alertButtons: [button1])
            
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    // Transitions back to the parent page.
    @objc private func dismissPasswordRecovery() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension PasswordRecoveryViewController: UITextFieldDelegate {
    
    /**
    Delegate function triggered by the return button on the keyboard. Sends the password recovery link.

    - Parameters:
        - textField: Input field that returned
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? PasswordRecoveryView else { return true }
        
        textField.resignFirstResponder()
        
        if textField == view.emailTextField {
            
            sendPasswordRecoveryLink()
            
        }
        
        return true
        
    }
    
}
