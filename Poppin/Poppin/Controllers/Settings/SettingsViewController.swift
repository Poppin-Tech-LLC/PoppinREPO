//
//  SettingsViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 7/27/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct Preview: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> UIViewControllerType {
    return UIViewControllerType()
  }
  func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {}
  typealias UIViewControllerType = SettingsViewController
}
struct TestPreview: PreviewProvider {
  static var previews: Previews {
    return Previews()
  }
  typealias Previews = Preview
}

class SettingsViewController: UIViewController {
    let settingsInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    lazy private var settingsScrollView: UIView = {

        let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)

        let settingsStackView = UIStackView(arrangedSubviews: [accountSettings, privacySettings, notificationsSettings, aboutSettings])
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
    
    lazy private var accountSettings: SettingsButtonView = {
           
           var accountSettings = SettingsButtonView(settingsButtonImage: UIImage(systemSymbol: .personFill), settingsButtonText: "Account")
           accountSettings.addTarget(target: self, action: #selector(toAccountSettings(sender:)), for: .touchUpInside)
           return accountSettings
           
       }()
    
    @objc func toAccountSettings(sender: UIButton){
        let vc = SettingsSecondPageViewController(testString: "ACCOUNT")
    }
    
    lazy private var privacySettings: SettingsButtonView = {
           
           var privacySettings = SettingsButtonView(settingsButtonImage: UIImage(systemSymbol: .lockFill), settingsButtonText: "Privacy")
           return privacySettings
           
       }()
    
    lazy private var notificationsSettings: SettingsButtonView = {
        
        var notificationsSettings = SettingsButtonView(settingsButtonImage: UIImage(systemSymbol: .bellFill), settingsButtonText: "Notifications")
        return notificationsSettings
        
    }()
    
    lazy private var aboutSettings: SettingsButtonView = {
        
        var aboutSettings = SettingsButtonView(settingsButtonImage: UIImage(systemSymbol: .infoCircleFill), settingsButtonText: "About")
        return aboutSettings
        
    }()
    
    lazy private var settingsLabel: UILabel = {
       let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        settingsLabel.backgroundColor = .clear
        settingsLabel.textColor = .white
        settingsLabel.textAlignment = .center
        settingsLabel.sizeToFit()
        return settingsLabel
    }()
    
    lazy private var menuPopsicleBorderImageView: UIImageView = {
        
        var menuPopsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.white))
        menuPopsicleBorderImageView.contentMode = .scaleAspectFit
        return menuPopsicleBorderImageView
        
    }()
    
    lazy private var backButton: ImageBubbleButton = {
        let backButton = ImageBubbleButton(bouncyButtonImage: UIImage(systemSymbol: .arrowLeft).withTintColor(.white))
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
    @objc func goBack(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainDARKPURPLE

//        view.addSubview(settingsContainerView)
//        settingsContainerView.translatesAutoresizingMaskIntoConstraints = false
//        settingsContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        settingsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        settingsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        settingsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
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
        
        view.addSubview(settingsScrollView)
        settingsScrollView.translatesAutoresizingMaskIntoConstraints = false
        settingsScrollView.topAnchor.constraint(equalTo: menuPopsicleBorderImageView.centerYAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        settingsScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        settingsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: settingsInsetX).isActive = true
        settingsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -settingsInsetX).isActive = true

        
        
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


final class SettingsButtonView: UIView {
    
    let settingsButtonInsetY: CGFloat = .getPercentageWidth(percentage: 1)
    let settingsButtonInsetX: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var settingsButtonText: String?
    private var settingsButtonImage: UIImage?
    
    lazy private var settingsButton: UIButton = {
        
        var settingsButton = UIButton()
        settingsButton.backgroundColor = .clear
        settingsButton.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        settingsButton.addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        return settingsButton
        
    }()
    
    lazy private var settingsButtonImageView: UIImageView = {
        
        var settingsButtonImageView = UIImageView(image: settingsButtonImage?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal))
        settingsButtonImageView.contentMode = .scaleAspectFill
        
        settingsButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        settingsButtonImageView.heightAnchor.constraint(equalToConstant: settingsButtonLabel.intrinsicContentSize.height+settingsButtonInsetY).isActive = true
        settingsButtonImageView.widthAnchor.constraint(equalTo: settingsButtonImageView.heightAnchor).isActive = true
        
        return settingsButtonImageView
        
    }()
    
    lazy private var settingsButtonLabel: UILabel = {
        
        var settingsButtonLabel = UILabel()
        settingsButtonLabel.text = settingsButtonText
        settingsButtonLabel.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        settingsButtonLabel.textColor = .white
        settingsButtonLabel.textAlignment = .left
        
        settingsButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsButtonLabel.heightAnchor.constraint(equalToConstant: settingsButtonLabel.intrinsicContentSize.height).isActive = true
        settingsButtonLabel.widthAnchor.constraint(equalToConstant: settingsButtonLabel.intrinsicContentSize.width).isActive = true
        
        return settingsButtonLabel
        
    }()
    
    init(settingsButtonImage: UIImage?, settingsButtonText: String?) {
        
        super.init(frame: .zero)
        
        self.settingsButtonImage = settingsButtonImage
        self.settingsButtonText = settingsButtonText
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = .mainDARKPURPLE
        
        addSubview(settingsButtonImageView)
        settingsButtonImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        settingsButtonImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        settingsButtonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: settingsButtonInsetX).isActive = true
        
        addSubview(settingsButtonLabel)
        settingsButtonLabel.centerYAnchor.constraint(equalTo: settingsButtonImageView.centerYAnchor).isActive = true
        settingsButtonLabel.leadingAnchor.constraint(equalTo: settingsButtonImageView.trailingAnchor, constant: settingsButtonInsetX).isActive = true
        settingsButtonLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -settingsButtonInsetX).isActive = true
        
        addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    @objc private func animateDown(sender: UIButton) {
        
        animate(transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95), alpha: 0.9)
        
    }
    
    @objc private func animateUp(sender: UIButton) {
        
        animate(transform: .identity, alpha: 1.0)
        
    }
    
    private func animate(transform: CGAffineTransform, alpha: CGFloat) {
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.alpha = alpha
                        self.transform = transform
                        
            }, completion: nil)
        
    }
    
    func addTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        
        settingsButton.addTarget(target, action: action, for: event)
        
    }
}
