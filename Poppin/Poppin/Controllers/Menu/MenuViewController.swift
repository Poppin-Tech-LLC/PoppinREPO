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
    let menuInsetX: CGFloat = .getPercentageWidth(percentage: 3)
    let menuInnerInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    private var fullName: String = "Manuel A Martin Callejo"
    private var username: String = "@manolito_martin"
    private var following: String = "525"
    private var followers: String = "540"
    
    lazy private var menuTopStackView: UIStackView = {
        
        let menuProfileButtonSpacing: CGFloat = .getPercentageWidth(percentage: 4)
        let menuUsernameSpacing: CGFloat = .getPercentageWidth(percentage: 2.5)
        let menuPopsicleBorderSpacing: CGFloat = .getPercentageWidth(percentage: 2)
        let menuFollowingFollowersSpacing: CGFloat = .getPercentageWidth(percentage: 1)
        
        let menuFollowingFollowersStackView = UIStackView(arrangedSubviews: [menuFollowingButton, menuFollowersButton])
        menuFollowingFollowersStackView.axis = .horizontal
        menuFollowingFollowersStackView.alignment = .fill
        menuFollowingFollowersStackView.distribution = .fill
        menuFollowingFollowersStackView.spacing = menuFollowingFollowersSpacing
        
        let menuPopsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.white))
        menuPopsicleBorderImageView.contentMode = .scaleAspectFit
        
        menuPopsicleBorderImageView.translatesAutoresizingMaskIntoConstraints = false
        menuPopsicleBorderImageView.heightAnchor.constraint(equalToConstant: menuFullNameLabel.intrinsicContentSize.height + .getPercentageWidth(percentage: 1)).isActive = true
        
        var menuTopStackView = UIStackView(arrangedSubviews: [menuProfileButton, menuFullNameLabel, menuUsernameLabel, menuFollowingFollowersStackView, menuPopsicleBorderImageView, menu24hScheduleButtonView])
        menuTopStackView.axis = .vertical
        menuTopStackView.alignment = .center
        menuTopStackView.distribution = .fill
        menuTopStackView.spacing = menuInnerInset
        menuTopStackView.setCustomSpacing(menuProfileButtonSpacing, after: menuProfileButton)
        menuTopStackView.setCustomSpacing(menuUsernameSpacing, after: menuFullNameLabel)
        menuTopStackView.setCustomSpacing(menuPopsicleBorderSpacing, after: menuFollowingFollowersStackView)
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
        
        return menuFullNameLabel
        
    }()
    
    lazy private var menuUsernameLabel: UILabel = {
        
        var menuUsernameLabel = UILabel()
        menuUsernameLabel.numberOfLines = 0
        menuUsernameLabel.sizeToFit()
        menuUsernameLabel.font = .dynamicFont(with: "Octarine-Light", style: .footnote)
        menuUsernameLabel.textColor = .white
        menuUsernameLabel.text = username
        menuUsernameLabel.textAlignment = .center
        
        menuUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        menuUsernameLabel.heightAnchor.constraint(equalToConstant: menuUsernameLabel.intrinsicContentSize.height).isActive = true
        
        return menuUsernameLabel
        
    }()
    
    lazy private var menuFollowingButton: BouncyButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        let buttonText = NSMutableAttributedString(string: following + " Following", attributes: [.foregroundColor : UIColor.white])
        let lightRange = buttonText.mutableString.range(of: "Following")
        let boldRange = buttonText.mutableString.range(of: following)
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), range: lightRange)
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), range: boldRange)
        
        let menuFollowingButton = BouncyButton(bouncyButtonImage: nil)
        menuFollowingButton.backgroundColor = .mainDARKPURPLE
        menuFollowingButton.setAttributedTitle(buttonText, for: .normal)
        menuFollowingButton.titleLabel?.textAlignment = .center
        
        menuFollowingButton.translatesAutoresizingMaskIntoConstraints = false
        menuFollowingButton.heightAnchor.constraint(equalToConstant: menuFollowingButton.intrinsicContentSize.height+edgeInset).isActive = true
        menuFollowingButton.widthAnchor.constraint(equalToConstant: menuFollowingButton.intrinsicContentSize.width+edgeInset).isActive = true
        
        return menuFollowingButton
        
    }()
    
    lazy private var menuFollowersButton: BouncyButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        let buttonText = NSMutableAttributedString(string: followers + " Followers", attributes: [.foregroundColor : UIColor.white])
        let lightRange = buttonText.mutableString.range(of: "Followers")
        let boldRange = buttonText.mutableString.range(of: followers)
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), range: lightRange)
        buttonText.addAttribute(.font, value: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote), range: boldRange)
        
        let menuFollowersButton = BouncyButton(bouncyButtonImage: nil)
        menuFollowersButton.backgroundColor = .mainDARKPURPLE
        menuFollowersButton.setAttributedTitle(buttonText, for: .normal)
        menuFollowersButton.titleLabel?.textAlignment = .center
        
        menuFollowersButton.translatesAutoresizingMaskIntoConstraints = false
        menuFollowersButton.heightAnchor.constraint(equalToConstant: menuFollowersButton.intrinsicContentSize.height+edgeInset).isActive = true
        menuFollowersButton.widthAnchor.constraint(equalToConstant: menuFollowersButton.intrinsicContentSize.width+edgeInset).isActive = true
        
        return menuFollowersButton
        
    }()
    
    lazy private var menu24hScheduleButtonView: MenuButtonView = {
        
        var menu24hScheduleButtonView = MenuButtonView(menuButtonImage: UIImage(systemSymbol: .clockFill), menuButtonText: "24h Schedule")
        return menu24hScheduleButtonView
        
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
        menuBorderView.widthAnchor.constraint(equalToConstant: 2.0).isActive = true
        
        view.addSubview(menuTopStackView)
        menuTopStackView.translatesAutoresizingMaskIntoConstraints = false
        menuTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: menuInsetY).isActive = true
        menuTopStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: menuInsetX).isActive = true
        menuTopStackView.trailingAnchor.constraint(equalTo: menuBorderView.leadingAnchor, constant: -menuInsetX).isActive = true
        
    }
    
}

