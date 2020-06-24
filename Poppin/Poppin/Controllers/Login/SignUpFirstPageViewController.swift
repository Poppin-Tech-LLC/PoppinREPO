//
//  SignUpFirstPageViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/16/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class SignUpFirstPageViewController: UIViewController {
    
    let loginInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    let innerElementsSpacing: CGFloat = .getPercentageWidth(percentage: 3)
    
    private let datePicker: UIDatePicker = {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(setDateFromPicker), for: .valueChanged)
        return datePicker
        
    }()
    
    lazy private var signUpContainerView: UIView = {
        
        let contentStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let contentStackView = UIStackView(arrangedSubviews: [fullNameTextField, dateOfBirthTextField, signUpNextButton])
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = contentStackViewSpacing
        
        var signUpContainerView = UIView(frame: .zero)
        signUpContainerView.backgroundColor = .white
        signUpContainerView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
        signUpContainerView.addSubview(contentStackView)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.topAnchor.constraint(equalTo: signUpContainerView.topAnchor, constant: (containerInsetY*1.1)+poppinTitleLabel.intrinsicContentSize.height+contentStackViewSpacing).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: signUpContainerView.leadingAnchor, constant: containerInsetX).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: signUpContainerView.trailingAnchor, constant: -containerInsetX).isActive = true
        
        signUpContainerView.addSubview(switchToLoginTab)
        switchToLoginTab.bottomAnchor.constraint(equalTo: signUpContainerView.bottomAnchor).isActive = true
        switchToLoginTab.leadingAnchor.constraint(equalTo: signUpContainerView.leadingAnchor).isActive = true
        switchToLoginTab.trailingAnchor.constraint(equalTo: signUpContainerView.trailingAnchor).isActive = true
        
        return signUpContainerView
        
    }()
    
    lazy private var fullNameTextField: UITextField = {
        
        var fullNameTextField = UITextField()
        fullNameTextField.backgroundColor = .clear
        fullNameTextField.textColor = .mainDARKPURPLE
        fullNameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        fullNameTextField.attributedPlaceholder = NSAttributedString(string: "Full name", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        fullNameTextField.delegate = self
        fullNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: fullNameTextField.intrinsicContentSize.height))
        fullNameTextField.leftViewMode = .always
        fullNameTextField.clearButtonMode = .whileEditing
        fullNameTextField.returnKeyType = .next
        fullNameTextField.autocapitalizationType = .none
        fullNameTextField.autocorrectionType = .no
        fullNameTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        fullNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
        fullNameTextField.heightAnchor.constraint(equalToConstant: fullNameTextField.intrinsicContentSize.height+(loginInnerInset*0.4)).isActive = true
        
        return fullNameTextField
        
    }()
    
    lazy private var dateOfBirthTextField: UITextField = {
        
        let dateToolbar = UIToolbar()
        dateToolbar.sizeToFit()
        let dateDoneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissDatePicker))
        let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        dateToolbar.setItems([dateFlexSpace, dateDoneButton], animated: true)
        
        var dateOfBirthTextField = UITextField()
        dateOfBirthTextField.backgroundColor = .clear
        dateOfBirthTextField.textColor = .mainDARKPURPLE
        dateOfBirthTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        dateOfBirthTextField.attributedPlaceholder = NSAttributedString(string: "Date of birth", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        dateOfBirthTextField.delegate = self
        dateOfBirthTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: dateOfBirthTextField.intrinsicContentSize.height))
        dateOfBirthTextField.leftViewMode = .always
        dateOfBirthTextField.clearButtonMode = .whileEditing
        dateOfBirthTextField.returnKeyType = .next
        dateOfBirthTextField.autocapitalizationType = .none
        dateOfBirthTextField.autocorrectionType = .no
        dateOfBirthTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        dateOfBirthTextField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
        
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.inputAccessoryView = dateToolbar
        
        dateOfBirthTextField.translatesAutoresizingMaskIntoConstraints = false
        dateOfBirthTextField.heightAnchor.constraint(equalToConstant: dateOfBirthTextField.intrinsicContentSize.height+(loginInnerInset*0.4)).isActive = true
        
        return dateOfBirthTextField
        
    }()
    
    lazy private var signUpNextButton: BouncyButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 2.5)
        
        var signUpNextButton = BouncyButton(bouncyButtonImage: nil)
        signUpNextButton.backgroundColor = .mainDARKPURPLE
        signUpNextButton.setTitle("Next", for: .normal)
        signUpNextButton.setTitleColor(.white, for: .normal)
        signUpNextButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .callout)
        signUpNextButton.titleLabel?.textAlignment = .center
        signUpNextButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        signUpNextButton.isUserInteractionEnabled = false
        signUpNextButton.addTarget(self, action: #selector(transitionToNextPage(sender:)), for: .touchUpInside)
        signUpNextButton.alpha = 0.6
        
        signUpNextButton.translatesAutoresizingMaskIntoConstraints = false
        signUpNextButton.heightAnchor.constraint(equalToConstant: signUpNextButton.intrinsicContentSize.height+innerEdgeInset).isActive = true
        
        return signUpNextButton
        
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
        
        view.addSubview(poppinTitleLabel)
        poppinTitleLabel.topAnchor.constraint(equalTo: signUpContainerView.topAnchor, constant: containerInsetY).isActive = true
        poppinTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    @objc private func dismissDatePicker() {
        
        setDateFromPicker()
        dateOfBirthTextField.resignFirstResponder()
        
    }
    
    @objc private func setDateFromPicker() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
        
    }
    
    @objc private func textFieldDidChange() {
        
        if fullNameTextField.text != "" && dateOfBirthTextField.text != "" && !signUpNextButton.isUserInteractionEnabled {
            
            signUpNextButton.isUserInteractionEnabled = true
            signUpNextButton.alpha = 1.0
            
        } else if fullNameTextField.text == "" || dateOfBirthTextField.text == "" && signUpNextButton.isUserInteractionEnabled {
            
            signUpNextButton.isUserInteractionEnabled = false
            signUpNextButton.alpha = 0.6
            
        }
        
    }
    
    @objc private func transitionToNextPage(sender: BouncyButton) {
        
        let currentDate = Date()
        let dateOfBirth = datePicker.date
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: currentDate)
        let age = ageComponents.year
        
        var validSteps = 0
        
        if let fullName = fullNameTextField.text, fullName != "" {
            
            validSteps+=1
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
            let alertVC = AlertViewController(alertTitle: "Invalid name", alertMessage: "The entered name is invalid. Please try again.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
        if let age = age, age >= 13 {
            
            validSteps+=1
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: { [weak self] in
            
                guard let self = self else { return }
                
                self.navigationController?.popToRootViewController(animated: true)
            
            })
            
            let alertVC = AlertViewController(alertTitle: "Unable to proceed with the sign up", alertMessage: "It was not possible to proceed with the sign up. Thanks for checking out Poppin.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
        if validSteps == 2 {
            
            self.navigationController?.pushViewController(SignUpSecondPageViewController(fullName: fullNameTextField.text!, age: age!), animated: true)
            
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
        
        fullNameTextField.text = ""
        dateOfBirthTextField.text = ""
        
        textFieldDidChange()
        
        datePicker.date = Date()
        
    }
    
}

extension SignUpFirstPageViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == fullNameTextField {
            
            dateOfBirthTextField.becomeFirstResponder()
            
        }
        
        return true
        
    }
    
}
