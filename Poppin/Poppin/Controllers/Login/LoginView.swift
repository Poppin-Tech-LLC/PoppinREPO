//
//  LoginView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/18/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// Login Page UI.
final class LoginView: UIView {
    
    // Hides keyboard on tap.
    lazy private var dismissKeyboardGesture: UITapGestureRecognizer = {
       
        let dismissKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        return dismissKeyboardGesture
        
    }()
    
    // Poppin gold background.
    lazy private var backgroundView = UIImageView(image: UIImage.appBackground.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 100), height: .height(percent: 100))))
    
    // Card container.
    lazy private var cardView: UIView = {
       
        let cardView = CardView(bgColor: .white, padding: UIEdgeInsets(top: .width(percent: 6.0), left: .width(percent: 9.0), bottom: 0.0, right: .width(percent: 9.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [topStack, bottomStack].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        topStack.anchor(top: cardView.layoutMarginsGuide.topAnchor, leading: cardView.layoutMarginsGuide.leadingAnchor, trailing: cardView.layoutMarginsGuide.trailingAnchor)
        
        bottomStack.anchor(leading: cardView.leadingAnchor, bottom: cardView.layoutMarginsGuide.bottomAnchor, trailing: cardView.trailingAnchor)
        
        return cardView
        
    }()
    
    // Top content stack.
    lazy private var topStack: StackView = {
        
        let topStack = StackView(subviews: [poppinTitle, emailTextField, passwordTextField, loginButton, forgotPasswordButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 7.0), padding: .zero)
        topStack.setCustomSpacing(.width(percent: 8.0), after: poppinTitle)
        topStack.setCustomSpacing(.width(percent: 4.5), after: loginButton)
        return topStack
        
    }()
    
    // App title.
    lazy private var poppinTitle = OctarineLabel(text: "poppin", color: .mainDARKPURPLE, bold: true, size: .width(percent: 7.0), alignment: .center, lineLimit: 1)
    
    /// Email input field.
    lazy private(set) var emailTextField: UITextField = {
        
        let emailTextField = UITextField()
        emailTextField.backgroundColor = .clear
        emailTextField.textColor = .mainDARKPURPLE
        emailTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: emailTextField.intrinsicContentSize.height))
        emailTextField.leftViewMode = .always
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.returnKeyType = .next
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        emailTextField.addTarget(self, action: #selector(inputFieldsDidChange), for: .editingChanged)
        return emailTextField
        
    }()
    
    /// Password input field.
    lazy private(set) var passwordTextField: UITextField = {
        
        let passwordTextField = UITextField()
        passwordTextField.backgroundColor = .clear
        passwordTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        passwordTextField.textColor = .mainDARKPURPLE
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: passwordTextField.intrinsicContentSize.height))
        passwordTextField.leftViewMode = .always
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.returnKeyType = .done
        passwordTextField.enablesReturnKeyAutomatically = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        passwordTextField.addTarget(self, action: #selector(inputFieldsDidChange), for: .editingChanged)
        return passwordTextField
        
    }()
    
    /// Button that logins the user.
    lazy private(set) var loginButton = LoadingButton(bgColor: .mainDARKPURPLE, label: OctarineLabel(text: "Log In", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 2.5), left: 0.0, bottom: .width(percent: 2.5), right: 0.0), cornerRadius: .width(percent: 3.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
    
    /// Button that transitions to the password recovery page.
    lazy private(set) var forgotPasswordButton = OctarineButton(bgColor: .clear, label: OctarineLabel(text: "Forgot your password?", color: .mainDARKPURPLE, bold: true, style: .footnote, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 1.5), left: 0.0, bottom: .width(percent: 1.5), right: 0.0), cornerRadius: 0.0)
    
    // Bottom content stack.
    lazy private var bottomStack: StackView = StackView(subviews: [borderView, signUpButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: 0.0, padding: .zero)
    
    // Sign up button border.
    lazy private var borderView: UIView = {
        
        let borderView = UIView()
        borderView.backgroundColor = .mainDARKPURPLE
        borderView.anchor(size: CGSize(width: 0.0, height: 1.0))
        return borderView
        
    }()
    
    /// Button that transitions to the sign up page.
    lazy private(set) var signUpButton: OctarineButton = {
        
        let signUpButtonText = NSMutableAttributedString(string: "Don't have an account yet? Sign Up", attributes: [.foregroundColor : UIColor.mainDARKPURPLE])
        let lightRange = signUpButtonText.mutableString.range(of: "Don't have an account yet?")
        let boldRange = signUpButtonText.mutableString.range(of: "Sign Up")
        signUpButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), range: boldRange)
        signUpButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), range: lightRange)
        
        let signUpButton = OctarineButton(bgColor: .clear, label: OctarineLabel(alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 3.5), left: 0.0, bottom: .width(percent: 3.5), right: 0.0))
        signUpButton.titleEdgeInsets.top = -.width(percent: 1.0)
        signUpButton.setAttributedTitle(signUpButtonText, for: .normal)
        return signUpButton
        
    }()
    
    /**
    Overrides superclass initializer to configure the UI.

    - Parameter frame: Ignored by AutoLayout (default it to .zero)
    */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configureView()
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder from storyboard.
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configures UI.
    private func configureView() {
        
        // 1. Add a tap dismissal gesture for the keyboard.
        addGestureRecognizer(dismissKeyboardGesture)
        
        // 2. Add subviews to the root view (each one on top of the others).
        _ = [backgroundView, cardView].map { self.addSubview($0) }
        
        // 3. Apply constraints.
        backgroundView.attatchEdgesToSuperview()
        
        cardView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 3.0), right: .width(percent: 4.0)))
        
    }
    
    // Hides the keyboard.
    @objc private func dismissKeyboard() { endEditing(true) }
    
    /// Called when changes occur to any of the input fields. Enables or disables the login button according to the input fields content.
    @objc private func inputFieldsDidChange() {
        
        // 1. Once input fields have been filled, enable the login button.
        if !emailTextField.isEmpty() && !passwordTextField.isEmpty() && loginButton.isDisabled {
            
            loginButton.isDisabled = false
            
        } else if emailTextField.isEmpty() || passwordTextField.isEmpty() && !loginButton.isDisabled {
            
            loginButton.isDisabled = true
            
        }
        
    }
    
    /// Resets any input entered.
    func resetInputFields() {
        
        // 1. Resetting input fields.
        emailTextField.text = ""
        passwordTextField.text = ""
        
        // 2. Notifying changes.
        inputFieldsDidChange()
        
    }
    
}

struct LoginViewPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = LoginView
    
}

struct LoginViewPreview_Test: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = LoginViewPreview
    
}

class CardView: UIView {
    
    init(bgColor: UIColor = .white, padding: UIEdgeInsets = .zero, cornerRadius: CGFloat = 0.0, shadow: Shadow = Shadow(color: .clear, radius: 0.0, x: 0.0, y: 0.0)) {
        
        super.init(frame: .zero)
        
        self.layoutMargins = padding
        self.backgroundColor = bgColor
        self.layer.cornerRadius = cornerRadius
        self.apply(shadow: shadow)
        if cornerRadius != 0.0 { self.clipsToBounds = true }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
