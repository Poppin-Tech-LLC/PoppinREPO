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

    private(set) var popsicleCategory: PopsicleCategory = .Default
    
    lazy private var popsicleContainerView: UIView = {
        
        var popsicleContainerView = UIView()
        popsicleContainerView.backgroundColor = .clear
        
        popsicleContainerView.addSubview(popsicleIconImageView)
        popsicleIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleIconImageView.topAnchor.constraint(equalTo: popsicleContainerView.topAnchor).isActive = true
        popsicleIconImageView.leadingAnchor.constraint(equalTo: popsicleContainerView.leadingAnchor).isActive = true
        popsicleIconImageView.trailingAnchor.constraint(equalTo: popsicleContainerView.trailingAnchor).isActive = true
        popsicleIconImageView.bottomAnchor.constraint(equalTo: popsicleContainerView.bottomAnchor).isActive = true
        
        return popsicleContainerView
        
    }()
    
    lazy private var popsicleIconImageView: UIImageView = {
        
        var popsicleGroupIconImageView = UIImageView()
        popsicleGroupIconImageView.addShadowAndRoundCorners(cornerRadius: 0.0, shadowColor: UIColor.mainDARKGRAY, shadowOffset: CGSize(width: 0.0, height: 0.0), shadowOpacity: 0.5, shadowRadius: 2.0)
        popsicleGroupIconImageView.image = (annotation as! PopsicleAnnotation).getPopsicleAnnotationImage()
        popsicleGroupIconImageView.contentMode = .scaleAspectFit
        return popsicleGroupIconImageView
        
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
        
        if let popsicleAnnotation = self.annotation {
            
            if popsicleAnnotation is PopsicleAnnotation {
                
                popsicleCategory = (annotation as! PopsicleAnnotation).popsicleAnnotationData.eventCategory
                
            } else {
                
                print("ERROR: Trying to create a PopsicleAnnotationView with an annotation that is not PopsicleAnnotation. Adding a default one.")
                annotation = PopsicleAnnotation(popsicleAnnotationData: PopsicleAnnotation.defaultPopsicleAnnotationData)
                
            }
            
        } else {
            
            print("ERROR: Trying to create a PopsicleAnnotationView without an annotation. Adding a default one.")
            annotation = PopsicleAnnotation(popsicleAnnotationData: PopsicleAnnotation.defaultPopsicleAnnotationData)
            
        }
        
        frame = CGRect(x: 0.0, y: 0.0, width: popsicleWidth, height: popsicleHeight)
        
        addSubview(popsicleContainerView)
        popsicleContainerView.frame = bounds
        
        canShowCallout = false
        clusteringIdentifier = "Popsicle Group"
        collisionMode = .rectangle
        displayPriority = .required
        
    }
    
}
