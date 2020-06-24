//
//  LoginViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/16/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    let loginInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    lazy private var loginContainerView: UIView = {
        
        let contentStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let contentStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = contentStackViewSpacing
        
        var loginContainerView = UIView(frame: .zero)
        loginContainerView.backgroundColor = .white
        loginContainerView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
        loginContainerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.topAnchor.constraint(equalTo: loginContainerView.topAnchor, constant: (containerInsetY*1.1)+poppinTitleLabel.intrinsicContentSize.height+contentStackViewSpacing).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: loginContainerView.leadingAnchor, constant: containerInsetX).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: loginContainerView.trailingAnchor, constant: -containerInsetX).isActive = true
        
        loginContainerView.addSubview(switchToSignUpTab)
        switchToSignUpTab.bottomAnchor.constraint(equalTo: loginContainerView.bottomAnchor).isActive = true
        switchToSignUpTab.leadingAnchor.constraint(equalTo: loginContainerView.leadingAnchor).isActive = true
        switchToSignUpTab.trailingAnchor.constraint(equalTo: loginContainerView.trailingAnchor).isActive = true
        
        return loginContainerView
        
    }()
    
    lazy private var emailTextField: UITextField = {
        
        var emailTextField = UITextField()
        emailTextField.backgroundColor = .clear
        emailTextField.textColor = .mainDARKPURPLE
        emailTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        emailTextField.delegate = self
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: emailTextField.intrinsicContentSize.height))
        emailTextField.leftViewMode = .always
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.returnKeyType = .next
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: emailTextField.intrinsicContentSize.height+(loginInnerInset*0.4)).isActive = true
        
        return emailTextField
        
    }()
    
    lazy private var passwordTextField: UITextField = {
        
        var passwordTextField = UITextField()
        passwordTextField.backgroundColor = .clear
        passwordTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        passwordTextField.textColor = .mainDARKPURPLE
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: passwordTextField.intrinsicContentSize.height))
        passwordTextField.leftViewMode = .always
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.returnKeyType = .done
        passwordTextField.enablesReturnKeyAutomatically = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: passwordTextField.intrinsicContentSize.height+(loginInnerInset*0.4)).isActive = true
        
        return passwordTextField
        
    }()
    
    lazy private var loginButton: LoadingButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var loginButton = LoadingButton(loadingIndicatorColor: .white)
        loginButton.backgroundColor = .mainDARKPURPLE
        loginButton.setTitle("Log In", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .callout)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        loginButton.isUserInteractionEnabled = false
        loginButton.addTarget(self, action: #selector(performLogin(sender:)), for: .touchUpInside)
        loginButton.alpha = 0.6
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: loginButton.intrinsicContentSize.height+innerEdgeInset).isActive = true
        
        return loginButton
        
    }()
    
    lazy private var switchToSignUpTab: UIView = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
        
        let switchToSignUpButtonText = NSMutableAttributedString(string: "Don't have an account yet? Sign Up", attributes: [.foregroundColor : UIColor.mainDARKPURPLE])
        let lightRange = switchToSignUpButtonText.mutableString.range(of: "Don't have an account yet?")
        let boldRange = switchToSignUpButtonText.mutableString.range(of: "Sign Up")
        switchToSignUpButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), range: lightRange)
        switchToSignUpButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), range: boldRange)
        
        let switchToSignUpButton = BouncyButton(bouncyButtonImage: nil)
        switchToSignUpButton.backgroundColor = .clear
        switchToSignUpButton.setAttributedTitle(switchToSignUpButtonText, for: .normal)
        switchToSignUpButton.titleLabel?.textAlignment = .center
        switchToSignUpButton.addTarget(self, action: #selector(switchToSignUp(sender:)), for: .touchUpInside)
        
        let switchToSignUpTabTopBorder = UIView()
        switchToSignUpTabTopBorder.backgroundColor = .mainDARKPURPLE
        
        var switchToSignUpTab = UIView()
        switchToSignUpTab.backgroundColor = .white
        switchToSignUpTab.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        
        switchToSignUpTab.translatesAutoresizingMaskIntoConstraints = false
        switchToSignUpTab.heightAnchor.constraint(equalToConstant: switchToSignUpButton.intrinsicContentSize.height+innerEdgeInset+4.0).isActive = true
        
        switchToSignUpTab.addSubview(switchToSignUpTabTopBorder)
        switchToSignUpTabTopBorder.translatesAutoresizingMaskIntoConstraints = false
        switchToSignUpTabTopBorder.topAnchor.constraint(equalTo: switchToSignUpTab.topAnchor).isActive = true
        switchToSignUpTabTopBorder.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        switchToSignUpTabTopBorder.leadingAnchor.constraint(equalTo: switchToSignUpTab.leadingAnchor).isActive = true
        switchToSignUpTabTopBorder.trailingAnchor.constraint(equalTo: switchToSignUpTab.trailingAnchor).isActive = true
        
        switchToSignUpTab.addSubview(switchToSignUpButton)
        switchToSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        switchToSignUpButton.topAnchor.constraint(equalTo: switchToSignUpTabTopBorder.bottomAnchor).isActive = true
        switchToSignUpButton.bottomAnchor.constraint(equalTo: switchToSignUpTab.bottomAnchor, constant: -3.0).isActive = true
        switchToSignUpButton.leadingAnchor.constraint(equalTo: switchToSignUpTab.leadingAnchor).isActive = true
        switchToSignUpButton.trailingAnchor.constraint(equalTo: switchToSignUpTab.trailingAnchor).isActive = true
        
        return switchToSignUpTab
        
    }()
    
    lazy private var forgotPasswordButton: BouncyButton = {
        
        var forgotPasswordButton = BouncyButton(bouncyButtonImage: nil)
        forgotPasswordButton.backgroundColor = .white
        forgotPasswordButton.contentEdgeInsets = UIEdgeInsets(top: 0.01, left: 0.0, bottom: 0.01, right: 0.0)
        forgotPasswordButton.setAttributedTitle(NSAttributedString(string: "Forgot your password?", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE]), for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(switchToPasswordReset(sender:)), for: .touchUpInside)
        forgotPasswordButton.titleLabel?.textAlignment = .center
        
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: forgotPasswordButton.intrinsicContentSize.height).isActive = true
        
        return forgotPasswordButton
        
    }()
    
    lazy private var backgroundImageView: UIImageView = {
        
        var backgroundImageView = UIImageView(image: UIImage.appBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
        
    }()
    
    lazy private var poppinTitleLabel: UILabel = {
        
        var poppinTitleLabel = UILabel()
        poppinTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        poppinTitleLabel.textColor = .mainDARKPURPLE
        poppinTitleLabel.text = "poppin"
        poppinTitleLabel.textAlignment = .center
        
        poppinTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        poppinTitleLabel.heightAnchor.constraint(equalToConstant: poppinTitleLabel.intrinsicContentSize.height).isActive = true
        
        return poppinTitleLabel
        
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .poppinLIGHTGOLD
        
        let dismissKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardGesture)
        
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(loginContainerView)
        loginContainerView.translatesAutoresizingMaskIntoConstraints = false
        loginContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: loginInsetY).isActive = true
        loginContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginInsetX).isActive = true
        loginContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginInsetX).isActive = true
        loginContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -loginInsetY).isActive = true
        
        view.addSubview(poppinTitleLabel)
        poppinTitleLabel.topAnchor.constraint(equalTo: loginContainerView.topAnchor, constant: containerInsetY).isActive = true
        poppinTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    @objc private func textFieldDidChange() {
        
        if emailTextField.text != "" && passwordTextField.text != "" && !loginButton.isUserInteractionEnabled {
            
            loginButton.isUserInteractionEnabled = true
            loginButton.alpha = 1.0
            
        } else if emailTextField.text == "" || passwordTextField.text == "" && loginButton.isUserInteractionEnabled {
            
            loginButton.isUserInteractionEnabled = false
            loginButton.alpha = 0.6
            
        }
        
    }
    
    @objc private func performLogin(sender: BouncyButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" {
            
            loginButton.startLoading()
            view.isUserInteractionEnabled = false
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
                
                guard let self = self else { return }
                
                self.loginButton.stopLoading()
                self.view.isUserInteractionEnabled = true
                
                if error != nil {
                    
                    let errorCode = AuthErrorCode(rawValue: error!._code)
                    let errorTitle: String
                    let errorMessage: String
                    
                    switch errorCode {
                        
                    case .userNotFound:
                        
                        errorTitle = "Email not found"
                        errorMessage = "The email you entered does not belong to any registered account. Please try again."
                        
                    case .invalidEmail:
                        
                        errorTitle = "Invalid email"
                        errorMessage = "The email you entered is invalid. Please try again."
                        
                    case .wrongPassword:
                        
                        errorTitle = "Incorrect password for " + email
                        errorMessage = "The password you entered is incorrect. Please try again."
                        
                    case .networkError:
                        
                        errorTitle = "Network is unstable"
                        errorMessage = "Please check your internet connection and try again."
                        
                    default:
                        
                        errorTitle = "Something went wrong"
                        errorMessage = "Please try again."
                        
                    }
                    
                    let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
                    let alertVC = AlertViewController(alertTitle: errorTitle, alertMessage: errorMessage, alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    
                }
                
            })
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
            let alertVC = AlertViewController(alertTitle: "Something went wrong", alertMessage: "Please try again.", alertButtons: [button1])
            
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func switchToSignUp(sender: BouncyButton) {
        
        if let firstAfterRootVC = navigationController?.viewControllers[1] as? SignUpFirstPageViewController {
            
            firstAfterRootVC.resetTextFields()
            navigationController?.popToViewController(firstAfterRootVC, animated: true)
            
        } else {
            
            navigationController?.pushViewController(SignUpFirstPageViewController(), animated: true)
            
        }
        
    }
    
    @objc private func switchToPasswordReset(sender: BouncyButton) {
        
        present(ForgotPasswordViewController(), animated: true, completion: nil)
        
    }
    
    func resetTextFields() {
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
        textFieldDidChange()
        
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == emailTextField {
            
            passwordTextField.becomeFirstResponder()
            
        } else if textField == passwordTextField {
            
            performLogin(sender: loginButton)
            
        }
        
        return true
        
    }
    
}


