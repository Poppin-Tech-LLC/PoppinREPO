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
    
    private(set) var popsicleGroupCount: Int = 0 {
        
        didSet {
            
            popsicleGroupCountLabel.text = String(popsicleGroupCount)
            
        }
        
    }
    
    lazy private var popsicleGroupContainerView: UIView = {
        
        var popsicleGroupContainerView = UIView()
        popsicleGroupContainerView.backgroundColor = .clear
        
        popsicleGroupContainerView.addSubview(popsicleGroupIconImageView)
        popsicleGroupIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupIconImageView.topAnchor.constraint(equalTo: popsicleGroupContainerView.topAnchor).isActive = true
        popsicleGroupIconImageView.leadingAnchor.constraint(equalTo: popsicleGroupContainerView.leadingAnchor).isActive = true
        popsicleGroupIconImageView.trailingAnchor.constraint(equalTo: popsicleGroupContainerView.trailingAnchor).isActive = true
        popsicleGroupIconImageView.bottomAnchor.constraint(equalTo: popsicleGroupContainerView.bottomAnchor).isActive = true
        
        popsicleGroupContainerView.addSubview(popsicleGroupCountBubbleView)
        popsicleGroupCountBubbleView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupCountBubbleView.topAnchor.constraint(equalTo: popsicleGroupContainerView.topAnchor).isActive = true
        popsicleGroupCountBubbleView.trailingAnchor.constraint(equalTo: popsicleGroupContainerView.trailingAnchor).isActive = true
        popsicleGroupCountBubbleView.heightAnchor.constraint(equalTo: popsicleGroupIconImageView.heightAnchor, multiplier: 1/2).isActive = true
        popsicleGroupCountBubbleView.widthAnchor.constraint(equalTo: popsicleGroupCountBubbleView.heightAnchor).isActive = true
        
        return popsicleGroupContainerView
        
    }()
    
    lazy private var popsicleGroupIconImageView: UIImageView = {
        
        var popsicleGroupIconImageView = UIImageView()
        popsicleGroupIconImageView.image = .popsicleGroupIcon128
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
        popsicleGroupCountLabel.text = String(popsicleGroupCount)
        popsicleGroupCountLabel.numberOfLines = 1
        popsicleGroupCountLabel.textColor = .white
        popsicleGroupCountLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 12.0, maxSize: 14.0))
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
        collisionMode = .circle
        frame.size = CGSize(width: .getPercentageWidth(percentage: 12.5), height: .getPercentageWidth(percentage: 12.5))
        displayPriority = .required
        
        addSubview(popsicleGroupContainerView)
        popsicleGroupContainerView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        popsicleGroupContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        popsicleGroupContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        popsicleGroupContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func setGroupCount(count: Int) {
        
        popsicleGroupCount = count
        
    }
    
}

class BubbleView: UIView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}

