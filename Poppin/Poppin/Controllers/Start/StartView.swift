//
//  StartView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/18/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// Start Page UI.
final class StartView: UIView {
    
    // Link to app terms.
    private let termsLink = "Terms"
    
    // Link to privacy policy.
    private let privacyPolicyLink = "Privacy"
    
    // Poppin gold background.
    lazy private var backgroundView = UIImageView(image: UIImage.appBackground.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 100), height: .height(percent: 100))))
    
    // Content margins.
    lazy private var contentLayoutGuide = UILayoutGuide()
    
    // App title.
    lazy private var poppinTitle = OctarineLabel(text: "poppin", color: .white, bold: true, size: .width(percent: 7.0), alignment: .center, lineLimit: 1)
    
    // App title top constraint for animation.
    lazy private var poppinTitleTopConstraint = NSLayoutConstraint(item: poppinTitle, attribute: .top, relatedBy: .equal, toItem: contentLayoutGuide, attribute: .top, multiplier: 1.0, constant: .width(percent: 6.0))
    
    // App title bottom constraint for animation.
    lazy private var poppinTitleBottomConstraint = NSLayoutConstraint(item: poppinTitle, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
    
    // App logo.
    lazy private var poppinLogo = UIImageView(image: UIImage.poppinEventPopsicleIcon256.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 33), height: .width(percent: 33))))
    
    // Bottom content stack.
    lazy private var bottomStack = StackView(subviews: [signUpButton, loginButton, disclaimerTextView], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 4.0), padding: NSDirectionalEdgeInsets(top: 0.0, leading: .width(percent: 4.5), bottom: 0.0, trailing: .width(percent: 4.5)))
    
    // Bottom content stack top constraint for animation.
    lazy private var bottomStackTopConstraint = NSLayoutConstraint(item: bottomStack, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    
    // Bottom content stack bottom constraint for animation.
    lazy private var bottomStackBottomConstraint = NSLayoutConstraint(item: bottomStack, attribute: .bottom, relatedBy: .equal, toItem: contentLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -.width(percent: 6.0))
    
    /// Button that transitions to the sign up page.
    lazy private(set) var signUpButton = OctarineButton(bgColor: .mainDARKPURPLE, label: OctarineLabel(text: "Sign Up", color: .white, bold: true, style: .title3, size: nil, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 3.0), left: 0.0, bottom: .width(percent: 3.0), right: 0.0), cornerRadius: .width(percent: 3.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
    
    /// Button that transitions to the log in page.
    lazy private(set) var loginButton = OctarineButton(bgColor: .white, label: OctarineLabel(text: "Log In", color: .mainDARKPURPLE, bold: true, style: .title3, size: nil, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 3.0), left: 0.0, bottom: .width(percent: 3.0), right: 0.0), cornerRadius: .width(percent: 3.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
    
    /// Disclaimer message with links to the app terms and privacy policy.
    lazy private(set) var disclaimerTextView: UITextView = {
        
        let disclaimerText = NSMutableAttributedString(string: "By clicking Sign Up or Log In, you agree to our Terms and Privacy Policy", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)])
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
        disclaimerTextView.textAlignment = .center
        return disclaimerTextView
        
    }()
    
    /**
    Overrides superclass initializer to configure the UI.

    - Parameter frame: Ignored by AutoLayout (default it to .zero)
    */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configureView()
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder from storyboard.
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configures UI.
    private func configureView() {
        
        // 1. Add layout guides to the root view.
        _ = [contentLayoutGuide].map { self.addLayoutGuide($0) }
        
        // 2. Add subviews to the root view (each one on top of the others).
        _ = [backgroundView, poppinTitle, poppinLogo, bottomStack].map { self.addSubview($0) }
        
        // 3. Apply constraints.
        backgroundView.attatchEdgesToSuperview()
        
        contentLayoutGuide.attatchEdgesTo(superview: self, safeArea: true, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 3.0), right: .width(percent: 4.0)))
        
        poppinTitle.anchor(leading: contentLayoutGuide.leadingAnchor, trailing: contentLayoutGuide.trailingAnchor)
        poppinTitleTopConstraint.isActive = true
        poppinTitleBottomConstraint.isActive = false
        
        poppinLogo.anchor(bottom: contentLayoutGuide.centerYAnchor, centerX: contentLayoutGuide.centerXAnchor)
        
        bottomStack.anchor(leading: contentLayoutGuide.leadingAnchor, trailing: contentLayoutGuide.trailingAnchor)
        bottomStackBottomConstraint.isActive = true
        bottomStackTopConstraint.isActive = false
        
    }
    
    /**
    Hides the app title, buttons, and disclaimer view with an animation or without one.

    - Parameter animated: Determines whether to hide the elements with an animation or not.
    */
    func animateOut(animated: Bool) {
        
        poppinTitleTopConstraint.isActive = false
        poppinTitleBottomConstraint.isActive = true
        
        bottomStackBottomConstraint.isActive = false
        bottomStackTopConstraint.isActive = true
        
        if animated {
            
            UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.layoutIfNeeded()
                        
            }, completion: nil)
            
        }
        
    }
    
    /**
    Shows the app title, buttons, and disclaimer view with an animation or without one.

    - Parameter animated: Determines whether to show the elements with an animation or not.
    */
    func animateIn(animated: Bool) {
        
        poppinTitleTopConstraint.isActive = true
        poppinTitleBottomConstraint.isActive = false
        
        bottomStackBottomConstraint.isActive = true
        bottomStackTopConstraint.isActive = false
        
        if animated {
            
            UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.layoutIfNeeded()
                        
            }, completion: nil)
            
        }
        
    }
    
}

