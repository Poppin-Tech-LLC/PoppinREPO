//
//  SignUpFirstSectionViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/16/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// First Section of Sign Up (University Selection) UI Controller.
final class SignUpFirstSectionViewController: UIViewController {
    
    // Firebase Auth wrapper.
    lazy private var authController = AuthController()
    
    // List of universities fetched from Firebase.
    lazy private var universities: [University] = []
    
    /**
    Overrides super class init to fetch a list of available universities from Firebase.

    - Parameters:
        - nibName: Nil since Storyboards are not used.
        - bundle: Nil since Bundles are not used.
     
    */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nil, bundle: nil)
        
        // 1. Sends a fetch request.
        authController.getUniversities { [weak self] (universities, error) in
            
            guard let self = self else { return }
            
            if error != nil {
                
                print("SignUpFirstPageViewController - Error: \(error!)")
                
            } else {
                
                // 2. Any results returned are added to the university list, and the picker is reloaded.
                if let universities = universities, !universities.isEmpty {
                    
                    self.universities = universities
                    
                    // Safe casting root view to custom view.
                    guard let view = self.view as? SignUpFirstSectionView else { return }
                    
                    view.universityPickerView.reloadComponent(0)
                    
                }
                
            }
            
        }
        
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
        
        self.view = SignUpFirstSectionView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpFirstSectionView else { return }
        
        // 2. Setting targets and delegation.
        view.universityPickerView.delegate = self
        
        view.nextButton.addTarget(self, action: #selector(transitionToNextPage), for: .touchUpInside)
        view.loginButton.addTarget(self, action: #selector(transitionToLogin), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to reset input fields.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpFirstSectionView else { return }
        
        // 2. Resets previously entered credentials if any.
        view.inputFieldsDidChange()
        
    }
    
    /// Overrides superclass method to show university picker.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? SignUpFirstSectionView else { return }
        
        // 2. Show the university picker.
        view.universityTextField.becomeFirstResponder()
        
    }
    
    // Once a university has been selected, this function transitions to the next page.
    @objc private func transitionToNextPage() {
        
        // 1. Safe cast root view to custom view.
        guard let view = view as? SignUpFirstSectionView else { return }
        
        // 2. Empty input safe check. If fails, show error.
        if !universities.isEmpty, view.universityPickerView.selectedRow(inComponent: 0) != 0 {
            
            // 3. Transition to next page passing the selected university.
            let university = universities[view.universityPickerView.selectedRow(inComponent: 0)-1]
            navigationController?.pushViewController(SignUpSecondSectionViewController(university: university), animated: true)
            
        } else {
            
            let alertVC = AlertViewController()
            
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    // Pushes a new login page or pops to a previous one if found.
    @objc private func transitionToLogin() {
        
        if let firstAfterRootVC = navigationController?.viewControllers[1] as? LoginViewController {
            
            navigationController?.popToViewController(firstAfterRootVC, animated: true)
            
        } else {
            
            navigationController?.pushViewController(LoginViewController(), animated: true)
            
        }
        
    }
    
}

extension SignUpFirstSectionViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    /// Delegate function that returns the number of components for the specified picker. Defaults to 1 component (list of universities).
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    /// Delegate function that returns the number of rows per component for the specified picker. Returns the number of universities in the list or 1 if none are available plus an extra row for the placeholder.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return (universities.isEmpty ? 1 : universities.count) + 1
        
    }
    
    /// Delegate function that returns the title attatched to each row  for the specified picker. Returns a string representing either a placeholder, a no results message, or the name of the university.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if row == 0 { return "-- Select a University --" }
        
        return universities.isEmpty ? "No results. Try refreshing the app" : universities[row-1].name
        
    }
    
    /// Delegate function that gets triggered once a row of the picker has been selected. If the selected row is a university name, the input field is updated with it.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Safe casting root view to custom view.
        guard let view = view as? SignUpFirstSectionView else { return }
        
        if row == 0 {
            
            view.universityTextField.text = ""
            view.inputFieldsDidChange()
            return
            
        }
        
        if !universities.isEmpty {
            
            view.universityTextField.text = universities[row-1].name
            view.inputFieldsDidChange()
            return
            
        }
        
    }
    
}
