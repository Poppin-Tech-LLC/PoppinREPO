//
//  PopsicleGroupAnnotationView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/29/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import MapKit

final class PopsicleGroupAnnotationView: MKAnnotationView {
    
    public static let defaultPopsicleGroupAnnotationViewReuseIdentifier = "PopsicleGroupAnnotationView"
    
    private let popsicleHeight: CGFloat = .getPercentageWidth(percentage: 12.5)
    private let popsicleWidth: CGFloat = .getPercentageWidth(percentage: 7.5)
    
    private let innerInsetX: CGFloat = .getPercentageWidth(percentage: 3)
    private let innerInsetY: CGFloat = .getPercentageWidth(percentage: 2.5)
    
    private(set) var popsicleGroupCount: Int = 0
    
    lazy private var bubbleViewWidthConstraint: NSLayoutConstraint = {
        
        var bubbleViewWidthConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)
        return bubbleViewWidthConstraint
        
    }()
    
    lazy private var bubbleViewHeightConstraint: NSLayoutConstraint = {
        
        var bubbleViewHeightConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .height, relatedBy: .equal, toItem: popsicleGroupCountBubbleView, attribute: .width, multiplier: 1.0, constant: 0.0)
        return bubbleViewHeightConstraint
        
    }()
    
    lazy private var popsicleGroupContainerView: UIView = {
        
        var popsicleGroupContainerView = UIView()
        popsicleGroupContainerView.backgroundColor = .clear
        
        popsicleGroupContainerView.addSubview(popsicleGroupIconImageView)
        popsicleGroupIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupIconImageView.centerYAnchor.constraint(equalTo: popsicleGroupContainerView.centerYAnchor).isActive = true
        popsicleGroupIconImageView.leadingAnchor.constraint(equalTo: popsicleGroupContainerView.leadingAnchor).isActive = true
        popsicleGroupIconImageView.heightAnchor.constraint(equalToConstant: popsicleHeight).isActive = true
        popsicleGroupIconImageView.widthAnchor.constraint(equalToConstant: popsicleWidth).isActive = true
        
        popsicleGroupContainerView.addSubview(popsicleGroupCountBubbleView)
        popsicleGroupCountBubbleView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupCountBubbleView.topAnchor.constraint(equalTo: popsicleGroupIconImageView.topAnchor).isActive = true
        popsicleGroupCountBubbleView.centerXAnchor.constraint(equalTo: popsicleGroupIconImageView.trailingAnchor).isActive = true
        bubbleViewWidthConstraint.isActive = true
        bubbleViewHeightConstraint.isActive = true
        
        popsicleGroupContainerView.addSubview(popsicleGroupIconShadowImageView)
        popsicleGroupContainerView.sendSubviewToBack(popsicleGroupIconShadowImageView)
        popsicleGroupIconShadowImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupIconShadowImageView.centerYAnchor.constraint(equalTo: popsicleGroupIconImageView.bottomAnchor, constant: -1.5).isActive = true
        popsicleGroupIconShadowImageView.centerXAnchor.constraint(equalTo: popsicleGroupIconImageView.centerXAnchor).isActive = true
        popsicleGroupIconShadowImageView.widthAnchor.constraint(equalTo: popsicleGroupIconImageView.widthAnchor, multiplier: 0.87).isActive = true
        popsicleGroupIconShadowImageView.heightAnchor.constraint(equalTo: popsicleGroupIconImageView.heightAnchor, multiplier: 0.27).isActive = true
        
        return popsicleGroupContainerView
        
    }()
    
    lazy private var popsicleGroupIconImageView: UIImageView = {
        
        var popsicleGroupIconImageView = UIImageView()
        popsicleGroupIconImageView.image = .popsicleGroupIcon256
        popsicleGroupIconImageView.contentMode = .scaleAspectFit
        return popsicleGroupIconImageView
        
    }()
    
    lazy private var popsicleGroupCountBubbleView: BubbleView = {
        
        var popsicleGroupCountBubbleView = BubbleView()
        popsicleGroupCountBubbleView.backgroundColor = .mainDARKPURPLE
        popsicleGroupCountBubbleView.clipsToBounds = true
        
        popsicleGroupCountBubbleView.addSubview(popsicleGroupCountLabel)
        popsicleGroupCountLabel.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupCountLabel.centerYAnchor.constraint(equalTo: popsicleGroupCountBubbleView.centerYAnchor).isActive = true
        popsicleGroupCountLabel.centerXAnchor.constraint(equalTo: popsicleGroupCountBubbleView.centerXAnchor).isActive = true
        
        return popsicleGroupCountBubbleView
        
    }()
    
    lazy private var popsicleGroupCountLabel: UILabel = {
        
        var popsicleGroupCountLabel = UILabel()
        popsicleGroupCountLabel.textAlignment = .center
        popsicleGroupCountLabel.text = "0"
        popsicleGroupCountLabel.numberOfLines = 1
        popsicleGroupCountLabel.textColor = .white
        popsicleGroupCountLabel.backgroundColor = .mainDARKPURPLE
        popsicleGroupCountLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption2)
        return popsicleGroupCountLabel
        
    }()
    
    lazy private var popsicleGroupIconShadowImageView: UIImageView = {
        
        var popsicleGroupIconShadowImageView = UIImageView()
        popsicleGroupIconShadowImageView.image = .defaultPopsicleIconShadow256
        popsicleGroupIconShadowImageView.alpha = 0.6
        popsicleGroupIconShadowImageView.contentMode = .scaleToFill
        return popsicleGroupIconShadowImageView
        
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        frame = CGRect(x: 0.0, y: 0.0, width: popsicleWidth + ((popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)/2), height: popsicleHeight)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        addSubview(popsicleGroupContainerView)
        popsicleGroupContainerView.frame = bounds
        
    }
    
    func setGroupCount(count: Int) {
        
        canShowCallout = false
        displayPriority = .required
        collisionMode = .rectangle
        
        if count < 0 {
            
            popsicleGroupCount = 0
            popsicleGroupCountLabel.text = "0"
            
        } else if count > 99 {
            
            popsicleGroupCount = count
            popsicleGroupCountLabel.text = "99+"
            
        } else {
            
            popsicleGroupCount = count
            popsicleGroupCountLabel.text = String(count)
            
        }
        
        bubbleViewWidthConstraint.isActive = false
        bubbleViewWidthConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)
        bubbleViewWidthConstraint.isActive = true
        
        if popsicleGroupCount >= 0 && popsicleGroupCount < 10 {
            
            bubbleViewHeightConstraint.isActive = false
            bubbleViewHeightConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .height, relatedBy: .equal, toItem: popsicleGroupCountBubbleView, attribute: .width, multiplier: 1.0, constant: 0.0)
            bubbleViewHeightConstraint.isActive = true
            
        } else if popsicleGroupCount >= 10 {
            
            bubbleViewHeightConstraint.isActive = false
            bubbleViewHeightConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: popsicleGroupCountLabel.intrinsicContentSize.height + innerInsetY)
            bubbleViewHeightConstraint.isActive = true
            
        }
        
        frame = CGRect(x: 0.0, y: 0.0, width: popsicleWidth + ((popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)/2), height: popsicleHeight)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        popsicleGroupContainerView.frame = bounds
        
    }
    
}

final class BubbleView: UIView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}

