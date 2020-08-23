//
//  SignUpThirdSectionViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/24/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Third Section of Sign Up (Username, Email, and Password) UI Controller.
final class SignUpThirdSectionViewController: UIViewController {
    
    // University passed on previous page.
    private(set) var university: University?
    
    // Name picked on previous page.
    private(set) var fullName: String?
    
    // Date of birth picked on previous page.
    private(set) var dateOfBirth: Date?
    
    // Firebase Auth wrapper.
    lazy private var authController = AuthController()
    
    /**
    Custom class init that initializes the university, full name and date of birth objects.

    - Parameters:
        - university: University object (picked on the first page of sign up) - Default value: nil.
        - fullName: Full name of the user (entered on the second page of sign up) - Default value: nil.
        - dateOfBirth: Date of birth of the user (entered on the second page of sign up) - Default value: nil.
    */
    init(university: University? = nil, fullName: String? = nil, dateOfBirth: Date? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.university = university
        self.fullName = fullName
        self.dateOfBirth = dateOfBirth
        
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
        
        self.view = SignUpThirdPageView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return }
        
        // 2. Setting targets and delegation.
        _ = [view.usernameTextField, view.emailTextField, view.passwordTextField, view.confirmPasswordTextField].map { $0.delegate = self }
        
        view.signUpButton.addTarget(self, action: #selector(performSignUp), for: .touchUpInside)
        view.backButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to reset input fields, enable swipe back, add observers for when the keyboard shows or hides, and adjust some UI elements.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return }
        
        // 2. Resets previously entered credentials if any.
        view.resetInputFields()
        
        // 3. Enables swipe to transition back.
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // 4. Add observers for when the keyboard shows up or hides.
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 5. Adds the university email domain to the label below the email input field. If there is no domain, the label is hidden.
        if let domain = university?.domain {
            
            view.invalidEmailLabel.text = "@" + domain
            
        } else {
            
            view.invalidEmailLabel.isHidden = true
            
        }
        
