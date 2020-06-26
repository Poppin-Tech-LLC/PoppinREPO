//
//  MenuViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/25/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    let menuInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let menuInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let menuInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var fullName: String = "Full Name"
    private var username: String = "@username"
    private var following: Int = 0
    private var followers: Int = 0
    
    lazy private var menuTopStackView: UIStackView = {
        
        var menuTopStackView = UIStackView(arrangedSubviews: [menuProfileButton, menuFullNameLabel, menuUsernameLabel, menuFollowingFollowersStackView])
        menuTopStackView.axis = .vertical
        menuTopStackView.alignment = .center
        menuTopStackView.distribution = .fill
        menuTopStackView.spacing = menuInnerInset
        return menuTopStackView
        
    }()
    
    lazy private var menuProfileButton: ImageBubbleButton = {
        
        var menuProfileButton = ImageBubbleButton(bouncyButtonImage: UIImage.defaultUserPicture256)
        
        menuProfileButton.translatesAutoresizingMaskIntoConstraints = false
        menuProfileButton.heightAnchor.constraint(equalToConstant: menuFullNameLabel.intrinsicContentSize.height*4.0).isActive = true
        menuProfileButton.widthAnchor.constraint(equalTo: menuProfileButton.heightAnchor).isActive = true
        
        return menuProfileButton
        
    }()
    
    lazy private var menuFullNameLabel: UILabel = {
        
        var menuFullNameLabel = UILabel()
        menuFullNameLabel.numberOfLines = 0
        menuFullNameLabel.sizeToFit()
        menuFullNameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        menuFullNameLabel.textColor = .white
        menuFullNameLabel.text = fullName
        menuFullNameLabel.textAlignment = .center
        
        menuFullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        menuFullNameLabel.heightAnchor.constraint(equalToConstant: menuFullNameLabel.intrinsicContentSize.height).isActive = true
        
        return menuFullNameLabel
        
    }()
    
    lazy private var menuUsernameLabel: UILabel = {
        
        var menuUsernameLabel = UILabel()
        menuUsernameLabel.numberOfLines = 0
        menuUsernameLabel.sizeToFit()
        menuUsernameLabel.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        menuUsernameLabel.textColor = .white
        menuUsernameLabel.text = username
        menuUsernameLabel.textAlignment = .center
        
        menuUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        menuUsernameLabel.heightAnchor.constraint(equalToConstant: menuUsernameLabel.intrinsicContentSize.height).isActive = true
        
        return menuUsernameLabel
        
    }()
    
    lazy private var menuFollowingFollowersStackView: UIStackView = {
        
        var menuFollowingFollowersStackView = UIStackView(arrangedSubviews: [menuFollowingButton, menuFollowersButton])
        menuFollowingFollowersStackView.axis = .horizontal
        menuFollowingFollowersStackView.alignment = .fill
        menuFollowingFollowersStackView.distribution = .fill
        menuFollowingFollowersStackView.spacing = menuInnerInset
        return menuFollowingFollowersStackView
        
    }()
    
    lazy private var menuFollowingButton: BouncyButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        let buttonText = NSMutableAttributedString(string: String(following) + " Following", attributes: [.foregroundColor : UIColor.white])
        let lightRange = buttonText.mutableString.range(of: "Following")
        let boldRange = buttonText.mutableString.range(of: String(following))
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), range: lightRange)
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline), range: boldRange)
        
        let menuFollowingButton = BouncyButton(bouncyButtonImage: nil)
        menuFollowingButton.backgroundColor = .mainDARKPURPLE
        menuFollowingButton.setAttributedTitle(buttonText, for: .normal)
        menuFollowingButton.titleLabel?.textAlignment = .center
        
        menuFollowingButton.translatesAutoresizingMaskIntoConstraints = false
        menuFollowingButton.heightAnchor.constraint(equalToConstant: menuFollowingButton.intrinsicContentSize.height+edgeInset).isActive = true
        
        return menuFollowingButton
        
    }()
    
    lazy private var menuFollowersButton: BouncyButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        let buttonText = NSMutableAttributedString(string: String(followers) + " Followers", attributes: [.foregroundColor : UIColor.white])
        let lightRange = buttonText.mutableString.range(of: "Followers")
        let boldRange = buttonText.mutableString.range(of: String(followers))
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), range: lightRange)
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline), range: boldRange)
        
        let menuFollowersButton = BouncyButton(bouncyButtonImage: nil)
        menuFollowersButton.backgroundColor = .mainDARKPURPLE
        menuFollowersButton.setAttributedTitle(buttonText, for: .normal)
        menuFollowersButton.titleLabel?.textAlignment = .center
        
        menuFollowersButton.translatesAutoresizingMaskIntoConstraints = false
        menuFollowersButton.heightAnchor.constraint(equalToConstant: menuFollowersButton.intrinsicContentSize.height+edgeInset).isActive = true
        
        return menuFollowersButton
        
    }()
    
    lazy private var menuBorderView: UIView = {
        
        var menuBorderView = UIView()
        menuBorderView.backgroundColor = .white
        return menuBorderView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .mainDARKPURPLE
        
        view.addSubview(menuBorderView)
        menuBorderView.translatesAutoresizingMaskIntoConstraints = false
        menuBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuBorderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBorderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuBorderView.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        view.addSubview(menuTopStackView)
        menuTopStackView.translatesAutoresizingMaskIntoConstraints = false
        menuTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: menuInsetY).isActive = true
        menuTopStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: menuInsetX).isActive = true
        menuTopStackView.trailingAnchor.constraint(equalTo: menuBorderView.leadingAnchor, constant: -menuInsetX).isActive = true
        
    }
    
}