struct StartViewPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = StartView
    
}

struct StartViewPreview_Test: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = StartViewPreview
    
}


class OctarineLabel: UILabel {
    
    var fontTraits: (Bool, UIFont.TextStyle) = (true, .headline) {
        
        didSet {
            
            if fontSize == nil {
            
                if fontTraits.0 { self.font = .dynamicFont(with: "Octarine-Bold", style: fontTraits.1) }
                else { self.font = .dynamicFont(with: "Octarine-Light", style: fontTraits.1) }
                
            }
            
        }
        
    }
    
    var fontSize: CGFloat? {
        
        didSet {
            
            if fontTraits.0 {
                
                if let size = self.fontSize {
                    
                    self.font = UIFont(name: "Octarine-Bold", size: size)
                    
                }
                
            } else {
                
                if let size = self.fontSize {
                    
                    self.font = UIFont(name: "Octarine-Light", size: size)
                    
                }
                
            }
            
        }
        
    }
    
    convenience init() {
        
        self.init(text: nil, size: nil)
        
    }
    
    init(text: String?, color: UIColor = .white, bold: Bool = true, style: UIFont.TextStyle = .headline, size: CGFloat?, alignment: NSTextAlignment = .left, lineLimit: Int = 1) {
        
        super.init(frame: .zero)
        
        self.fontTraits.0 = bold
        self.fontTraits.1 = style
        self.textColor = color
        self.textAlignment = alignment
        self.fontSize = size
        
        if fontTraits.0 {
            
            if let size = self.fontSize {
                
                self.font = UIFont(name: "Octarine-Bold", size: size)
                
            } else {
                
                self.font = .dynamicFont(with: "Octarine-Bold", style: fontTraits.1)
                
            }
            
        } else {
            
            if let size = self.fontSize {
                
                self.font = UIFont(name: "Octarine-Light", size: size)
                
            } else {
                
                self.font = .dynamicFont(with: "Octarine-Light", style: fontTraits.1)
                
            }
            
        }
        
        self.text = text
        self.lineBreakMode = .byTruncatingTail
        self.numberOfLines = lineLimit
        self.adjustsFontForContentSizeCategory = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class OctarineButton: BouncyButton {
    
    var isDisabled: Bool = false {
        
        didSet {
            
            if isDisabled {
                
                isUserInteractionEnabled = false
                alpha = 0.6
                
            } else {
                
                isUserInteractionEnabled = true
                alpha = 1.0
                
            }
            
        }
        
    }
    
    var padding: UIEdgeInsets = .zero {
        
        didSet {
            
            self.contentEdgeInsets = UIEdgeInsets(top: padding.top, left: padding.left, bottom: padding.bottom, right: padding.right)
            
        }
        
    }
    
    convenience init() {
        
        self.init(bgColor: nil, label: nil)
        
    }
    
    init(bgColor: UIColor?, label: OctarineLabel?, padding: UIEdgeInsets = .zero, cornerRadius: CGFloat = 0.0, shadow: Shadow = Shadow(color: .clear, radius: 0.0, x: 0.0, y: 0.0)) {
        
        super.init(bouncyButtonImage: nil)
        
        self.backgroundColor = bgColor
        self.setTitle(label?.text, for: .normal)
        self.setTitleColor(label?.textColor, for: .normal)
        
        if let bold = label?.fontTraits.0, let style = label?.fontTraits.1 {
            
            if bold { self.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: style) }
            else { self.titleLabel?.font = .dynamicFont(with: "Octarine-Light", style: style) }
            
        } else {
            
            self.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
            
        }
        
        if let alignment = label?.textAlignment { self.titleLabel?.textAlignment = alignment }
        else { self.titleLabel?.textAlignment = .center }
        
        self.padding = padding
        self.contentEdgeInsets = padding
        self.layer.cornerRadius = cornerRadius
        self.apply(shadow: shadow)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct Shadow {
    
    var color: UIColor
    var radius: CGFloat
    var x: CGFloat
    var y: CGFloat
    
}

class StackView: UIStackView {
    
    convenience init() {
        
        self.init()
        
    }
    
    init(subviews: [UIView] = [], axis: NSLayoutConstraint.Axis = .vertical, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0.0, padding: NSDirectionalEdgeInsets = .zero) {
        
        super.init(frame: .zero)
        
        for subview in subviews {
            
            self.addArrangedSubview(subview)
            
        }
        
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = padding
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