        // 6. Hide label below the confirm password input field.
        view.topStack.stackView.setCustomSpacing(view.topStack.stackView.spacing, after: view.confirmPasswordTextField)
        view.invalidConfirmPasswordLabel.isHidden = true
        
    }
    
    /// Overrides superclass method to disable swipe back.
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // 1. Disables swipe to transition back.
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    // Adjusts scollable content so that the input fields are not hidden by the keyboard. This function is called both when the keyboard appears and when it hides.
    @objc private func adjustForKeyboard(notification: Notification) {
        
        // 1. Safe casting keyboard information (used to get the height).
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // 2. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return }

        // 3. Getting keyboard height.
        let keyboardHeight = view.convert(keyboardValue.cgRectValue, from: view.window).height

        // 4. Adjust scrollable content according to whether the keyboard is showing or hiding and whether it is overlapping with any input fields.
        if notification.name == UIResponder.keyboardWillHideNotification {
            
            var contentInset = view.topStack.contentInset
            contentInset.bottom = view.topStack.padding.bottom
            view.topStack.contentInset = contentInset
            
        } else {
            
            var contentInset = view.topStack.contentInset
            contentInset.bottom = keyboardHeight + view.topStack.padding.bottom
            view.topStack.contentInset = contentInset
            
        }
        
        view.topStack.scrollIndicatorInsets = view.topStack.contentInset

    }
    
    // Once all neccessary sign up information has been entered and passed all safe checks, this function performs the sign up.
    @objc private func performSignUp() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return }
     
        // 2. Safe check input from other pages. If fails, show error and return to start page.
        if let university = university, let fullName = fullName, let dateOfBirth = dateOfBirth {
            
            // 3. Sign up button shows loading indicator.
            view.signUpButton.startLoading()
            
            let usernameCheck = isUsernameValid(username: view.usernameTextField.text)
            let emailCheck = isEmailValid(email: view.emailTextField.text, domain: university.domain)
            let passwordCheck = isPasswordValid(password: view.passwordTextField.text)
            let confirmPasswordCheck = doPasswordsMatch(password: view.passwordTextField.text, confirmPassword: view.confirmPasswordTextField.text)
            
            // 4. Safe input checks. If fails, mark the incorrect input fields and stop loading.
            if usernameCheck, emailCheck, passwordCheck, confirmPasswordCheck {
                
                // 5. Username availability check (firebase).
                authController.isUsernameAvailable(view.usernameTextField.text!) { [weak self] (isAvailable, error) in
                    
                    guard let self = self else { return }
                    
                    // 6. Error found. Stop loading and show error.
                    if error != nil {
                        
                        view.signUpButton.stopLoading()
                        
                        let alertVC = AlertViewController()
                        
                        self.present(alertVC, animated: true, completion: nil)
                        
                    }
                    
                    // 7. Username is available.
                    else if let isAvailable = isAvailable, isAvailable {
                        
                        // 8. Create user (firebase).
                        self.authController.createUser(view.emailTextField.text!, view.passwordTextField.text!) { [weak self] (result, error, errorTitle, errorMessage) in
                            
                            guard let self = self else { return }
                            
                            // 9. Error found. Stop loading and show error.
                            if error != nil {
                                
                                view.signUpButton.stopLoading()
                                
                                let alertVC = AlertViewController(alertTitle: errorTitle, alertMessage: errorMessage)
                                
                                self.present(alertVC, animated: true, completion: nil)
                                
                            } else {
                                
                                // 10. Add new user to database (firebase).
                                self.authController.addUser(result!.user, view.usernameTextField.text!, fullName: fullName, dateOfBirth: dateOfBirth, university: university) { [weak self] (error) in
                                    
                                    guard let self = self else { return }
                                    
                                    // 11. Error found. Stop loading and show error.
                                    if error != nil {
                                        
                                        view.signUpButton.stopLoading()
                                        
                                        let alertVC = AlertViewController()
                                        
                                        self.present(alertVC, animated: true, completion: nil)
                                        
                                    } else {
                                        
                                        // 12. Send email verification link.
                                        self.authController.sendEmailVerification { [weak self] (error) in
                                            
                                            guard let self = self else { return }
                                            
                                            view.signUpButton.stopLoading()
                                            
                                            let alertVC = AlertViewController(alertTitle: "Welcome to Poppin!", alertMessage: "Check your email for a verification link. If you do not receive one, check your spam folder.", leftActionTitle: "Log in", leftAction: { [weak self] in
                                                
                                                guard let self = self else { return }
                                                
                                                // 13. Core Data.
                                                
                                                //                                                DataController.eraseAll(forEntity: "OtherAccounts")
                                                //                                                DataController.eraseAll(forEntity: "User")
                                                //                                                DataController.addUser(bio: "", username: view.usernameTextField.text, fullName: fullName, uid: result!.user.uid, radius: university.radius, latitude: university.latitude, longitude: university.longitude, notificationName: .userSignedIn)
                                                
                                                // 14. Transition to the login page.
                                                self.navigationController?.pushViewController(LoginViewController(), animated: true)
                                                
                                            })
                                            
                                            self.present(alertVC, animated: true, completion: nil)
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                    // 15. Username is taken. Stop loading and show error.
                    else {
                        
                        view.signUpButton.stopLoading()
                        
                        let alertVC = AlertViewController(alertTitle: "Username taken", alertMessage: view.usernameTextField.text! + " is not available, please try a different one.", leftAction: {
                        
                            view.usernameTextField.textColor = .red
                            view.usernameTextField.setBottomBorder(color: .red, height: 1.0)
                            view.invalidUsernameLabel.textColor = .red
                        
                        })
                        
                        self.present(alertVC, animated: true, completion: nil)
                        
                    }
                    
                }
                
            } else {
                
                view.signUpButton.stopLoading()
                
            }
            
        } else {
            
            let alertVC = AlertViewController(alertTitle: "Unable to proceed with the sign up", alertMessage: "It was not possible to proceed with the sign up. Thanks for checking out Poppin.", leftAction: { [weak self] in
            
                guard let self = self else { return }
                
                self.navigationController?.popToRootViewController(animated: true)
            
            })
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    // Checks if username has the correct length and does not contain app related words or unsupported characters. If fails, the input field is marked as invalid.
    private func isUsernameValid(username: String?) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return false }
        
        let usernameFormat = "\\w{3,15}"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameFormat)
        
        if let username = username, usernamePredicate.evaluate(with: username), username.range(of: "poppin", options: .caseInsensitive) == nil, username.range(of: "admin", options: .caseInsensitive) == nil {
            
            return true
            
        } else {
            
            // 2. Marked as invalid.
            view.usernameTextField.textColor = .red
            view.usernameTextField.setBottomBorder(color: .red, height: 1.0)
            view.invalidUsernameLabel.textColor = .red
            
            return false
            
        }
        
    }
    
    // Checks if email has the correct format and that is a valid school email according to their university domain. If fails, the input field is marked as invalid.
    private func isEmailValid(email: String?, domain: String?) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return false }
        
        if let email = email, let domain = domain, email.lowercased().hasSuffix("@" + domain) {
            
            return true
            
        } else {
            
            // 2. Marked as invalid.
            view.emailTextField.textColor = .red
            view.emailTextField.setBottomBorder(color: .red, height: 1.0)
            view.invalidEmailLabel.textColor = .red
            
            return false
            
        }
        
    }
    
    // Checks if password has the correct length and contains at least one number and one upper case letter. If fails, the input field is marked as invalid.
    private func isPasswordValid(password: String?) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return false }
        
        let passwordFormat = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        
        if let password = password, passwordPredicate.evaluate(with: password) {
            
            return true
            
        } else {
            
            // 2. Marked as invalid
            view.passwordTextField.textColor = .red
            view.passwordTextField.setBottomBorder(color: .red, height: 1.0)
            view.invalidPasswordLabel.textColor = .red
            
            return false
            
        }
        
    }
    
    // Checks if the password and confirm password inputs match. If fails, the input field is marked as invalid.
    private func doPasswordsMatch(password: String?, confirmPassword: String?) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return false }
        
        if let password = password, let confirmPassword = confirmPassword, password == confirmPassword {
            
            return true
            
        } else {
            
            // 2. Marked as invalid.
            view.confirmPasswordTextField.textColor = .red
            view.confirmPasswordTextField.setBottomBorder(color: .red, height: 1.0)
            view.invalidConfirmPasswordLabel.textColor = .red
            view.topStack.stackView.setCustomSpacing(view.topStack.stackView.customSpacing(after: view.usernameTextField), after: view.confirmPasswordTextField)
            view.invalidConfirmPasswordLabel.isHidden = false
            
            return false
            
        }
        
    }
    
    // Transitions to the previous page of the sign up.
    @objc private func transitionToPreviousPage() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension SignUpThirdSectionViewController: UITextFieldDelegate {
    
    /**
    Delegate function triggered when an input field begins editing. If the input field has been marked as invalid, it is unmarked and turned back to normal.

    - Parameters:
        - textField: Input field that returned
    */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return true }
        
        // 2. Check if input field is invalid.
        if textField.textColor == .red {
            
            if textField == view.usernameTextField {
                
                view.usernameTextField.textColor = .mainDARKPURPLE
                view.usernameTextField.setBottomBorder(color: .mainDARKPURPLE, height: 1.0)
                view.invalidUsernameLabel.textColor = .mainDARKPURPLE
                
            } else if textField == view.emailTextField {
                
                view.emailTextField.textColor = .mainDARKPURPLE
                view.emailTextField.setBottomBorder(color: .mainDARKPURPLE, height: 1.0)
                view.invalidEmailLabel.textColor = .mainDARKPURPLE
                
            } else if textField == view.passwordTextField {
                
                view.passwordTextField.textColor = .mainDARKPURPLE
                view.passwordTextField.setBottomBorder(color: .mainDARKPURPLE, height: 1.0)
                view.invalidPasswordLabel.textColor = .mainDARKPURPLE
                
            } else if textField == view.confirmPasswordTextField {
                
                view.confirmPasswordTextField.textColor = .mainDARKPURPLE
                view.confirmPasswordTextField.setBottomBorder(color: .mainDARKPURPLE, height: 1.0)
                view.invalidConfirmPasswordLabel.textColor = .mainDARKPURPLE
                view.topStack.stackView.setCustomSpacing(view.topStack.stackView.spacing, after: view.confirmPasswordTextField)
                view.invalidConfirmPasswordLabel.isHidden = true
                
            }
            
        }
        
        return true
        
    }
    
    /**
    Delegate function triggered by the return button on the keyboard. Hops to the next input field and finally performs the sign up.

    - Parameters:
        - textField: Input field that returned
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpThirdPageView else { return true }
        
        textField.resignFirstResponder()
        
        if textField == view.usernameTextField {
            
            view.emailTextField.becomeFirstResponder()
            
        } else if textField == view.emailTextField {
            
            view.passwordTextField.becomeFirstResponder()
            
        } else if textField == view.passwordTextField {
            
            view.confirmPasswordTextField.becomeFirstResponder()
            
        } else if textField == view.confirmPasswordTextField {
            
            performSignUp()
            
        }
        
        return true
        
    }
    
}

extension SignUpThirdSectionViewController: UIGestureRecognizerDelegate {
    
    /// REQUIRED: Fails other gesture recognizers when swiping to transition back.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
