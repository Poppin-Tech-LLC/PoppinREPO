//
//  UserLocationAnnotationView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/29/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import MapKit

final class UserLocationAnnotationView: MKAnnotationView {
    
    public static let defaultUserLocationAnnotationViewReuseIdentifier = "UserLocationAnnotationView"
    
    lazy private var userLocationIconImageView: UIImageView = {
        
        var userLocationIconImageView = UIImageView()
        userLocationIconImageView.image = .defaultUserPicture64
        userLocationIconImageView.contentMode = .scaleAspectFit
        return userLocationIconImageView
        
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
        
        frame.size = CGSize(width: .getPercentageWidth(percentage: 9), height: .getPercentageWidth(percentage: 9))
        addShadowAndRoundCorners(cornerRadius: min(frame.width, frame.height)/2, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        userLocationIconImageView.layer.cornerRadius = min(frame.width, frame.height)/2
        userLocationIconImageView.clipsToBounds = true
        layer.borderColor = UIColor.mainDARKPURPLE.cgColor
        layer.borderWidth = .getWidthFitSize(minSize: 1, maxSize: 2)
        displayPriority = .required
        canShowCallout = false
        
        addSubview(userLocationIconImageView)
        userLocationIconImageView.translatesAutoresizingMaskIntoConstraints = false
        userLocationIconImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userLocationIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        userLocationIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        userLocationIconImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func setUserLocationIcon(icon: UIImage?) {
        
        if let newIcon = icon { self.userLocationIconImageView.image = newIcon }
        
    }
    
}

