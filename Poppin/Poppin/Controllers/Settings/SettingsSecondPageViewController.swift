//
//  SettingsSecondPageViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 7/30/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

class SettingsSecondPageViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let settingsInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    lazy var settingsLabel: UILabel = {
       let settingsLabel = UILabel()
        settingsLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        settingsLabel.backgroundColor = .clear
        settingsLabel.textColor = .white
        settingsLabel.textAlignment = .center
        settingsLabel.sizeToFit()
        return settingsLabel
    }()
    
    lazy private var backButton: ImageBubbleButton = {
        let backButton = ImageBubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft).withTintColor(.white))
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
    lazy private var menuPopsicleBorderImageView: UIImageView = {
        
        var menuPopsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.white))
        menuPopsicleBorderImageView.contentMode = .scaleAspectFit
        return menuPopsicleBorderImageView
        
    }()
    
    lazy private var accountSettingsScrollView: UIView = {

        let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let changePasswordButton = BouncyButton(bouncyButtonImage: nil)
        changePasswordButton.setTitle("Change password", for: .normal)
        changePasswordButton.setTitleColor(.white, for: .normal)
        changePasswordButton.backgroundColor = .clear
        changePasswordButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        changePasswordButton.addTarget(self, action: #selector(goToChangePassword), for: .touchUpInside)
        
        let subscriptionButton = BouncyButton(bouncyButtonImage: nil)
        subscriptionButton.setTitle("Subscription", for: .normal)
        subscriptionButton.setTitleColor(.white, for: .normal)
        subscriptionButton.backgroundColor = .clear
        subscriptionButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        
        let deactivateAccountButton = BouncyButton(bouncyButtonImage: nil)
        deactivateAccountButton.setTitle("Deactivate account", for: .normal)
        deactivateAccountButton.setTitleColor(.socialLIGHTRED, for: .normal)
        deactivateAccountButton.backgroundColor = .clear
        deactivateAccountButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        deactivateAccountButton.addTarget(self, action: #selector(goToDeactivateAccount), for: .touchUpInside)


        let settingsStackView = UIStackView(arrangedSubviews: [changePasswordButton, subscriptionButton, deactivateAccountButton])
        settingsStackView.axis = .vertical
        settingsStackView.alignment = .leading
        settingsStackView.distribution = .fill
        settingsStackView.spacing = settingsStackViewSpacing

        var settingsScrollView = UIScrollView()
        settingsScrollView.alwaysBounceVertical = true
        settingsScrollView.showsVerticalScrollIndicator = false
        settingsScrollView.automaticallyAdjustsScrollIndicatorInsets = false
        settingsScrollView.delaysContentTouches = false
        settingsScrollView.contentInset = UIEdgeInsets(top: .getPercentageWidth(percentage: 9), left: 0.0, bottom: .getPercentageWidth(percentage: 9), right: 0.0)
        
        settingsScrollView.addSubview(settingsStackView)
        settingsStackView.translatesAutoresizingMaskIntoConstraints = false
        settingsStackView.topAnchor.constraint(equalTo: settingsScrollView.topAnchor).isActive = true
        settingsStackView.bottomAnchor.constraint(equalTo: settingsScrollView.bottomAnchor).isActive = true
        settingsStackView.leadingAnchor.constraint(equalTo: settingsScrollView.leadingAnchor).isActive = true
        settingsStackView.trailingAnchor.constraint(equalTo: settingsScrollView.trailingAnchor).isActive = true
        settingsStackView.widthAnchor.constraint(equalTo: settingsScrollView.widthAnchor).isActive = true
        
        return settingsScrollView
       

        //return settingsStackView

    }()
    
    lazy private var privacySettingsScrollView: UIView = {

           let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let privateToggle = toggleView(text: "Account private", toggleState: false)
        privateToggle.addTarget(target: self, action: #selector(privateToggleSwitched(sender:)), for: .valueChanged)
        
        let blockedAccountsButton = BouncyButton(bouncyButtonImage: nil)
        blockedAccountsButton.setTitle("Blocked accounts", for: .normal)
        blockedAccountsButton.setTitleColor(.white, for: .normal)
        blockedAccountsButton.backgroundColor = .clear
        blockedAccountsButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        
        let mutedAccountsButton = BouncyButton(bouncyButtonImage: nil)
        mutedAccountsButton.setTitle("Muted accounts", for: .normal)
        mutedAccountsButton.setTitleColor(.white, for: .normal)
        mutedAccountsButton.backgroundColor = .clear
        mutedAccountsButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        

           let settingsStackView = UIStackView(arrangedSubviews: [privateToggle, blockedAccountsButton, mutedAccountsButton])
           settingsStackView.axis = .vertical
           settingsStackView.alignment = .fill
           settingsStackView.distribution = .fill
           settingsStackView.spacing = settingsStackViewSpacing

           var settingsScrollView = UIScrollView()
           settingsScrollView.alwaysBounceVertical = true
           settingsScrollView.showsVerticalScrollIndicator = false
           settingsScrollView.automaticallyAdjustsScrollIndicatorInsets = false
           settingsScrollView.delaysContentTouches = false
           settingsScrollView.contentInset = UIEdgeInsets(top: .getPercentageWidth(percentage: 9), left: 0.0, bottom: .getPercentageWidth(percentage: 9), right: 0.0)
           
           settingsScrollView.addSubview(settingsStackView)
           settingsStackView.translatesAutoresizingMaskIntoConstraints = false
           settingsStackView.topAnchor.constraint(equalTo: settingsScrollView.topAnchor).isActive = true
           settingsStackView.bottomAnchor.constraint(equalTo: settingsScrollView.bottomAnchor).isActive = true
           settingsStackView.leadingAnchor.constraint(equalTo: settingsScrollView.leadingAnchor).isActive = true
           settingsStackView.trailingAnchor.constraint(equalTo: settingsScrollView.trailingAnchor).isActive = true
           settingsStackView.widthAnchor.constraint(equalTo: settingsScrollView.widthAnchor).isActive = true
           
           return settingsScrollView
          

           //return settingsStackView

       }()
    
    lazy private var notificationsSettingsScrollView: UIView = {

              let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
           
           let followerToggle = toggleView(text: "Followers", toggleState: false)
           followerToggle.addTarget(target: self, action: #selector(privateToggleSwitched(sender:)), for: .valueChanged)
        
            let rsvpToggle = toggleView(text: "RSVP's", toggleState: false)
            followerToggle.addTarget(target: self, action: #selector(privateToggleSwitched(sender:)), for: .valueChanged)
        
           let notificationsLabel = UILabel()
           notificationsLabel.text = "Receive a notification for:"
           notificationsLabel.textColor = .white
           notificationsLabel.backgroundColor = .clear
           notificationsLabel.font = .dynamicFont(with: "Octarine-Bold", style: .body)

        let settingsStackView = UIStackView(arrangedSubviews: [notificationsLabel, followerToggle, rsvpToggle])
              settingsStackView.axis = .vertical
              settingsStackView.alignment = .fill
              settingsStackView.distribution = .fill
              settingsStackView.spacing = settingsStackViewSpacing

              var settingsScrollView = UIScrollView()
              settingsScrollView.alwaysBounceVertical = true
              settingsScrollView.showsVerticalScrollIndicator = false
              settingsScrollView.automaticallyAdjustsScrollIndicatorInsets = false
              settingsScrollView.delaysContentTouches = false
              settingsScrollView.contentInset = UIEdgeInsets(top: .getPercentageWidth(percentage: 9), left: 0.0, bottom: .getPercentageWidth(percentage: 9), right: 0.0)
              
              settingsScrollView.addSubview(settingsStackView)
              settingsStackView.translatesAutoresizingMaskIntoConstraints = false
              settingsStackView.topAnchor.constraint(equalTo: settingsScrollView.topAnchor).isActive = true
              settingsStackView.bottomAnchor.constraint(equalTo: settingsScrollView.bottomAnchor).isActive = true
              settingsStackView.leadingAnchor.constraint(equalTo: settingsScrollView.leadingAnchor).isActive = true
              settingsStackView.trailingAnchor.constraint(equalTo: settingsScrollView.trailingAnchor).isActive = true
              settingsStackView.widthAnchor.constraint(equalTo: settingsScrollView.widthAnchor).isActive = true
              
              return settingsScrollView
             

              //return settingsStackView

          }()
    
    lazy private var aboutSettingsScrollView: UIView = {

               let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
            
            let termsOfServiceButton = BouncyButton(bouncyButtonImage: nil)
            termsOfServiceButton.setTitle("Terms of service", for: .normal)
            termsOfServiceButton.setTitleColor(.white, for: .normal)
            termsOfServiceButton.backgroundColor = .clear
            termsOfServiceButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)
            
        let privacyPolicyButton = BouncyButton(bouncyButtonImage: nil)
        privacyPolicyButton.setTitle("Privacy policy", for: .normal)
        privacyPolicyButton.setTitleColor(.white, for: .normal)
        privacyPolicyButton.backgroundColor = .clear
        privacyPolicyButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        
        let legalNoticesButton = BouncyButton(bouncyButtonImage: nil)
        legalNoticesButton.setTitle("Legal notices", for: .normal)
        legalNoticesButton.setTitleColor(.white, for: .normal)
        legalNoticesButton.backgroundColor = .clear
        legalNoticesButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .body)

         let settingsStackView = UIStackView(arrangedSubviews: [termsOfServiceButton, privacyPolicyButton, legalNoticesButton])
               settingsStackView.axis = .vertical
               settingsStackView.alignment = .fill
               settingsStackView.distribution = .fill
               settingsStackView.spacing = settingsStackViewSpacing

               var settingsScrollView = UIScrollView()
               settingsScrollView.alwaysBounceVertical = true
               settingsScrollView.showsVerticalScrollIndicator = false
               settingsScrollView.automaticallyAdjustsScrollIndicatorInsets = false
               settingsScrollView.delaysContentTouches = false
               settingsScrollView.contentInset = UIEdgeInsets(top: .getPercentageWidth(percentage: 9), left: 0.0, bottom: .getPercentageWidth(percentage: 9), right: 0.0)
               
               settingsScrollView.addSubview(settingsStackView)
               settingsStackView.translatesAutoresizingMaskIntoConstraints = false
               settingsStackView.topAnchor.constraint(equalTo: settingsScrollView.topAnchor).isActive = true
               settingsStackView.bottomAnchor.constraint(equalTo: settingsScrollView.bottomAnchor).isActive = true
               settingsStackView.leadingAnchor.constraint(equalTo: settingsScrollView.leadingAnchor).isActive = true
               settingsStackView.trailingAnchor.constraint(equalTo: settingsScrollView.trailingAnchor).isActive = true
               settingsStackView.widthAnchor.constraint(equalTo: settingsScrollView.widthAnchor).isActive = true
               
               return settingsScrollView
              

               //return settingsStackView

           }()
    
    @objc func privateToggleSwitched(sender: UISwitch){
        if(sender.isOn){
            print("OOONNNN")
        }
        else{
            print("OOFFFF")
        }
    }
    
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func goToChangePassword(){
        let vc = ChangePasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToDeactivateAccount(){
           let vc = DeactivateAccountViewController()
           navigationController?.pushViewController(vc, animated: true)
       }
    
    init(with number: Int) {
        
        super.init(nibName: nil, bundle: nil)
        
        switch number{
        case 1: settingsLabel.text = "Account"
                setupAccountView()
        case 2: settingsLabel.text = "Privacy"
                setupPrivacyView()
        case 3: settingsLabel.text = "Notifications"
                setupNotificationsView()
        case 4: settingsLabel.text = "About"
                setupAboutView()
        default: navigationController?.popViewController(animated: true)

        }
        
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainDARKPURPLE

        view.addSubview(settingsLabel)
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: settingsInsetY).isActive = true
        settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
      
       view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: settingsInsetX).isActive = true
        backButton.centerYAnchor.constraint(equalTo: settingsLabel.centerYAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
         backButton.widthAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
        
        view.addSubview(menuPopsicleBorderImageView)
        menuPopsicleBorderImageView.translatesAutoresizingMaskIntoConstraints = false
        menuPopsicleBorderImageView.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: -(.getPercentageHeight(percentage: 2))).isActive = true
        menuPopsicleBorderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuPopsicleBorderImageView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 10)).isActive = true
        menuPopsicleBorderImageView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
                
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
    private func setupAccountView(){
        view.addSubview(accountSettingsScrollView)
        accountSettingsScrollView.translatesAutoresizingMaskIntoConstraints = false
        accountSettingsScrollView.topAnchor.constraint(equalTo: menuPopsicleBorderImageView.centerYAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        accountSettingsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        accountSettingsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: containerInsetX).isActive = true
        accountSettingsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -containerInsetX).isActive = true
    }
    
    private func setupPrivacyView(){
        view.addSubview(privacySettingsScrollView)
        privacySettingsScrollView.translatesAutoresizingMaskIntoConstraints = false
        privacySettingsScrollView.topAnchor.constraint(equalTo: menuPopsicleBorderImageView.centerYAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        privacySettingsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        privacySettingsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: containerInsetX).isActive = true
        privacySettingsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -containerInsetX).isActive = true
    }
    
    private func setupNotificationsView(){
        view.addSubview(notificationsSettingsScrollView)
        notificationsSettingsScrollView.translatesAutoresizingMaskIntoConstraints = false
        notificationsSettingsScrollView.topAnchor.constraint(equalTo: menuPopsicleBorderImageView.centerYAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        notificationsSettingsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        notificationsSettingsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: containerInsetX).isActive = true
        notificationsSettingsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -containerInsetX).isActive = true
    }
    
    private func setupAboutView(){
        view.addSubview(aboutSettingsScrollView)
        aboutSettingsScrollView.translatesAutoresizingMaskIntoConstraints = false
        aboutSettingsScrollView.topAnchor.constraint(equalTo: menuPopsicleBorderImageView.centerYAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        aboutSettingsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        aboutSettingsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: containerInsetX).isActive = true
        aboutSettingsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -containerInsetX).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

