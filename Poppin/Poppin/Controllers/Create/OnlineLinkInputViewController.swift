//
//  OnlineLinkInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/4/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Online Link Input Page UI Controller.
final class OnlineLinkInputViewController: UIViewController {
    
    // Holds the event input.
    private var eventInput: EventModel?
    
    // Closure called when transitioning to the previous page.
    private var completionHandler: ((URL?) -> Void)?
    
    /**
    Custom class init to set the modal presentation and transition style, update the online link input field for the current event, and assign a completion handler.

    - Parameters:
        - eventInput: Input entered so far for the current event being created.
        - completionHandler: Closure called when transitioning to the previous section.
    */
    init(eventInput: EventModel?, completionHandler: ((URL?) -> Void)?) {
        
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
        
        self.view = OnlineLinkInputView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? OnlineLinkInputView else { return }
        
        // 2. Setting targets and delegation.
        view.onlineLinkTextView.delegate = self
        view.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        view.removeLinkButton.addTarget(self, action: #selector(remove), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to add keyboard notifiers, update UI, and begin editing the input field.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Adding notifiers for when the keyboard shows and hides.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // 2. Safe casting root view to custom view.
        guard let view = view as? OnlineLinkInputView else { return }
        
        // 3. Updating input field UI with event input passed.
        view.updateUI(eventInput: eventInput)
        
        // 4. Begin editing.
        view.onlineLinkTextView.becomeFirstResponder()
        
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
        guard let view = view as? OnlineLinkInputView else { return }

        // 3. Getting keyboard height.
        let keyboardHeight = view.convert(keyboardValue.cgRectValue, from: view.window).height

        // 4. Adjust content stack according to wether the keyboard is showing or hiding.
        if notification.name == UIResponder.keyboardWillHideNotification {
            
            var contentInset = view.contentStack.contentInset
            contentInset.bottom = view.contentStack.padding.bottom
            view.contentStack.contentInset = contentInset
            
        } else {
            
            var contentInset = view.contentStack.contentInset
            contentInset.bottom = keyboardHeight + view.removeLinkButton.intrinsicContentSize.height + view.contentStack.padding.bottom
            view.contentStack.contentInset = contentInset
            
        }
        
        view.contentStack.scrollIndicatorInsets = view.contentStack.contentInset

    }
    
    // Close the input field without saving changes.
    @objc private func cancel() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? OnlineLinkInputView else { return }
        
         // 2. If the user has made any changes, show an alert reminding the user that any changes will be lost.
        if let onlineLink = eventInput?.onlineURL, onlineLink.absoluteString == view.onlineLinkTextView.text {
            
            dismiss(animated: true, completion: nil)
            
        } else if view.onlineLinkTextView.isEmpty() {
            
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
        guard let view = view as? OnlineLinkInputView else { return }
        
        // 2. Initializing a URL detector.
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        // 2. If online link is invalid show an alert. Else, if changes have been made call the return closure.
        if view.onlineLinkTextView.isEmpty() {
            
            completionHandler?(nil)
            dismiss(animated: true, completion: nil)
            
        } else if let match = detector.firstMatch(in: view.onlineLinkTextView.text, options: [], range: NSRange(location: 0, length: view.onlineLinkTextView.text.utf16.count)), match.range.length == view.onlineLinkTextView.text.utf16.count {
            
            completionHandler?(URL(string: view.onlineLinkTextView.text))
            dismiss(animated: true, completion: nil)
            
        } else if let onlineLink = eventInput?.onlineURL, onlineLink.absoluteString == view.onlineLinkTextView.text {
            
            completionHandler?(nil)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            let alertVC = AlertViewController(alertTitle: "Link is invalid", alertMessage: "Please enter a valid link.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    // Removes the online event link associated with the current event and closes the input field.
    @objc private func remove() {
        
        completionHandler?(nil)
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension OnlineLinkInputViewController: UITextViewDelegate {
    
    /// Delegate function called when the text view is about to change its text. If the user presses the "enter" key, the text view finishes editing and the input is saved.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? OnlineLinkInputView else { return false }
        
        if textView == view.onlineLinkTextView {
            
            // 2. Enter key pressed. Save any changes.
            if text == "\n" {
                
                textView.resignFirstResponder()
                save()
                return false
                
            } else {
                
                return true
                
            }
            
        } else {
            
            return false
            
        }
        
    }
    
}


