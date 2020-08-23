//
//  AlertViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/18/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Alert Popover UI Controller.
final class AlertViewController: UIViewController {
    
    /// "Something went wrong"
    static let defaultAlertTitle = "Something went wrong"
    
    /// "Please try again."
    static let defaultAlertMessage = "Please try again."
    
    /// "Ok"
    static let defaultActionTitle = "Ok"
    
    /// Title of the alert (set to default value if nil).
    private(set) var alertTitle: String = AlertViewController.defaultAlertTitle
    
    /// Message of the alert (set to default value if nil).
    private(set) var alertMessage: String = AlertViewController.defaultAlertMessage
    
    /// Title of the alert's left action (set to default value if nil).
    private(set) var leftActionTitle: String = AlertViewController.defaultActionTitle
    
    /// Title of the alert's right action. Optional value.
    private(set) var rightActionTitle: String?
    
    /// Alert's left action. Optional value.
    private(set) var leftAction: (() -> Void)?
    
    /// Alert's right action. Optional value.
    private(set) var rightAction: (() -> Void)?
    
    /**
    Custom class init that initializes the alert's title, message, and actions. Also, the modal transition and presentation styles are set up.

    - Parameters:
        - alertTitle: Main reason for the alert (set to default value if nil).
        - alertMessage: More details about the alert (set to default value if nil).
        - leftActionTitle: Left action description (set to default value if nil).
        - leftAction: Action performed if the left button of the alert is pressed (set to default value if nil).
        - rightActionTitle: Right action description (set to default value if nil).
        - rightAction: Action performed if the right button of the alert is pressed (set to default value if nil).
    */
    init(alertTitle: String? = AlertViewController.defaultAlertTitle, alertMessage: String? = AlertViewController.defaultAlertMessage, leftActionTitle: String? = AlertViewController.defaultActionTitle, leftAction: (() -> Void)? = nil, rightActionTitle: String? = nil, rightAction: (() -> Void)? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        
        // 1. Initialize the alert parameters.
        self.alertTitle = alertTitle ?? AlertViewController.defaultAlertTitle
        self.alertMessage = alertMessage ?? AlertViewController.defaultAlertMessage
        self.leftActionTitle = leftActionTitle ?? AlertViewController.defaultActionTitle
        self.leftAction = leftAction
        self.rightActionTitle = rightActionTitle
        self.rightAction = rightAction
        
        // 2. Set transition styles.
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
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
        
        self.view = AlertView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? AlertView else { return }
        
        // 2. Setting targets.
        view.leftButton.addTarget(self, action: #selector(executeAction(sender:)), for: .touchUpInside)
        view.rightButton.addTarget(self, action: #selector(executeAction(sender:)), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to set the alert title, message, and buttons.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? AlertView else { return }
        
        view.titleLabel.text = alertTitle
        view.messageLabel.text = alertMessage
        view.leftButton.setTitle(leftActionTitle, for: .normal)
        
        if let rightActionTitle = rightActionTitle {
            
            view.rightButton.setTitle(rightActionTitle, for: .normal)
            
        } else {
            
            view.rightButton.isHidden = true
            
        }
        
    }
    
    // According to which button was pressed, close the alert and perform the corresponding action (if any).
    @objc private func executeAction(sender: UIButton) {
        
        if let senderTitle = sender.title(for: .normal), senderTitle == leftActionTitle {
            
            self.dismiss(animated: true, completion: leftAction)
            
        } else if let senderTitle = sender.title(for: .normal), let rightActionTitle = rightActionTitle, senderTitle == rightActionTitle {
            
            self.dismiss(animated: true, completion: rightAction)
            
        } else {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
