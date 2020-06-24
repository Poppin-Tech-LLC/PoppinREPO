//
//  ForgotPasswordViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/19/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

final class ForgotPasswordViewController: UIViewController {
    
    let loginInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    lazy private var loginContainerView: UIView = {
        
        let contentStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let contentStackView = UIStackView(arrangedSubviews: [resetPasswordTitleLabel, resetPasswordMessageLabel, emailTextField, sendLinkButton])
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
        
        loginContainerView.addSubview(switchToLogInTab)
        switchToLogInTab.bottomAnchor.constraint(equalTo: loginContainerView.bottomAnchor).isActive = true
        switchToLogInTab.leadingAnchor.constraint(equalTo: loginContainerView.leadingAnchor).isActive = true
        switchToLogInTab.trailingAnchor.constraint(equalTo: loginContainerView.trailingAnchor).isActive = true
        
        return loginContainerView
        
    }()
    
    lazy private var resetPasswordTitleLabel: UILabel = {
        
        var resetPasswordTitleLabel = UILabel()
        resetPasswordTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
        resetPasswordTitleLabel.sizeToFit()
        resetPasswordTitleLabel.numberOfLines = 0
        resetPasswordTitleLabel.textColor = .mainDARKPURPLE
        resetPasswordTitleLabel.text = "Forgot your password?"
        resetPasswordTitleLabel.textAlignment = .center
        return resetPasswordTitleLabel
        
    }()
    
    lazy private var resetPasswordMessageLabel: UILabel = {
        
        var resetPasswordMessageLabel = UILabel()
        resetPasswordMessageLabel.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        resetPasswordMessageLabel.sizeToFit()
        resetPasswordMessageLabel.numberOfLines = 0
        resetPasswordMessageLabel.textColor = .mainDARKPURPLE
        resetPasswordMessageLabel.text = "Enter your email and we will send you a link to reset your password."
        resetPasswordMessageLabel.textAlignment = .center
        return resetPasswordMessageLabel
        
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
        emailTextField.returnKeyType = .done
        emailTextField.enablesReturnKeyAutomatically = true
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: emailTextField.intrinsicContentSize.height+(loginInnerInset*0.4)).isActive = true
        
        return emailTextField
        
    }()
    
    lazy private var sendLinkButton: LoadingButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var sendLinkButton = LoadingButton(loadingIndicatorColor: .white)
        sendLinkButton.backgroundColor = .mainDARKPURPLE
        sendLinkButton.setTitle("Send Link", for: .normal)
        sendLinkButton.setTitleColor(.white, for: .normal)
        sendLinkButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .callout)
        sendLinkButton.titleLabel?.textAlignment = .center
        sendLinkButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        sendLinkButton.isUserInteractionEnabled = false
        sendLinkButton.addTarget(self, action: #selector(performRequest(sender:)), for: .touchUpInside)
        sendLinkButton.alpha = 0.6
        
        sendLinkButton.translatesAutoresizingMaskIntoConstraints = false
        sendLinkButton.heightAnchor.constraint(equalToConstant: sendLinkButton.intrinsicContentSize.height+innerEdgeInset).isActive = true
        
        return sendLinkButton
        
    }()
    
    lazy private var switchToLogInTab: UIView = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
        
        let switchToLogInButtonText = NSMutableAttributedString(string: "Back to Log In", attributes: [.foregroundColor : UIColor.mainDARKPURPLE])
        let lightRange = switchToLogInButtonText.mutableString.range(of: "Back to")
        let boldRange = switchToLogInButtonText.mutableString.range(of: "Log In")
        switchToLogInButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), range: lightRange)
        switchToLogInButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), range: boldRange)
        
        let switchToLogInButton = BouncyButton(bouncyButtonImage: nil)
        switchToLogInButton.backgroundColor = .clear
        switchToLogInButton.setAttributedTitle(switchToLogInButtonText, for: .normal)
        switchToLogInButton.titleLabel?.textAlignment = .center
        switchToLogInButton.addTarget(self, action: #selector(switchToLogin(sender:)), for: .touchUpInside)
        
        let switchToLogInTabTopBorder = UIView()
        switchToLogInTabTopBorder.backgroundColor = .mainDARKPURPLE
        
        var switchToLogInTab = UIView()
        switchToLogInTab.backgroundColor = .white
        switchToLogInTab.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        
        switchToLogInTab.translatesAutoresizingMaskIntoConstraints = false
        switchToLogInTab.heightAnchor.constraint(equalToConstant: switchToLogInButton.intrinsicContentSize.height+innerEdgeInset+4.0).isActive = true
        
        switchToLogInTab.addSubview(switchToLogInTabTopBorder)
        switchToLogInTabTopBorder.translatesAutoresizingMaskIntoConstraints = false
        switchToLogInTabTopBorder.topAnchor.constraint(equalTo: switchToLogInTab.topAnchor).isActive = true
        switchToLogInTabTopBorder.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        switchToLogInTabTopBorder.leadingAnchor.constraint(equalTo: switchToLogInTab.leadingAnchor).isActive = true
        switchToLogInTabTopBorder.trailingAnchor.constraint(equalTo: switchToLogInTab.trailingAnchor).isActive = true
        
        switchToLogInTab.addSubview(switchToLogInButton)
        switchToLogInButton.translatesAutoresizingMaskIntoConstraints = false
        switchToLogInButton.topAnchor.constraint(equalTo: switchToLogInTabTopBorder.bottomAnchor).isActive = true
        switchToLogInButton.bottomAnchor.constraint(equalTo: switchToLogInTab.bottomAnchor, constant: -3.0).isActive = true
        switchToLogInButton.leadingAnchor.constraint(equalTo: switchToLogInTab.leadingAnchor).isActive = true
        switchToLogInButton.trailingAnchor.constraint(equalTo: switchToLogInTab.trailingAnchor).isActive = true
        
        return switchToLogInTab
        
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
        
        if emailTextField.text != "" && !sendLinkButton.isUserInteractionEnabled {
            
            sendLinkButton.isUserInteractionEnabled = true
            sendLinkButton.alpha = 1.0
            
        } else if emailTextField.text == "" && sendLinkButton.isUserInteractionEnabled {
            
            sendLinkButton.isUserInteractionEnabled = false
            sendLinkButton.alpha = 0.6
            
        }
        
    }
    
    @objc private func performRequest(sender: BouncyButton) {
        
        if let email = emailTextField.text, email != "" {
            
            sendLinkButton.startLoading()
            view.isUserInteractionEnabled = false
            
            Auth.auth().sendPasswordReset(withEmail: email, completion: { [weak self] error in
                
                guard let self = self else { return }
                
                self.sendLinkButton.stopLoading()
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
                    
                    let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: { [weak self] in
                        
                        guard let self = self else { return }
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    })
                    
                    let alertVC = AlertViewController(alertTitle: "Email Sent!", alertMessage: "We sent an email to " + email + " with a link to reset your password.", alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
                
            })
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Something went wrong", alertMessage: "Please try again.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func switchToLogin(sender: BouncyButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func resetTextFields() {
        
        emailTextField.text = ""

        textFieldDidChange()
        
    }
    
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == emailTextField {
            
            performRequest(sender: sendLinkButton)
            
        }
        
        return true
        
    }
    
}

