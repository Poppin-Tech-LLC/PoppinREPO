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
    
    private(set) var popsicleGroupCount: Int = 0 {
        
        didSet {
            
            frame = CGRect(x: 0.0, y: 0.0, width: popsicleWidth + ((popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)/2), height: popsicleHeight)
            
            addSubview(popsicleGroupContainerView)
            popsicleGroupContainerView.frame = bounds
            
        }
        
    }
    
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
        
        if popsicleGroupCount >= 0 && popsicleGroupCount < 10 {
            
            popsicleGroupCountBubbleView.widthAnchor.constraint(equalToConstant: popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX).isActive = true
            popsicleGroupCountBubbleView.heightAnchor.constraint(equalTo: popsicleGroupCountBubbleView.widthAnchor).isActive = true
            
        } else if popsicleGroupCount >= 10 {
            
            popsicleGroupCountBubbleView.widthAnchor.constraint(equalToConstant: popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX).isActive = true
            popsicleGroupCountBubbleView.heightAnchor.constraint(equalToConstant: popsicleGroupCountLabel.intrinsicContentSize.height + innerInsetY).isActive = true
            
        }
        
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
        
        if popsicleGroupCount > 99 {
            
            popsicleGroupCountLabel.text = "99+"
            
        } else if popsicleGroupCount >= 0 {
            
            popsicleGroupCountLabel.text = String(popsicleGroupCount)
            
        }
        
        popsicleGroupCountLabel.numberOfLines = 1
        popsicleGroupCountLabel.textColor = .white
        popsicleGroupCountLabel.backgroundColor = .mainDARKPURPLE
        popsicleGroupCountLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption1)
        return popsicleGroupCountLabel
        
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
        
        canShowCallout = false
        displayPriority = .required
        collisionMode = .rectangle
        
    }
    
    func setGroupCount(count: Int) {
        
        popsicleGroupCount = count
        
    }
    
}

class BubbleView: UIView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}

