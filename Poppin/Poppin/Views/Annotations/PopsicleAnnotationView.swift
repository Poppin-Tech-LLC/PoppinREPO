//
//  PopsicleAnnotationView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/29/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit

final class EventAnnotationView: MKAnnotationView {
    
    static let defaultReuseIdentifier = "EventAnnotationView"
    
    lazy private var containerView: UIView = {
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        _ = [popsicleShadowIcon, popsicleIcon].map { containerView.addSubview($0) }
        
        popsicleIcon.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor)
        
        popsicleShadowIcon.anchor(leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, centerY: popsicleIcon.bottomAnchor, centerOffset: CGSize(width: 0.0, height: -1.5))
        
        return containerView
        
    }()
    
    lazy private var popsicleIcon = UIImageView(image: EventCategory.allCases[0].getPopsicleIcon256().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0))))
    
    lazy private var popsicleShadowIcon: UIImageView = {
        
        let popsicleIconShadowImageView = UIImageView(image: EventCategory.allCases[0].getPopsicleShadow256().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0))))
        popsicleIconShadowImageView.alpha = 0.6
        return popsicleIconShadowImageView
        
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        frame = CGRect(x: 0.0, y: 0.0, width: popsicleIcon.intrinsicContentSize.width, height: popsicleIcon.intrinsicContentSize.height + (popsicleShadowIcon.intrinsicContentSize.height*0.5) - 1.5)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        addSubview(containerView)
        containerView.frame = bounds
        
    }
    
    func setEventAnnotation(eventAnnotation: EventAnnotation) {
        
        canShowCallout = false
        clusteringIdentifier = "EventGroup"
        collisionMode = .rectangle
        displayPriority = .required
        
        annotation = eventAnnotation
        popsicleIcon.image = eventAnnotation.category.getPopsicleIcon256().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0)))
        popsicleShadowIcon.image = eventAnnotation.category.getPopsicleShadow256().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0)))
        
    }
    
}

struct PreviewEventAnnotationView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = EventAnnotationView
    
}

struct TestPreviewEventAnnotationView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewEventAnnotationView
    
}


class PopsicleAnnotationView: MKAnnotationView {
    
    public static let defaultPopsicleAnnotationViewReuseIdentifier = "PopsicleAnnotationView"
    
    private let popsicleHeight: CGFloat = .getPercentageWidth(percentage: 12.5)
    private let popsicleWidth: CGFloat = .getPercentageWidth(percentage: 12.0)
    
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
