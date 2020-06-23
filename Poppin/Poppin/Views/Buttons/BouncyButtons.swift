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
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])

    }
    
    @objc private func animateDown(sender: UIButton) {
        
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95), alpha: 0.9)
        
    }
    
    @objc private func animateUp(sender: UIButton) {
        
        animate(sender, transform: .identity, alpha: 1.0)
        
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform, alpha: CGFloat) {
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        button.alpha = alpha
                        button.transform = transform
                        
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
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
    
        addShadowAndRoundCorners(cornerRadius: min(frame.width, frame.height)/2, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
    }
    
}

final class ImageBubbleButton: BubbleButton {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        imageView?.layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}

final class LoadingButton: BouncyButton {
    
    private var indicatorColor: UIColor = .white
    private var buttonTitle: String = "Button"
    
    lazy private var loadingIndicatorView: UIActivityIndicatorView = {
        
        var loadingIndicatorView = UIActivityIndicatorView()
        loadingIndicatorView.color = indicatorColor
        
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorView.widthAnchor.constraint(equalTo: loadingIndicatorView.heightAnchor).isActive = true
        
        return loadingIndicatorView
        
    }()
    
    init(loadingIndicatorColor: UIColor?) {
        
        super.init(bouncyButtonImage: nil)
        
        if let newLoadingIndicatorColor = loadingIndicatorColor { indicatorColor = newLoadingIndicatorColor}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    func startLoading() {
        
        isUserInteractionEnabled = false
        
        if let title = title(for: .normal), title != "" {
            
            buttonTitle = title
            
        } else {
            
            buttonTitle = "Button"
            
        }
        
        setTitle(nil, for: .normal)
        loadingIndicatorView.startAnimating()
        
        addSubview(loadingIndicatorView)
        loadingIndicatorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        loadingIndicatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    func stopLoading() {
        
        isUserInteractionEnabled = true
        
        loadingIndicatorView.removeFromSuperview()
        loadingIndicatorView.stopAnimating()
        
        setTitle(buttonTitle, for: .normal)
        
    }
    
}
