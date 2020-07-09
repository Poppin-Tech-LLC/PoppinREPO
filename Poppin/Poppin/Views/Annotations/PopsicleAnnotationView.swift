//
//  PopsicleAnnotationView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/29/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import MapKit

class PopsicleAnnotationView: MKAnnotationView {
    
    public static let defaultPopsicleAnnotationViewReuseIdentifier = "PopsicleAnnotationView"
    
    private let popsicleHeight: CGFloat = .getPercentageWidth(percentage: 12.5)
    private let popsicleWidth: CGFloat = .getPercentageWidth(percentage: 7.5)
    
    lazy private var popsicleContainerView: UIView = {
        
        var popsicleContainerView = UIView()
        popsicleContainerView.backgroundColor = .clear
        
        popsicleContainerView.addSubview(popsicleIconImageView)
        popsicleIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleIconImageView.topAnchor.constraint(equalTo: popsicleContainerView.topAnchor).isActive = true
        popsicleIconImageView.leadingAnchor.constraint(equalTo: popsicleContainerView.leadingAnchor).isActive = true
        popsicleIconImageView.trailingAnchor.constraint(equalTo: popsicleContainerView.trailingAnchor).isActive = true
        popsicleIconImageView.bottomAnchor.constraint(equalTo: popsicleContainerView.bottomAnchor).isActive = true
        
        popsicleContainerView.addSubview(popsicleIconShadowImageView)
        popsicleContainerView.sendSubviewToBack(popsicleIconShadowImageView)
        popsicleIconShadowImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleIconShadowImageView.centerYAnchor.constraint(equalTo: popsicleIconImageView.bottomAnchor, constant: -1.5).isActive = true
        popsicleIconShadowImageView.centerXAnchor.constraint(equalTo: popsicleIconImageView.centerXAnchor).isActive = true
        popsicleIconShadowImageView.widthAnchor.constraint(equalTo: popsicleIconImageView.widthAnchor, multiplier: 0.87).isActive = true
        popsicleIconShadowImageView.heightAnchor.constraint(equalTo: popsicleIconImageView.heightAnchor, multiplier: 0.27).isActive = true
        
        return popsicleContainerView
        
    }()
    
    lazy private var popsicleIconImageView: UIImageView = {
        
        var popsicleGroupIconImageView = UIImageView()
        popsicleGroupIconImageView.image = .defaultPopsicleIcon256
        popsicleGroupIconImageView.contentMode = .scaleAspectFit
        return popsicleGroupIconImageView
        
    }()
    
    lazy private var popsicleIconShadowImageView: UIImageView = {
        
        var popsicleIconShadowImageView = UIImageView()
        popsicleIconShadowImageView.image = .defaultPopsicleIconShadow256
        popsicleIconShadowImageView.alpha = 0.6
        popsicleIconShadowImageView.contentMode = .scaleToFill
        return popsicleIconShadowImageView
        
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
        
        frame = CGRect(x: 0.0, y: 0.0, width: popsicleWidth, height: popsicleHeight)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        addSubview(popsicleContainerView)
        popsicleContainerView.frame = bounds
        
    }
    
    func setPopsicleAnnotation(popsicleAnnotation: PopsicleAnnotation) {
        
        canShowCallout = false
        clusteringIdentifier = "PopsicleGroup"
        collisionMode = .rectangle
        displayPriority = .required
        
        annotation = popsicleAnnotation
        popsicleIconImageView.image = popsicleAnnotation.getPopsicleAnnotationImage()
        popsicleIconShadowImageView.image = popsicleAnnotation.getPopsicleShadowImage()
        
    }
    
}
