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
        popsicleGroupIconImageView.image = (annotation as! NewPopsicleAnnotation).getPopsicleAnnotationImage()
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
            
            if popsicleAnnotation is NewPopsicleAnnotation {
                
                popsicleCategory = (annotation as! NewPopsicleAnnotation).popsicleAnnotationData.eventCategory
                
            } else {
                
                print("ERROR: Trying to create a PopsicleAnnotationView with an annotation that is not PopsicleAnnotation. Adding a default one.")
                annotation = NewPopsicleAnnotation(popsicleAnnotationData: NewPopsicleAnnotation.defaultPopsicleAnnotationData)
                
            }
            
        } else {
            
            print("ERROR: Trying to create a PopsicleAnnotationView without an annotation. Adding a default one.")
            annotation = NewPopsicleAnnotation(popsicleAnnotationData: NewPopsicleAnnotation.defaultPopsicleAnnotationData)
            
        }
        
        canShowCallout = false
        frame.size = CGSize(width: .getPercentageWidth(percentage: 12.5), height: .getPercentageWidth(percentage: 12.5))
        clusteringIdentifier = "Popsicle Group"
        displayPriority = .required
        
        addSubview(popsicleContainerView)
        popsicleContainerView.translatesAutoresizingMaskIntoConstraints = false
        popsicleContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        popsicleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        popsicleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        popsicleContainerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
}
