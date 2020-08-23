//
//  StartViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/13/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SafariServices

/// Start Page UI Controller.
final class StartViewController: UIViewController {
    
    /**
    Overrides superclass initializer to set the modal presentation and transition style.

    - Parameters:
        - nibName: Name of the storyboard (nil)
        - bundle: Bundle (nil)
    */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Overrides superclass method to initialize the root view with a custom UI.
    override func loadView() {
        
        self.view = StartView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller. Some UI elements are also hidden out.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? StartView else { return }
        
        // 2. Hide certain UI elements until the view appears.
        view.animateOut(animated: false)
        
        // 3. Setting targets and delegation.
        view.loginButton.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        view.signUpButton.addTarget(self, action: #selector(showSignUp), for: .touchUpInside)
        view.disclaimerTextView.delegate = self
        
    }
    
    /// Overrides superclass method to animate the appearance of UI elements.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? StartView else { return }
        
        // 2. Show UI elements previously hidden.
        view.animateIn(animated: true)
        
    }
    
    // Transition to the Login Page.
    @objc private func showLogin() {
        
        navigationController?.pushViewController(LoginViewController(), animated: true)
        
    }
    
    // Transition to the Sign Up Page.
    @objc private func showSignUp() {
        
        navigationController?.pushViewController(SignUpFirstPageViewController(), animated: true)
        
    }
    
}

extension StartViewController: UITextViewDelegate, SFSafariViewControllerDelegate {
    
    /**
    Delegate function triggered by the terms and privacy policy links. Opens a safari page.

    - Parameters:
        - textView: Disclaimer text view
        - URL: Link triggered
    */
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == "Terms" || URL.absoluteString == "Privacy" {
            
            // Safari page representation, presented as a sheet popover.
            let vc = SFSafariViewController(url: URL)
            vc.modalPresentationStyle = .pageSheet
            vc.modalTransitionStyle = .coverVertical
            vc.delegate = self
            present(vc, animated: true)
            
        }
        
        return false
        
    }
    
    /**
    Delegate function triggered when the safari page is closed.

    - Parameter controller: Safari page
    */
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        controller.dismiss(animated: true)
        
    }
    
}


