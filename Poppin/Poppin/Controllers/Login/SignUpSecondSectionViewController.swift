//
//  SignUpSecondSectionViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/16/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Second Section of Sign Up (Name and Date of Birth) UI Controller.
final class SignUpSecondSectionViewController: UIViewController {
    
    // University picked on previous page.
    private var university: University?
    
    // Firebase Auth wrapper.
    lazy private var authController = AuthController()
    
    // Formats a date object into a human readable string.
    lazy private var dateFormatter: DateFormatter = {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter
        
    }()
    
    /**
    Custom class init that initializes the university object.

    - Parameter university: University object (picked on the first section of sign up) - Default value: nil.
    */
    init(university: University? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.university = university
        
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
        
        self.view = SignUpSecondSectionView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpSecondSectionView else { return }
        
        // 2. Setting targets and delegation.
        _ = [view.fullNameTextField, view.dateOfBirthTextField].map { $0.delegate = self }
        
        view.nextButton.addTarget(self, action: #selector(transitionToNextPage), for: .touchUpInside)
        view.backButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
        view.datePicker.addTarget(self, action: #selector(setDateFromPicker), for: .valueChanged)
        
    }
    
    /// Overrides superclass method to reset input fields and enable swipe back.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpSecondSectionView else { return }
        
        // 2. Resets previously entered credentials if any.
        view.inputFieldsDidChange()
        
        // 3. Enables swipe to transition back.
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    /// Overrides superclass method to activate name input field.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpSecondSectionView else { return }
        
        // 2. Activate the name input field.
        view.fullNameTextField.becomeFirstResponder()
        
    }
    
    /// Overrides superclass method to disable swipe back.
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // 1. Disables swipe to transition back.
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    // Once a name and a valid date of birth have been selected, this function transitions to the next page.
    @objc private func transitionToNextPage() {
        
        // 1. Safe cast root view to custom view.
        guard let view = view as? SignUpSecondSectionView else { return }
        
        // 2. Empty input safe check. If fails, show error.
        if let fullName = view.fullNameTextField.text, let dateOfBirth = view.dateOfBirthTextField.text, fullName != "", dateOfBirth != "" {
            
            // 3. Age safe check. If fails, show error and return to start page.
            if isAgeValid(dateOfBirth: view.datePicker.date) {
                
                // 4. Transition to next page.
                navigationController?.pushViewController(SignUpThirdSectionViewController(university: university, fullName: fullName, dateOfBirth: view.datePicker.date), animated: true)
                
            } else {
                
                let alertVC = AlertViewController(alertTitle: "Unable to proceed with the sign up", alertMessage: "It was not possible to proceed with the sign up. Thanks for checking out Poppin.", leftAction: { [weak self] in
                
                    guard let self = self else { return }
                    
                    self.navigationController?.popToRootViewController(animated: true)
                
                })
                
                self.present(alertVC, animated: true, completion: nil)
                
            }
            
        } else {
            
            let alertVC = AlertViewController()
            
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    // Checks if age is above 13 with the provided date of birth.
    private func isAgeValid(dateOfBirth: Date) -> Bool {
        
        guard let age = Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year else { return false }
        
        return age >= 13
        
    }
    
    // Transitions to the previous page of the sign up.
    @objc private func transitionToPreviousPage() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // Set the date of birth input field.
    @objc private func setDateFromPicker() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpSecondSectionView else { return }
        
        // 2. Format new date from picker and assign it to the input field.
        view.dateOfBirthTextField.text = dateFormatter.string(from: view.datePicker.date)
        
        // 3. Update input field.
        view.inputFieldsDidChange()
        
    }
    
}

extension SignUpSecondSectionViewController: UITextFieldDelegate {
    
    /**
    Delegate function triggered by the return button on the keyboard. Hops to the next input field.

    - Parameters:
        - textField: Input field that returned
    */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpSecondSectionView else { return true }
        
        textField.resignFirstResponder()
        
        if textField == view.fullNameTextField {
            
            view.dateOfBirthTextField.becomeFirstResponder()
            
        }
        
        return true
        
    }
    
}

extension SignUpSecondSectionViewController: UIGestureRecognizerDelegate {
    
    /// REQUIRED: Fails other gesture recognizers when swiping to transition back.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
