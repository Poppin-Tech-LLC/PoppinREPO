//
//  StartViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/13/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class StartViewController: UIViewController {
    
    let loginInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let loginInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    private let termsLink = "Terms"
    private let privacyPolicyLink = "Privacy"
    
    lazy private var backgroundImageView: UIImageView = {
        
        var backgroundImageView = UIImageView(image: UIImage.appBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        return backgroundImageView
        
    }()
    
    lazy private var poppinTitleLabel: UILabel = {
        
        var poppinTitleLabel = UILabel()
        poppinTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        poppinTitleLabel.textColor = .white
        poppinTitleLabel.text = "poppin"
        poppinTitleLabel.textAlignment = .center
        poppinTitleLabel.alpha = 0.0
        poppinTitleLabel.transform = CGAffineTransform(translationX: 0.0, y: -(+poppinTitleLabel.intrinsicContentSize.height))
        
        poppinTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        poppinTitleLabel.heightAnchor.constraint(equalToConstant: poppinTitleLabel.intrinsicContentSize.height).isActive = true
        
        return poppinTitleLabel
        
    }()
    
    lazy private var poppinLogoImageView: UIImageView = {
       
        var poppinLogoImageView = UIImageView(image: UIImage.poppinEventPopsicleIcon256)
        poppinLogoImageView.contentMode = .scaleAspectFit
        
        poppinLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        poppinLogoImageView.heightAnchor.constraint(equalTo: poppinLogoImageView.widthAnchor).isActive = true
        
        return poppinLogoImageView
        
    }()
    
    lazy private var showLoginButton: BouncyButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
        
        var showLoginButton = BouncyButton(bouncyButtonImage: nil)
        showLoginButton.backgroundColor = .white
        showLoginButton.setTitle("Log In", for: .normal)
        showLoginButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        showLoginButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        showLoginButton.titleLabel?.textAlignment = .center
        showLoginButton.addTarget(self, action: #selector(showLogin(sender:)), for: .touchUpInside)
        showLoginButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        showLoginButton.alpha = 0.0
        showLoginButton.transform = CGAffineTransform(translationX: 0.0, y: (loginInsetY*2)+containerInsetY+disclaimerTextView.intrinsicContentSize.height+showSignUpButton.intrinsicContentSize.height+(innerEdgeInset*2)+showLoginButton.intrinsicContentSize.height)
        
        showLoginButton.translatesAutoresizingMaskIntoConstraints = false
        showLoginButton.heightAnchor.constraint(equalToConstant: showLoginButton.intrinsicContentSize.height+innerEdgeInset).isActive = true
        
        return showLoginButton
        
    }()
    
    lazy private var showSignUpButton: BouncyButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
        
        var showSignUpButton = BouncyButton(bouncyButtonImage: nil)
        showSignUpButton.backgroundColor = .white
        showSignUpButton.setTitle("Sign Up", for: .normal)
        showSignUpButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        showSignUpButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        showSignUpButton.titleLabel?.textAlignment = .center
        showSignUpButton.addTarget(self, action: #selector(showSignUp(sender:)), for: .touchUpInside)
        showSignUpButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        showSignUpButton.alpha = 0.0
        showSignUpButton.transform = CGAffineTransform(translationX: 0.0, y: (loginInsetY*1.5)+disclaimerTextView.intrinsicContentSize.height+showSignUpButton.intrinsicContentSize.height+innerEdgeInset)
        
        showSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        showSignUpButton.heightAnchor.constraint(equalToConstant: showSignUpButton.intrinsicContentSize.height+innerEdgeInset).isActive = true
        
        return showSignUpButton
        
    }()
    
    lazy private var disclaimerTextView: UITextView = {
        
        let disclaimerText = NSMutableAttributedString(string: "By clicking Log in or Sign up, you agree to our Terms and Privacy Policy", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)])
        let termsRange = disclaimerText.mutableString.range(of: "Terms")
        let privacyPolicyRange = disclaimerText.mutableString.range(of: "Privacy Policy")
        
        disclaimerText.addAttribute(.link, value: termsLink, range: termsRange)
        disclaimerText.addAttribute(.link, value: privacyPolicyLink, range: privacyPolicyRange)
        
        var disclaimerTextView = UITextView()
        disclaimerTextView.textContainerInset = .zero
        disclaimerTextView.attributedText = disclaimerText
        disclaimerTextView.linkTextAttributes = [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor : UIColor.white]
        disclaimerTextView.textColor = .white
        disclaimerTextView.backgroundColor = .clear
        disclaimerTextView.isEditable = false
        disclaimerTextView.isSelectable = true
        disclaimerTextView.isScrollEnabled = false
        disclaimerTextView.delegate = self
        disclaimerTextView.textAlignment = .center
        disclaimerTextView.alpha = 0.0
        disclaimerTextView.transform = CGAffineTransform(translationX: 0.0, y: loginInsetY+disclaimerTextView.intrinsicContentSize.height)
        return disclaimerTextView
        
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
        
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(poppinTitleLabel)
        poppinTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: containerInsetY+loginInsetY).isActive = true
        poppinTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(poppinLogoImageView)
        poppinLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        poppinLogoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        poppinLogoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33).isActive = true
        
        view.addSubview(disclaimerTextView)
        disclaimerTextView.translatesAutoresizingMaskIntoConstraints = false
        disclaimerTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -loginInsetY).isActive = true
        disclaimerTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginInsetX).isActive = true
        disclaimerTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginInsetX).isActive = true
        
        view.addSubview(showSignUpButton)
        showSignUpButton.bottomAnchor.constraint(equalTo: disclaimerTextView.topAnchor, constant: -loginInnerInset).isActive = true
        showSignUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginInsetX).isActive = true
        showSignUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginInsetX).isActive = true
        
        view.addSubview(showLoginButton)
        showLoginButton.bottomAnchor.constraint(equalTo: showSignUpButton.topAnchor, constant: -loginInnerInset).isActive = true
        showLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: loginInsetX).isActive = true
        showLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -loginInsetX).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.poppinTitleLabel.transform = .identity
            self.poppinTitleLabel.alpha = 1.0
            self.disclaimerTextView.transform = .identity
            self.disclaimerTextView.alpha = 1.0
            self.showSignUpButton.transform = .identity
            self.showSignUpButton.alpha = 1.0
            self.showLoginButton.transform = .identity
            self.showLoginButton.alpha = 1.0
            
        }, completion: nil)
        
    }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    @objc private func showLogin(sender: BouncyButton) {
        
        navigationController?.pushViewController(LoginViewController(), animated: true)
        
    }
    
    @objc private func showSignUp(sender: BouncyButton) {
        
        navigationController?.pushViewController(SignUpFirstPageViewController(), animated: true)
        
    }
    
}

extension StartViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString == "Terms" {
            
            // Future Action
            
            print("Showing Terms")
            
        } else if URL.absoluteString == "Privacy" {
            
            // Future Action
            
            print("Showing Privacy Policy")
            
        }
        
        return false
        
    }
    
}

