//
//  DetailsInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Event Details Input Page UI Controller.
final class DetailsInputViewController: UIViewController {
    
    // Holds the event input.
    private var eventInput: EventModel?
    
    // Closure called when transitioning to the previous page.
    private var completionHandler: ((String?) -> Void)?
    
    /**
    Custom class init to set the modal presentation and transition style, update the details input field for the current event, and assign a completion handler.

    - Parameters:
        - eventInput: Input entered so far for the current event being created.
        - completionHandler: Closure called when transitioning to the previous section.
    */
    init(eventInput: EventModel?, completionHandler: ((String?) -> Void)?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
        self.eventInput = eventInput
        self.completionHandler = completionHandler
        
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
        
        self.view = DetailsInputView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DetailsInputView else { return }
        
        // 2. Setting targets and delegation.
        view.detailsTextView.delegate = self
        view.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to add keyboard notifiers, update UI, and begin editing the input field.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Adding notifiers for when the keyboard shows and hides.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 2. Safe casting root view to custom view.
        guard let view = view as? DetailsInputView else { return }
        
        // 3. Updating input field UI with event input passed.
        view.updateUI(eventInput: eventInput)
        
        // 4. Begin editing.
        view.detailsTextView.becomeFirstResponder()
        
    }
    
    /// Overrides superclass method to remove keyboard notifiers.
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // 1. Removing notifiers for when the keyboard shows and hides.
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    // Adjusts the content stack to prevent the keyboard from overlapping the input field.
    @objc private func adjustForKeyboard(notification: Notification) {
        
        // 1. Safe casting keyboard information.
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        // 2. Safe casting root view to custom view.
        guard let view = view as? DetailsInputView else { return }

        // 3. Getting keyboard height.
        let keyboardHeight = view.convert(keyboardValue.cgRectValue, from: view.window).height

        // 4. Adjust content stack according to wether the keyboard is showing or hiding.
        if notification.name == UIResponder.keyboardWillHideNotification {
            
            var contentInset = view.contentStack.contentInset
            contentInset.bottom = view.contentStack.padding.bottom
            view.contentStack.contentInset = contentInset
            
        } else {
            
            var contentInset = view.contentStack.contentInset
            contentInset.bottom = keyboardHeight + view.characterCountLabel.intrinsicContentSize.height + view.contentStack.padding.bottom
            view.contentStack.contentInset = contentInset
            
        }
        
        view.contentStack.scrollIndicatorInsets = view.contentStack.contentInset

    }
    
    // Close the input field without saving changes.
    @objc private func cancel() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DetailsInputView else { return }
        
        // 2. If the user has made any changes, show an alert reminding the user that any changes will be lost.
        if let eventDetails = eventInput?.details, eventDetails == view.detailsTextView.text {
            
            dismiss(animated: true, completion: nil)
            
        } else if view.detailsTextView.isEmpty() {
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            let alertVC = AlertViewController(alertTitle: "Are you sure you wisth to exit?", alertMessage: "Any edits will be lost.", leftActionTitle: "Exit", leftAction: { [weak self] in
                
                guard let self = self else { return }
                
                self.dismiss(animated: true, completion: nil)
            
            }, rightActionTitle: "Stay")
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    // Close the input field and save changes by calling the return closure.
    @objc private func save() {
    
        // 1. Safe casting root view to custom view.
        guard let view = view as? DetailsInputView else { return }
        
        // 2. If details are too long show an error. Else, if changes have been made call the return closure.
        if view.detailsTextView.isEmpty() {
            
            completionHandler?(nil)
            dismiss(animated: true, completion: nil)
            
        } else if view.detailsTextView.text.count > view.maxCharacterCount {
            
            let alertVC = AlertViewController(alertTitle: "Details are too long", alertMessage: "Please shorten the details.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if let eventDetails = eventInput?.details, eventDetails == view.detailsTextView.text {
            
            completionHandler?(nil)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            completionHandler?(view.detailsTextView.text)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

extension DetailsInputViewController: UITextViewDelegate {
    
    /// Delegate function called when the text view is about to change its text. It updates the character count. If the length is beyond the max character count ignore changes.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DetailsInputView else { return false }
        
        if textView == view.detailsTextView {
            
            // 3. Update the character count based on the new text entered.
            let newText = NSString(string: textView.text).replacingCharacters(in: range, with: text)
            
            // 4. Update character count unless the max character count has been met.
            if newText.count <= view.maxCharacterCount {
                
                view.characterCountLabel.text = String(newText.count) + " / 500"
                
            }
            
            return newText.count <= view.maxCharacterCount
            
        } else {
            
            return false
            
        }
        
    }
    
}


