//
//  DateInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/31/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftDate

/// Event Date Input Page UI Controller.
final class DateInputViewController: UIViewController {
    
    // Holds the event input.
    private var eventInput: EventModel?
    
    // Closure called when transitioning to the previous page.
    private var completionHandler: ((Date?, Date?) -> Void)?
    
    /**
    Custom class init to set the modal presentation and transition style, update the date input fields for the current event, and assign a completion handler.

    - Parameters:
        - eventInput: Input entered so far for the current event being created.
        - completionHandler: Closure called when transitioning to the previous section.
    */
    init(eventInput: EventModel?, completionHandler: ((Date?, Date?) -> Void)?) {
        
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
        
        self.view = DateInputView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DateInputView else { return }
        
        // 2. Setting targets and delegation.
        _ = [view.startDateTextField, view.endDateTextField].map { $0.delegate = self }
        
        _ = [view.startDatePicker, view.endDatePicker].map { $0.addTarget(self, action: #selector(setDate(from:)), for: .valueChanged) }
        
        view.actionButton.addTarget(self, action: #selector(moveToNextInputField), for: .touchUpInside)
        view.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to update UI, and begin editing the input field.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DateInputView else { return }
        
        // 2. Updating input field UI with event input passed.
        view.updateUI(eventInput: eventInput)
        
        // 3. Begin editing.
        view.startDateTextField.becomeFirstResponder()
        
    }
    
    // Formats the date from the picker passed and assigns it to the respective input field. Also, it updates the duration label.
    @objc private func setDate(from picker: UIDatePicker) {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DateInputView else { return }
        
        if picker == view.startDatePicker {
            
            // 2. Update input field with formatted date from picker.
            view.startDateTextField.text = picker.date.getFormattedDate()
            
            // 3. Update duration label (and if next input field is empty, update the default date shown on the next date picker).
            if view.endDateTextField.isEmpty() {
                
                view.endDatePicker.date = picker.date + view.minEventDuration
                view.durantionLabel.text = "Duration: " + view.getFormattedDuration(startDate: picker.date, endDate: nil)
                
            } else {
                
                view.durantionLabel.text = "Duration: " + view.getFormattedDuration(startDate: picker.date, endDate: view.endDatePicker.date)
                
            }
            
            // 4. Notify input field changes.
            view.inputFieldsDidChange()
            
        } else if picker == view.endDatePicker {
            
            // 5. Update input field with formatted date from picker.
            view.endDateTextField.text = picker.date.getFormattedDate()
            
            // 6. Update duration label.
            if view.startDateTextField.isEmpty() {
                
                view.durantionLabel.text = "Duration: " + view.getFormattedDuration(startDate: nil, endDate: picker.date)
                
            } else {
                
                view.durantionLabel.text = "Duration: " + view.getFormattedDuration(startDate: view.startDatePicker.date, endDate: picker.date)
                
            }
            
            // 7. Notify input field changes.
            view.inputFieldsDidChange()
            
        }
        
    }
    
    // Transitions to the next input field. It is called by the action button inside the picker bar view.
    @objc private func moveToNextInputField() {
     
        // 1. Safe casting root view to custom view.
        guard let view = view as? DateInputView else { return }
        
        // 2. Transition to the next input field.
        if view.startDateTextField.isEditing {
            
            view.startDateTextField.resignFirstResponder()
            view.endDateTextField.becomeFirstResponder()
            
        } else if view.endDateTextField.isEditing {
            
            view.endDateTextField.resignFirstResponder()
            view.startDateTextField.becomeFirstResponder()
            
        }
        
    }
    
    // Close the input field without saving changes.
    @objc private func cancel() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DateInputView else { return }
        
        // 2. If the user has made any changes, show an alert reminding the user that any changes will be lost.
        if view.startDateTextField.isEmpty() || view.endDateTextField.isEmpty() {
            
            dismiss(animated: true, completion: nil)
            
        } else if let startDate = eventInput?.startDate, let endDate = eventInput?.endDate, startDate == view.startDatePicker.date, endDate == view.endDatePicker.date {
            
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
        guard let view = view as? DateInputView else { return }
        
        // 2. If any dates are missing, or the start date is after the end date, or the duration is too small or too big show an error. Else, if changes have been made call the return closure.
        if view.startDateTextField.isEmpty() && view.endDateTextField.isEmpty() {
            
            let alertVC = AlertViewController(alertTitle: "Dates missing", alertMessage: "Please select a start and end date.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if view.startDateTextField.isEmpty() {
            
            let alertVC = AlertViewController(alertTitle: "Start date missing", alertMessage: "Please select a start date.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if view.endDateTextField.isEmpty() {
            
            let alertVC = AlertViewController(alertTitle: "End date missing", alertMessage: "Please enter an end date.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if view.startDatePicker.date.isAfterDate(view.endDatePicker.date, granularity: .minute) {
            
            let alertVC = AlertViewController(alertTitle: "Invalid date", alertMessage: "Start date should be prior to end date.")
            
            self.present(alertVC, animated: true, completion: nil)
        
        } else if (view.startDatePicker.date + view.minEventDuration) > view.endDatePicker.date {
            
            let alertVC = AlertViewController(alertTitle: "Ivalid duration", alertMessage: "The event has to be at least 30 minutes long.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if (view.startDatePicker.date + view.maxEventDuration) < view.endDatePicker.date {
            
            let alertVC = AlertViewController(alertTitle: "Ivalid duration", alertMessage: "The event cannot be more than 8 hours long.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if let startDate = eventInput?.startDate, let endDate = eventInput?.endDate, startDate == view.startDatePicker.date, endDate == view.endDatePicker.date {
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            completionHandler?(view.startDatePicker.date, view.endDatePicker.date)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

extension DateInputViewController: UITextFieldDelegate {
    
    /**
    Delegate function triggered when an input field begins editing. Update the picker bar view elements.

    - Parameters:
        - textField: Input field that began editing.
    */
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DateInputView else { return false }
        
        if textField == view.startDateTextField {
            
            view.typeLabel.text = "Start Date and Time"
            view.actionButton.setTitle("Next", for: .normal)
            
            return true
            
        } else if textField == view.endDateTextField {
            
            view.typeLabel.text = "End Date and Time"
            view.actionButton.setTitle("Back", for: .normal)
            
            return true
            
        }
        
        return false
        
    }
    
    /**
    Delegate function triggered when an input field finishes editing. Format the date returned from the respective date picker and assign it to the text field.

    - Parameters:
        - textField: Input field that finished editing.
    */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? DateInputView else { return true }
        
        if textField == view.startDateTextField {
            
            setDate(from: view.startDatePicker)
            
        } else if textField == view.endDateTextField {
            
            setDate(from: view.endDatePicker)
            
        }
        
        return true
        
    }
    
}
