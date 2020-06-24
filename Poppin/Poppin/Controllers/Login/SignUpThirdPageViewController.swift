//
//  SignUpThirdPageViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/24/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

final class SignUpThirdPageViewController: UIViewController {
    
    let loginInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    let innerElementsSpacing: CGFloat = .getPercentageWidth(percentage: 3)
    
    private var fullName: String = ""
    private var age: Int = 0
    private var email: String = ""
    private var password: String = ""
    
    private let termsLink = "Terms"
    private let privacyPolicyLink = "Privacy"
    
    lazy private var signUpContainerView: UIView = {
        
        let contentStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let contentStackView = UIStackView(arrangedSubviews: [usernameStackView, signUpButton, disclaimerTextView])
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = contentStackViewSpacing
        
        var signUpContainerView = UIView(frame: .zero)
        signUpContainerView.backgroundColor = .white
        signUpContainerView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
        signUpContainerView.addSubview(poppinTitleLabel)
        poppinTitleLabel.topAnchor.constraint(equalTo: signUpContainerView.topAnchor, constant: containerInsetY).isActive = true
        poppinTitleLabel.centerXAnchor.constraint(equalTo: signUpContainerView.centerXAnchor).isActive = true
        
        signUpContainerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.topAnchor.constraint(equalTo: signUpContainerView.topAnchor, constant: (containerInsetY*1.1)+poppinTitleLabel.intrinsicContentSize.height+contentStackViewSpacing).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: signUpContainerView.leadingAnchor, constant: containerInsetX).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: signUpContainerView.trailingAnchor, constant: -containerInsetX).isActive = true
        
        signUpContainerView.addSubview(poppinTitleLabel)
        poppinTitleLabel.topAnchor.constraint(equalTo: signUpContainerView.topAnchor, constant: containerInsetY).isActive = true
        poppinTitleLabel.centerXAnchor.constraint(equalTo: signUpContainerView.centerXAnchor).isActive = true
        
        signUpContainerView.addSubview(signUpBackButton)
        signUpBackButton.centerYAnchor.constraint(equalTo: poppinTitleLabel.centerYAnchor).isActive = true
        signUpBackButton.heightAnchor.constraint(equalTo: poppinTitleLabel.heightAnchor).isActive = true
        signUpBackButton.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor).isActive = true
        
        signUpContainerView.addSubview(switchToLoginTab)
        switchToLoginTab.bottomAnchor.constraint(equalTo: signUpContainerView.bottomAnchor).isActive = true
        switchToLoginTab.leadingAnchor.constraint(equalTo: signUpContainerView.leadingAnchor).isActive = true
        switchToLoginTab.trailingAnchor.constraint(equalTo: signUpContainerView.trailingAnchor).isActive = true
        
        return signUpContainerView
        
    }()
    
    lazy private var signUpBackButton: BouncyButton = {
        
        var signUpBackButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .arrowLeft).withTintColor(UIColor.mainDARKPURPLE))
        signUpBackButton.addTarget(self, action: #selector(transitionToPreviousPage(sender:)), for: .touchUpInside)
        
        signUpBackButton.translatesAutoresizingMaskIntoConstraints = false
        signUpBackButton.widthAnchor.constraint(equalTo: signUpBackButton.heightAnchor).isActive = true
        
        return signUpBackButton
        
    }()
    
    lazy private var usernameStackView: UIStackView = {
        
        var usernameStackView = UIStackView(arrangedSubviews: [usernameTextField, invalidUsernameLabel])
        usernameStackView.axis = .vertical
        usernameStackView.alignment = .fill
        usernameStackView.distribution = .fill
        usernameStackView.spacing = innerElementsSpacing
        return usernameStackView
        
    }()
    
    lazy private var usernameTextField: UITextField = {
        
        var usernameTextField = UITextField()
        usernameTextField.backgroundColor = .clear
        usernameTextField.textColor = .mainDARKPURPLE
        usernameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        usernameTextField.delegate = self
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: usernameTextField.intrinsicContentSize.height))
        usernameTextField.leftViewMode = .always
        usernameTextField.clearButtonMode = .whileEditing
        usernameTextField.returnKeyType = .next
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.heightAnchor.constraint(equalToConstant: usernameTextField.intrinsicContentSize.height+(loginInnerInset*0.4)).isActive = true
        
        return usernameTextField
        
    }()
    
    lazy private var invalidUsernameLabel: UILabel = {
        
        var invalidUsernameLabel = UILabel()
        invalidUsernameLabel.backgroundColor = .clear
        invalidUsernameLabel.sizeToFit()
        invalidUsernameLabel.numberOfLines = 0
        invalidUsernameLabel.textColor = .mainDARKPURPLE
        invalidUsernameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption2)
        invalidUsernameLabel.text = "3-15 characters (alphanumeric or underscore)."
        
        return invalidUsernameLabel
        
    }()
    
    lazy private var disclaimerTextView: UITextView = {
        
        let disclaimerText = NSMutableAttributedString(string: "By clicking Sign up, you agree to our Terms and Privacy Policy", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption2)])
        let termsRange = disclaimerText.mutableString.range(of: "Terms")
        let privacyPolicyRange = disclaimerText.mutableString.range(of: "Privacy Policy")
        
        disclaimerText.addAttribute(.link, value: termsLink, range: termsRange)
        disclaimerText.addAttribute(.link, value: privacyPolicyLink, range: privacyPolicyRange)
        
        var disclaimerTextView = UITextView()
        disclaimerTextView.textContainerInset = .zero
        disclaimerTextView.attributedText = disclaimerText
        disclaimerTextView.linkTextAttributes = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE]
        disclaimerTextView.textColor = .mainDARKPURPLE
        disclaimerTextView.backgroundColor = .clear
        disclaimerTextView.isEditable = false
        disclaimerTextView.isSelectable = true
        disclaimerTextView.isScrollEnabled = false
        disclaimerTextView.delegate = self
        disclaimerTextView.textAlignment = .center
        return disclaimerTextView
        
    }()
    
    lazy private var signUpButton: LoadingButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var signUpButton = LoadingButton(loadingIndicatorColor: .white)
        signUpButton.backgroundColor = .mainDARKPURPLE
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .callout)
        signUpButton.titleLabel?.textAlignment = .center
        signUpButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        signUpButton.isUserInteractionEnabled = false
        signUpButton.addTarget(self, action: #selector(performSignUp(sender:)), for: .touchUpInside)
        signUpButton.alpha = 0.6
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.heightAnchor.constraint(equalToConstant: signUpButton.intrinsicContentSize.height+innerEdgeInset).isActive = true
        
        return signUpButton
        
    }()
    
    lazy private var switchToLoginTab: UIView = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
        
        let switchToLoginButtonText = NSMutableAttributedString(string: "Already have an account? Log In", attributes: [.foregroundColor : UIColor.mainDARKPURPLE])
        let lightRange = switchToLoginButtonText.mutableString.range(of: "Already have an account?")
        let boldRange = switchToLoginButtonText.mutableString.range(of: "Log In")
        switchToLoginButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), range: lightRange)
        switchToLoginButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), range: boldRange)
        
        let switchToLoginButton = BouncyButton(bouncyButtonImage: nil)
        switchToLoginButton.backgroundColor = .clear
        switchToLoginButton.setAttributedTitle(switchToLoginButtonText, for: .normal)
        switchToLoginButton.titleLabel?.textAlignment = .center
        switchToLoginButton.addTarget(self, action: #selector(switchToLogin(sender:)), for: .touchUpInside)
        
        let switchToLoginTabTopBorder = UIView()
        switchToLoginTabTopBorder.backgroundColor = .mainDARKPURPLE
        
        var switchToLoginTab = UIView()
        switchToLoginTab.backgroundColor = .white
        switchToLoginTab.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        
        switchToLoginTab.translatesAutoresizingMaskIntoConstraints = false
        switchToLoginTab.heightAnchor.constraint(equalToConstant: switchToLoginButton.intrinsicContentSize.height+innerEdgeInset+4.0).isActive = true
        
        switchToLoginTab.addSubview(switchToLoginTabTopBorder)
        switchToLoginTabTopBorder.translatesAutoresizingMaskIntoConstraints = false
        switchToLoginTabTopBorder.topAnchor.constraint(equalTo: switchToLoginTab.topAnchor).isActive = true
        switchToLoginTabTopBorder.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        switchToLoginTabTopBorder.leadingAnchor.constraint(equalTo: switchToLoginTab.leadingAnchor).isActive = true
        switchToLoginTabTopBorder.trailingAnchor.constraint(equalTo: switchToLoginTab.trailingAnchor).isActive = true
        
        switchToLoginTab.addSubview(switchToLoginButton)
        switchToLoginButton.translatesAutoresizingMaskIntoConstraints = false
        switchToLoginButton.topAnchor.constraint(equalTo: switchToLoginTabTopBorder.bottomAnchor).isActive = true
        switchToLoginButton.bottomAnchor.constraint(equalTo: switchToLoginTab.bottomAnchor, constant: -3.0).isActive = true
        switchToLoginButton.leadingAnchor.constraint(equalTo: switchToLoginTab.leadingAnchor).isActive = true
        switchToLoginButton.trailingAnchor.constraint(equalTo: switchToLoginTab.trailingAnchor).isActive = true
        
        return switchToLoginTab
        
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
    
    init(fullName: String, age: Int, email: String, password: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.fullName = fullName
        self.age = age
        self.email = email
        self.password = password
        
    }
    
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
        
        view.addSubview(signUpContainerView)
        signUpContainerView.translatesAutoresizingMaskIntoConstraints = false
        signUpContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: loginInsetY).isActive = true
        signUpContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginInsetX).isActive = true
        signUpContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginInsetX).isActive = true
        signUpContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -loginInsetY).isActive = true
        
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    @objc private func textFieldDidChange() {
        
        if usernameTextField.text != "" && !signUpButton.isUserInteractionEnabled {
            
            signUpButton.isUserInteractionEnabled = true
            signUpButton.alpha = 1.0
            
        } else if usernameTextField.text == "" && signUpButton.isUserInteractionEnabled {
            
            signUpButton.isUserInteractionEnabled = false
            signUpButton.alpha = 0.6
            
        }
        
    }
    
    @objc private func transitionToPreviousPage(sender: BouncyButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func performSignUp(sender: BouncyButton) {
        
        let usernameFormat = "\\w{3,15}"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameFormat)
        
        var validSteps: Int = 0
        
        if usernamePredicate.evaluate(with: usernameTextField.text) && usernameTextField.text?.range(of: "poppin", options: .caseInsensitive) == nil && usernameTextField.text?.range(of: "admin", options: .caseInsensitive) == nil {
            
            validSteps+=1
            
        } else {
            
            usernameTextField.setBottomBorder(color: .socialDARKRED, height: 1.0)
            invalidUsernameLabel.textColor = .socialDARKRED
            
        }
        
        if fullName != "" && age >= 13 && email != "" && password != "" {
            
            validSteps+=1
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: { [weak self] in
            
                guard let self = self else { return }
                
                self.navigationController?.popViewController(animated: true)
            
            })
            
            let alertVC = AlertViewController(alertTitle: "Unable to proceed with the sign up", alertMessage: "It was not possible to proceed with the sign up. Thanks for checking out Poppin.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
        if validSteps == 2 {
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
            /*signUpButton.startLoading()
            view.isUserInteractionEnabled = false
            
            // Check if username is in db
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
                
                guard let self = self else { return }
                
                if error != nil {
                    
                    self.signUpButton.stopLoading()
                    self.view.isUserInteractionEnabled = true
                    
                    let errorCode = AuthErrorCode(rawValue: error!._code)
                    let errorTitle: String
                    let errorMessage: String
                    
                    switch errorCode {
                        
                    case .emailAlreadyInUse:
                        
                        errorTitle = "Email is already in used"
                        errorMessage = "The email you entered is already associated with an account. Please try again."
                        
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
                    let alertVC = NewAlertViewController(alertTitle: errorTitle, alertMessage: errorMessage, alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    
                    self.navigationController?.dismiss(animated: true, completion: nil)
                    
                }
                
            }*/
            
        }
        
    }
    
    @objc private func switchToLogin(sender: BouncyButton) {
        
        if let firstAfterRootVC = navigationController?.viewControllers[1] as? LoginViewController {
            
            firstAfterRootVC.resetTextFields()
            navigationController?.popToViewController(firstAfterRootVC, animated: true)
            
        } else {
            
            navigationController?.pushViewController(LoginViewController(), animated: true)
            
        }
        
    }
    
    func resetTextFields() {
        
        usernameTextField.text = ""
        
        textFieldDidChange()
        
        usernameTextField.setBottomBorder(color: .mainDARKPURPLE, height: 1.0)
        invalidUsernameLabel.textColor = .mainDARKPURPLE
        
    }
    
}

extension SignUpThirdPageViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == usernameTextField {
            
            performSignUp(sender: signUpButton)
            
        }
        
        return true
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == usernameTextField && invalidUsernameLabel.textColor.isEqual(UIColor.socialDARKRED) {
            
            usernameTextField.setBottomBorder(color: .mainDARKPURPLE, height: 1.0)
            invalidUsernameLabel.textColor = .mainDARKPURPLE
            
        }
        
        return true
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == "Terms" {
            
            // Future Action
            
            print("Showing Terms")
            
        } else if URL.absoluteString == "Privacy" {
            
            // Future Action
            
            print("Showing Privacy Policy")
            
        }
        
        return false
        
    }
    
}
