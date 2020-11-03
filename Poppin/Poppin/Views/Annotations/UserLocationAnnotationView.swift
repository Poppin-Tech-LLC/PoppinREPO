//
//  UserLocationAnnotationView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/29/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import MapKit
import SwiftUI

final class UserAnnotationView: MKAnnotationView {
    
    static let defaultReuseIdentifier = "UserAnnotationView"
    
    lazy private var userIcon = BubbleImageView(image: UIImage.defaultUserPicture256.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0))))
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        frame.size = CGSize(width: userIcon.intrinsicContentSize.width, height: userIcon.intrinsicContentSize.height)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        clipsToBounds = true
        layer.cornerRadius = min(frame.width, frame.height)/2
        apply(shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        addSubview(userIcon)
        userIcon.frame = bounds
        
        displayPriority = .required
        canShowCallout = false
        
    }
    
    func setUserIcon(icon: UIImage?) {
        
        if let icon = icon {
            
            self.userIcon.image = icon.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0)))
            
        } else {
            
            self.userIcon.image = UIImage.defaultUserPicture256.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0)))
            
        }
        
    }
    
}

struct PreviewUserAnnotationView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = UserAnnotationView
    
}

struct TestPreviewUserAnnotationView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewUserAnnotationView
    
}

final class UserLocationAnnotationView: MKAnnotationView {
    
    public static let defaultUserLocationAnnotationViewReuseIdentifier = "UserLocationAnnotationView"

    private let userLocationAnnotationWidth: CGFloat = .getPercentageWidth(percentage: 8)
    
    lazy private var userLocationIconImageView: BubbleImageView = {
        
        var userLocationIconImageView = BubbleImageView()
        userLocationIconImageView.image = .defaultUserPicture256
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


