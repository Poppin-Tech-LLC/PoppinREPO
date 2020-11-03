//
//  BouncyButtons.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/26/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

class BouncyButton: UIButton {
    
    public static let bouncyButtonEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    private var bouncyButtonImage: UIImage?
    
    var nonHighlightedColor: UIColor?
    var highlightedColor: UIColor?
    var shouldBounce: Bool = true
    
    init(bouncyButtonImage: UIImage?) {
        
        super.init(frame: .zero)
        
        self.bouncyButtonImage = bouncyButtonImage
        setupButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupButton()
        
    }
    
    private func setupButton() {
        
        setImage(bouncyButtonImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        imageView?.contentMode = .scaleAspectFit
        addTarget(self, action: #selector(animateDown(sender:)), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp(sender:)), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])

    }
    
    @objc private func animateDown(sender: BouncyButton) {
        
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.90, y: 0.90), alpha: 0.9, down: true)
        
    }
    
    @objc private func animateUp(sender: BouncyButton) {
        
        animate(sender, transform: .identity, alpha: 1.0, down: false)
        
    }
    
    private func animate(_ button: BouncyButton, transform: CGAffineTransform, alpha: CGFloat, down: Bool) {
        
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        if button.shouldBounce { button.transform = transform }
                        
                        button.alpha = alpha
                        
            }, completion: nil)
        
    }
    
    func changeBouncyButtonImage(image: UIImage?) {
        
        if let newImage = image {
            
            self.bouncyButtonImage = newImage
            setImage(bouncyButtonImage, for: .normal)
            
        }
        
    }
    
}

class BubbleButton: BouncyButton {
    
    override init(bouncyButtonImage: UIImage?) {
        
        super.init(bouncyButtonImage: bouncyButtonImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        addShadowAndRoundCorners(cornerRadius: min(frame.width, frame.height)/2, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
    }
    
}

final class ImageBubbleButton: BubbleButton {
    
    override init(bouncyButtonImage: UIImage?) {
        
        super.init(bouncyButtonImage: bouncyButtonImage)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        imageView?.layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}

final class LoadingButton: OctarineButton {
    
    lazy private var loadingView: UIActivityIndicatorView = {
        
        var loadingView = UIActivityIndicatorView()
        loadingView.isUserInteractionEnabled = false
        loadingView.color = self.backgroundColor
        return loadingView
        
    }()
    
    func startLoading() {
        
        isUserInteractionEnabled = false
        loadingView.color = titleColor(for: .normal)
        setTitleColor(backgroundColor, for: .normal)
        loadingView.startAnimating()
        addSubview(loadingView)
        loadingView.anchor(centerX: centerXAnchor, centerY: centerYAnchor)
        
    }
    
    func stopLoading() {
        
        isUserInteractionEnabled = true
        loadingView.removeFromSuperview()
        loadingView.stopAnimating()
        setTitleColor(loadingView.color, for: .normal)
        loadingView.color = backgroundColor
        
    }
    
}

final class SectionButton: BouncyButton {
    
    var section = 0
    var didFetchSection = false
    
    init(bouncyButtonImage: UIImage?, section: Int?) {
        
        super.init(bouncyButtonImage: bouncyButtonImage)
        
        if let section = section { self.section = section }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
}

class ToggleButton: OctarineButton {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        self.clipsToBounds = true
        self.layer.cornerRadius = min(bounds.width, bounds.height)/2
        
    }
    
}