final class MenuButtonView: UIView {
    
    let menuButtonInsetY: CGFloat = .getPercentageWidth(percentage: 2)
    let menuButtonInsetX: CGFloat = .getPercentageWidth(percentage: 1)
    
    private var menuButtonText: String?
    private var menuButtonImage: UIImage?
    
    lazy private var menuButton: UIButton = {
        
        var menuButton = UIButton()
        menuButton.backgroundColor = .clear
        menuButton.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        menuButton.addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        return menuButton
        
    }()
    
    lazy private var menuButtonImageView: UIImageView = {
        
        var menuButtonImageView = UIImageView(image: menuButtonImage?.withRenderingMode(.alwaysTemplate))
        menuButtonImageView.tintColor = .white
        menuButtonImageView.contentMode = .scaleAspectFill
        
        menuButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        menuButtonImageView.heightAnchor.constraint(equalToConstant: menuButtonLabel.intrinsicContentSize.height+menuButtonInsetY).isActive = true
        menuButtonImageView.widthAnchor.constraint(equalTo: menuButtonImageView.heightAnchor).isActive = true
        
        return menuButtonImageView
        
    }()
    
    lazy private var menuButtonLabel: UILabel = {
        
        var menuButtonLabel = UILabel()
        menuButtonLabel.text = menuButtonText
        menuButtonLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        menuButtonLabel.textColor = .white
        menuButtonLabel.textAlignment = .left
        
        menuButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        menuButtonLabel.heightAnchor.constraint(equalToConstant: menuButtonLabel.intrinsicContentSize.height).isActive = true
        menuButtonLabel.widthAnchor.constraint(equalToConstant: menuButtonLabel.intrinsicContentSize.width).isActive = true
        
        return menuButtonLabel
        
    }()
    
    init(menuButtonImage: UIImage?, menuButtonText: String?) {
        
        super.init(frame: .zero)
        
        self.menuButtonImage = menuButtonImage
        self.menuButtonText = menuButtonText
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = .mainDARKPURPLE
        
        addSubview(menuButtonImageView)
        menuButtonImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuButtonImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        menuButtonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: menuButtonInsetX).isActive = true
        
        addSubview(menuButtonLabel)
        menuButtonLabel.centerYAnchor.constraint(equalTo: menuButtonImageView.centerYAnchor, constant: 1.5).isActive = true
        menuButtonLabel.leadingAnchor.constraint(equalTo: menuButtonImageView.trailingAnchor, constant: menuButtonInsetX*2).isActive = true
        menuButtonLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -menuButtonInsetX).isActive = true
        
        /*addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        menuButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        menuButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        menuButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true*/
        
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
    
}
