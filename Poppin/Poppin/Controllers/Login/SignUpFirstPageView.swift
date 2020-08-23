//
//  SignUpFirstPageView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/20/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// University Selection Page UI.
final class SignUpFirstPageView: UIView {
    
    // Hides picker on tap.
    lazy private var dismissPickerGesture: UITapGestureRecognizer = {
       
        var dismissPickerGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        dismissPickerGesture.cancelsTouchesInView = false
        return dismissPickerGesture
        
    }()
    
    // Poppin gold background.
    lazy private var backgroundView = UIImageView(image: UIImage.appBackground.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 100), height: .height(percent: 100))))
    
    // Card container.
    lazy private var cardView: UIView = {
       
        var cardView = CardView(bgColor: .white, padding: UIEdgeInsets(top: .width(percent: 6.0), left: .width(percent: 9.0), bottom: 0.0, right: .width(percent: 9.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        cardView.clipsToBounds = true
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [topStack, bottomStack].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        topStack.anchor(top: cardView.layoutMarginsGuide.topAnchor, leading: cardView.layoutMarginsGuide.leadingAnchor, trailing: cardView.layoutMarginsGuide.trailingAnchor)
        
        bottomStack.anchor(leading: cardView.leadingAnchor, bottom: cardView.layoutMarginsGuide.bottomAnchor, trailing: cardView.trailingAnchor)
        
        return cardView
        
    }()
    
    // Top content stack.
    lazy private var topStack: StackView = {
        
        var topStack = StackView(subviews: [universityHelpLabel, universityTextField, nextButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 7.0), padding: .zero)
        topStack.setCustomSpacing(.width(percent: 8.0), after: universityHelpLabel)
        return topStack
        
    }()
    
    // Input description.
    lazy private var universityHelpLabel = OctarineLabel(text: "Select University:", color: .mainDARKPURPLE, bold: true, style: .headline, size: nil, alignment: .center, lineLimit: 0)
    
    /// List of university names for the user to pick.
    lazy private(set) var universityPickerView: UIPickerView = UIPickerView()
    
    /// University input field.
    lazy private(set) var universityTextField: UITextField = {
        
        var universityTextField = UITextField()
        universityTextField.backgroundColor = .clear
        universityTextField.textColor = .mainDARKPURPLE
        universityTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        universityTextField.attributedPlaceholder = NSAttributedString(string: "University", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        universityTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: universityTextField.intrinsicContentSize.height))
        universityTextField.leftViewMode = .always
        universityTextField.autocapitalizationType = .none
        universityTextField.autocorrectionType = .no
        universityTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        universityTextField.inputView = universityPickerView
        return universityTextField
        
    }()
    
    /// Button that transitions to the next page of the sign up..
    lazy private(set) var nextButton = LoadingButton(bgColor: .mainDARKPURPLE, label: OctarineLabel(text: "Next", color: .white, bold: true, style: .subheadline, size: nil, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 2.5), left: 0.0, bottom: .width(percent: 2.5), right: 0.0), cornerRadius: .width(percent: 3.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
    
    // Bottom content stack.
    lazy private var bottomStack: StackView = StackView(subviews: [borderView, loginButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: 0.0, padding: .zero)
    
    // Login button border.
    lazy private var borderView: UIView = {
        
        var borderView = UIView()
        borderView.backgroundColor = .mainDARKPURPLE
        borderView.anchor(size: CGSize(width: 0.0, height: 1.0))
        return borderView
        
    }()
    
    /// Button that transitions to the login page.
    lazy private(set) var loginButton: OctarineButton = {
        
        let loginButtonText = NSMutableAttributedString(string: "Already have an account? Log In", attributes: [.foregroundColor : UIColor.mainDARKPURPLE])
        let lightRange = loginButtonText.mutableString.range(of: "Already have an account?")
        let boldRange = loginButtonText.mutableString.range(of: "Log In")
        loginButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), range: boldRange)
        loginButtonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), range: lightRange)
        
        var loginButton = OctarineButton(bgColor: .clear, label: OctarineLabel(text: nil, size: nil, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 3.5), left: 0.0, bottom: .width(percent: 3.5), right: 0.0))
        loginButton.titleEdgeInsets.top = -.width(percent: 1.0)
        loginButton.setAttributedTitle(loginButtonText, for: .normal)
        return loginButton
        
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
        
        // 1. Add a tap dismissal gesture for the picker.
        addGestureRecognizer(dismissPickerGesture)
        
        // 2. Add subviews to the root view (each one on top of the others).
        _ = [backgroundView, cardView].map { self.addSubview($0) }
        
        // 3. Apply constraints.
        backgroundView.attatchEdgesToSuperview()
        
        cardView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 3.0), right: .width(percent: 4.0)))
        
    }
    
    // Hides the picker.
    @objc private func dismissPicker() { endEditing(true) }
    
    /// Called when changes occur to any of the input fields. Enables or disables the next button according to the input fields content.
    func inputFieldsDidChange() {
        
        // 1. Once input fields have been filled, enable the login button.
        if !universityTextField.isEmpty() && nextButton.isDisabled {
            
            nextButton.isDisabled = false
            
        } else if universityTextField.isEmpty() && !nextButton.isDisabled {
            
            nextButton.isDisabled = true
            
        }
        
    }
    
}

struct SignUpFirstPageViewPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = SignUpFirstPageView
    
}

struct SignUpFirstPageViewPreview_Test: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = SignUpFirstPageViewPreview
    
}
