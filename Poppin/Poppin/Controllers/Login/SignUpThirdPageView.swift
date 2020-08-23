//
//  SignUpThirdPageView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/21/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// Username, Email, and Password Input Page UI.
final class SignUpThirdPageView: UIView {
    
    // Hides keyboard on tap.
    lazy private var dismissKeyboardGesture: UITapGestureRecognizer = {
       
        var dismissKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        return dismissKeyboardGesture
        
    }()
    
    // Poppin gold background.
    lazy private var backgroundView = UIImageView(image: UIImage.appBackground.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 100), height: .height(percent: 100))))
    
    // Card container.
    lazy private var cardView: UIView = {
       
        var cardView = CardView(bgColor: .white, padding: UIEdgeInsets(top: 0.0, left: .width(percent: 9.0), bottom: 0.0, right: .width(percent: 9.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        cardView.clipsToBounds = true
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [topStack, navigationBar].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        navigationBar.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor)
        
        topStack.anchor(top: navigationBar.bottomAnchor, leading: cardView.layoutMarginsGuide.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.layoutMarginsGuide.trailingAnchor)
        
        return cardView
        
    }()
    
    /// Top bar containing the back button.
    lazy private var navigationBar: UIView = {
        
        var navigationBar = UIView()
        navigationBar.backgroundColor = .white
        navigationBar.apply(shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        navigationBar.layer.shadowOpacity = 0.0
        
        navigationBar.addSubview(backButton)
        backButton.anchor(top: navigationBar.topAnchor, leading: navigationBar.leadingAnchor, bottom: navigationBar.bottomAnchor)
        
        return navigationBar
        
    }()
    
    /// Button that transitions to the previous page of the sign up..
    lazy private(set) var backButton: OctarineButton = {
        
        var backButton = OctarineButton(bgColor: .clear, label: nil, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)))
        backButton.setImage(UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .medium)).withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal), for: .normal)
        return backButton
        
    }()
    
    // Top content scrollable stack.
    lazy private(set) var topStack: ScrollableStackView = {
        
        var topStack = ScrollableStackView(stackView: StackView(subviews: [thirdPageHelpLabel, usernameTextField, invalidUsernameLabel, emailTextField, invalidEmailLabel, passwordTextField, invalidPasswordLabel, confirmPasswordTextField, invalidConfirmPasswordLabel, signUpButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 7.0), padding: .zero), padding: UIEdgeInsets(top: .width(percent: 2.0), left: 0.0, bottom: 0.0, right: 0.0))
        topStack.delegate = self
        topStack.stackView.setCustomSpacing(.width(percent: 8.0), after: thirdPageHelpLabel)
        topStack.stackView.setCustomSpacing(.width(percent: 2.0), after: usernameTextField)
        topStack.stackView.setCustomSpacing(.width(percent: 2.0), after: emailTextField)
        topStack.stackView.setCustomSpacing(.width(percent: 2.0), after: passwordTextField)
        topStack.stackView.setCustomSpacing(.width(percent: 2.0), after: confirmPasswordTextField)
        return topStack
        
    }()
    
    // Input description.
    lazy private var thirdPageHelpLabel = OctarineLabel(text: "Enter Username, Email and Password:", color: .mainDARKPURPLE, bold: true, style: .headline, size: nil, alignment: .center, lineLimit: 0)
    
    /// Username input field.
    lazy private(set) var usernameTextField: UITextField = {
        
        var usernameTextField = UITextField()
        usernameTextField.backgroundColor = .clear
        usernameTextField.textColor = .mainDARKPURPLE
        usernameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: usernameTextField.intrinsicContentSize.height))
        usernameTextField.leftViewMode = .always
        usernameTextField.autocapitalizationType = .none
        usernameTextField.autocorrectionType = .no
        usernameTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        usernameTextField.addTarget(self, action: #selector(inputFieldsDidChange), for: .editingChanged)
        return usernameTextField
        
    }()
    
    /// Specifies what input is valid.
    lazy private(set) var invalidUsernameLabel: OctarineLabel = OctarineLabel(text: "3-15 characters (alphanumeric or underscore)", color: .mainDARKPURPLE, bold: true, style: .caption1, size: nil, alignment: .left, lineLimit: 0)
    
    /// Email input field.
    lazy private(set) var emailTextField: UITextField = {
        
        var emailTextField = UITextField()
        emailTextField.backgroundColor = .clear
        emailTextField.textColor = .mainDARKPURPLE
        emailTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: emailTextField.intrinsicContentSize.height))
        emailTextField.leftViewMode = .always
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        emailTextField.addTarget(self, action: #selector(inputFieldsDidChange), for: .editingChanged)
        return emailTextField
        
    }()
    
    /// Specifies what input is valid.
    lazy private(set) var invalidEmailLabel: OctarineLabel = OctarineLabel(text: "@du.edu", color: .mainDARKPURPLE, bold: true, style: .caption1, size: nil, alignment: .left, lineLimit: 0)
    
    /// Password input field.
    lazy private(set) var passwordTextField: UITextField = {
        
        var passwordTextField = UITextField()
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
    
    /// Specifies what input is valid.
    lazy private(set) var invalidPasswordLabel: OctarineLabel = OctarineLabel(text: "At least 8 characters, 1 upper case, and 1 digit", color: .mainDARKPURPLE, bold: true, style: .caption1, size: nil, alignment: .left, lineLimit: 0)
    
    /// Confirm password input field.
    lazy private(set) var confirmPasswordTextField: UITextField = {
        
        var confirmPasswordTextField = UITextField()
        confirmPasswordTextField.backgroundColor = .clear
        confirmPasswordTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        confirmPasswordTextField.textColor = .mainDARKPURPLE
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Repeat Password", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: confirmPasswordTextField.intrinsicContentSize.height))
        confirmPasswordTextField.leftViewMode = .always
        confirmPasswordTextField.clearButtonMode = .whileEditing
        confirmPasswordTextField.returnKeyType = .done
        confirmPasswordTextField.enablesReturnKeyAutomatically = true
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.autocorrectionType = .no
        confirmPasswordTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        confirmPasswordTextField.addTarget(self, action: #selector(inputFieldsDidChange), for: .editingChanged)
        return confirmPasswordTextField
        
    }()
    
    /// Specifies what input is valid.
    lazy private(set) var invalidConfirmPasswordLabel: OctarineLabel = OctarineLabel(text: "Password mismatch", color: .mainDARKPURPLE, bold: true, style: .caption1, size: nil, alignment: .left, lineLimit: 0)
    
    /// Button that signs up the user.
    lazy private(set) var signUpButton = LoadingButton(bgColor: .mainDARKPURPLE, label: OctarineLabel(text: "Sign Up", color: .white, bold: true, style: .subheadline, size: nil, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 2.5), left: 0.0, bottom: .width(percent: 2.5), right: 0.0), cornerRadius: .width(percent: 3.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
    
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
    
    /// Called when changes occur to any of the input fields. Enables or disables the sign up button according to the input fields content.
    @objc private func inputFieldsDidChange() {
        
        // 1. Once input fields have been filled, enable the next button.
        if !usernameTextField.isEmpty() && !emailTextField.isEmpty() && !passwordTextField.isEmpty() && !confirmPasswordTextField.isEmpty() && signUpButton.isDisabled {
            
            signUpButton.isDisabled = false
            
        } else if usernameTextField.isEmpty() || emailTextField.isEmpty() || passwordTextField.isEmpty() || confirmPasswordTextField.isEmpty() && !signUpButton.isDisabled {
            
            signUpButton.isDisabled = true
            
        }
        
    }
    
    /// Resets any input entered.
    func resetInputFields() {
        
        // 1. Resetting input fields.
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        
        // 2. Notifying changes.
        inputFieldsDidChange()
        
    }
    
}

extension SignUpThirdPageView: UIScrollViewDelegate {
    
    /**
    Delegate function triggered when the scroll view scrolls. Depending on the position of the scrollable content, the navigation bar drops a shadow.

    - Parameters:
        - scrollView: Scroll view that scrolled.
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= 0.0 && scrollView.contentOffset.y <= scrollView.contentInset.top {
         
            navigationBar.layer.shadowOpacity = Float(scrollView.contentOffset.y / scrollView.contentInset.top)
            
        } else if scrollView.contentOffset.y < 0.0 {
            
            navigationBar.layer.shadowOpacity = 0.0
            
        } else {
            
            navigationBar.layer.shadowOpacity = 1.0
            
        }
        
    }
    
}

struct SignUpThirdPageViewPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = SignUpThirdPageView
    
}

struct SignUpThirdPageViewPreview_Test: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = SignUpThirdPageViewPreview
    
}

class ScrollableStackView: UIScrollView {
    
    private(set) var stackView: StackView
    private(set) var padding: UIEdgeInsets
    
    override init(frame: CGRect) {
        
        self.stackView = StackView()
        self.padding = .zero
        
        super.init(frame: frame)
        
        contentInset = padding
        
        configureView()
        
    }
    
    init(stackView: StackView = StackView(), padding: UIEdgeInsets = .zero) {
        
        self.stackView = stackView
        self.padding = padding
        
        super.init(frame: .zero)
        
        contentInset = padding
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        if stackView.axis == .vertical {
            
            alwaysBounceVertical = false
            showsVerticalScrollIndicator = false
            
            addSubview(stackView)
            stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, width: widthAnchor)
            
        } else {
            
            alwaysBounceHorizontal = false
            showsHorizontalScrollIndicator = false
            
            addSubview(stackView)
            stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, height: heightAnchor)
            
        }
        
    }
    
}
