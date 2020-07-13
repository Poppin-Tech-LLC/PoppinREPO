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

    private let userLocationAnnotationWidth: CGFloat = .getPercentageWidth(percentage: 8)
    
    lazy private var userLocationIconImageView: BubbleImageView = {
        
        var userLocationIconImageView = BubbleImageView()
        userLocationIconImageView.image = .defaultUserPicture128
        userLocationIconImageView.contentMode = .scaleAspectFill
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
        
        frame.size = CGSize(width: userLocationAnnotationWidth, height: userLocationAnnotationWidth)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        addShadowAndRoundCorners(cornerRadius: min(frame.width, frame.height)/2, shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
        addSubview(userLocationIconImageView)
        userLocationIconImageView.frame = bounds
        
        displayPriority = .required
        canShowCallout = false
        
    }
    
    func setUserLocationIcon(icon: UIImage?) {
        
        if let newIcon = icon { self.userLocationIconImageView.image = newIcon }
        
    }
    
}