final class toggleView: UIView {
    
    let toggleViewInsetX: CGFloat = .getPercentageWidth(percentage: 1)
    
    private var text: String?
    private var toggleState: Bool?
    
    lazy private var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.onTintColor = .poppinLIGHTGOLD
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.heightAnchor.constraint(equalToConstant: toggleSwitch.intrinsicContentSize.height).isActive = true
        toggleSwitch.widthAnchor.constraint(equalToConstant: toggleSwitch.intrinsicContentSize.width).isActive = true
        return toggleSwitch
    }()
    
    lazy private var switchLabel: UILabel = {
        let switchLabel = UILabel()
        switchLabel.text = text
        switchLabel.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        switchLabel.textColor = .white
        switchLabel.backgroundColor = .clear
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.heightAnchor.constraint(equalToConstant: switchLabel.intrinsicContentSize.height).isActive = true
        switchLabel.widthAnchor.constraint(equalToConstant: switchLabel.intrinsicContentSize.width).isActive = true
        return switchLabel
    }()
    
    init(text: String?, toggleState: Bool?) {
        
        super.init(frame: .zero)
        
        self.text = text
        self.toggleState = toggleState
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        addSubview(toggleSwitch)
        toggleSwitch.topAnchor.constraint(equalTo: topAnchor).isActive = true
        toggleSwitch.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        toggleSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -toggleViewInsetX).isActive = true
        
        addSubview(switchLabel)
        switchLabel.centerYAnchor.constraint(equalTo: toggleSwitch.centerYAnchor).isActive = true
        switchLabel.trailingAnchor.constraint(equalTo: toggleSwitch.leadingAnchor).isActive = true
        switchLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

    }
    
    func addTarget(target: Any?, action: Selector, for event: UIControl.Event) {
          
          toggleSwitch.addTarget(target, action: action, for: event)
          
      }
}
