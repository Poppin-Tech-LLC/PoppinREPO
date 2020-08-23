//
//  SignUpSecondSectionView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/21/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// Full Name, and Date of Birth Input Section UI.
final class SignUpSecondSectionView: UIView {
    
    // Hides keyboard or picker on tap.
    lazy private var dismissInputGesture: UITapGestureRecognizer = {
       
        let dismissPickerGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissInput))
        dismissPickerGesture.cancelsTouchesInView = false
        return dismissPickerGesture
        
    }()
    
    // Poppin gold background.
    lazy private var backgroundView = UIImageView(image: UIImage.appBackground.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 100), height: .height(percent: 100))))
    
    // Card container.
    lazy private var cardView: UIView = {
       
        let cardView = CardView(bgColor: .white, padding: UIEdgeInsets(top: 0.0, left: .width(percent: 9.0), bottom: 0.0, right: .width(percent: 9.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [topStack, backButton].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        backButton.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor)
        
        topStack.anchor(top: backButton.bottomAnchor, leading: cardView.layoutMarginsGuide.leadingAnchor, trailing: cardView.layoutMarginsGuide.trailingAnchor)
        
        return cardView
        
    }()
    
    /// Button that transitions to the previous page of the sign up..
    lazy private(set) var backButton: OctarineButton = {
        
        let backButton = OctarineButton(bgColor: .clear, label: nil, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)))
        backButton.setImage(UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .medium)).withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal), for: .normal)
        return backButton
        
    }()
    
    // Top content scrollable stack.
    lazy private var topStack: StackView = {
        
        let topStack = StackView(subviews: [secondPageHelpLabel, fullNameTextField, dateOfBirthTextField, nextButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 7.0), padding: .zero)
        topStack.setCustomSpacing(.width(percent: 8.0), after: secondPageHelpLabel)
        return topStack
        
    }()
    
    // Input description.
    lazy private var secondPageHelpLabel = OctarineLabel(text: "Enter Name and Birthday:", color: .mainDARKPURPLE, bold: true, style: .headline, alignment: .center, lineLimit: 0)
    
    /// Full name input field.
    lazy private(set) var fullNameTextField: UITextField = {
        
        let fullNameTextField = UITextField()
        fullNameTextField.backgroundColor = .clear
        fullNameTextField.textColor = .mainDARKPURPLE
        fullNameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        fullNameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        fullNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: fullNameTextField.intrinsicContentSize.height))
        fullNameTextField.leftViewMode = .always
        fullNameTextField.autocapitalizationType = .words
        fullNameTextField.autocorrectionType = .no
        fullNameTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        fullNameTextField.addTarget(self, action: #selector(inputFieldsDidChange), for: .editingChanged)
        return fullNameTextField
        
    }()
    
    /// Date of birth input field.
    lazy private(set) var dateOfBirthTextField: UITextField = {
        
        let dateOfBirthTextField = UITextField()
        dateOfBirthTextField.backgroundColor = .clear
        dateOfBirthTextField.textColor = .mainDARKPURPLE
        dateOfBirthTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        dateOfBirthTextField.attributedPlaceholder = NSAttributedString(string: "Birthday", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        dateOfBirthTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: dateOfBirthTextField.intrinsicContentSize.height))
        dateOfBirthTextField.leftViewMode = .always
        dateOfBirthTextField.autocapitalizationType = .words
        dateOfBirthTextField.autocorrectionType = .no
        dateOfBirthTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        dateOfBirthTextField.inputView = datePicker
        return dateOfBirthTextField
        
    }()
    
    /// Date picker for the user to pick a date of birth.
    lazy private(set) var datePicker: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        return datePicker
        
    }()
    
    /// Button that transitions to the next page of the sign up..
    lazy private(set) var nextButton = LoadingButton(bgColor: .mainDARKPURPLE, label: OctarineLabel(text: "Next", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 2.5), left: 0.0, bottom: .width(percent: 2.5), right: 0.0), cornerRadius: .width(percent: 3.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
    
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
        addGestureRecognizer(dismissInputGesture)
        
        // 2. Add subviews to the root view (each one on top of the others).
        _ = [backgroundView, cardView].map { self.addSubview($0) }
        
        // 3. Apply constraints.
        backgroundView.attatchEdgesToSuperview()
        
        cardView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 3.0), right: .width(percent: 4.0)))
        
    }
    
    // Hides the active input field.
    @objc private func dismissInput() { endEditing(true) }
    
    /// Called when changes occur to any of the input fields. Enables or disables the next button according to the input fields content.
    @objc func inputFieldsDidChange() {
        
        // 1. Once input fields have been filled, enable the next button.
        if !fullNameTextField.isEmpty() && !dateOfBirthTextField.isEmpty() && nextButton.isDisabled {
            
            nextButton.isDisabled = false
            
        } else if fullNameTextField.isEmpty() || dateOfBirthTextField.isEmpty() && !nextButton.isDisabled {
            
            nextButton.isDisabled = true
            
        }
        
    }
    
}

struct SignUpSecondPageViewPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = SignUpSecondSectionView
    
}

struct SignUpSecondPageViewPreview_Test: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = SignUpSecondPageViewPreview
    
}

