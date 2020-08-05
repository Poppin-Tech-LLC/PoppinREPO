//
//  LocationInputView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/1/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit

struct PreviewLocationInputView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType(category: nil, mapBoundry: nil, location: nil)
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = LocationInputView
    
}

struct TestPreviewLocationInputView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewLocationInputView
    
}

final class LocationInputView: UIView {
    
    let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var category: EventCategory = .Culture
    private var mapBoundry: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619), latitudinalMeters: 3000.0, longitudinalMeters: 3000.0)
    private var location: CLLocationCoordinate2D?
    
    weak var delegate: LocationInputDelegate?
    
    lazy private(set) var mapView: MKMapView = {
        
        var mapView = MKMapView()
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.showsUserLocation = false
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mapBoundry)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius*0.07, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        tapRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(tapRecognizer)
        return mapView
        
    }()
    
    lazy private(set) var backButton: BubbleButton = {
        
        let innerInset: CGFloat = yInset*0.5
        
        var backButton = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .title3).pointSize, weight: .medium)).withTintColor(category.getGradientColors()[0], renderingMode: .alwaysOriginal))
        backButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset, bottom: innerInset, right: innerInset)
        backButton.backgroundColor = .clear
        return backButton
        
    }()
    
    lazy private(set) var blurOverlayView: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        
        var blurOverlayView = UIVisualEffectView(effect: blurEffect)
        blurOverlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurOverlayView.alpha = 0.0
        blurOverlayView.isHidden = true
        return blurOverlayView
        
    }()
    
    lazy private(set) var searchBar: SearchBar = {
        
        var searchBar = SearchBar(tintColor: .white)
        return searchBar
        
    }()
    
    lazy private(set) var searchBarCancelButton: BouncyButton = {
        
        var searchBarCancelButton = BouncyButton(bouncyButtonImage: nil)
        searchBarCancelButton.setTitle("Cancel", for: .normal)
        searchBarCancelButton.titleLabel?.textAlignment = .center
        searchBarCancelButton.setTitleColor(.white, for: .normal)
        searchBarCancelButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        //searchBarCancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: .touchUpInside)
        searchBarCancelButton.alpha = 0.0
        return searchBarCancelButton
        
    }()
    
    lazy private(set) var searchBarHiddenConstraints: [NSLayoutConstraint] = {
    
        var searchBarHiddenConstraints = [NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -xInset), NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: backButton, attribute: .trailing, multiplier: 1.0, constant: xInset - (yInset*0.33))]
        return searchBarHiddenConstraints
    
    }()
    
    lazy private(set) var searchBarShowingConstraints: [NSLayoutConstraint] = {
    
        var searchBarShowingConstraints = [NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: searchBarCancelButton, attribute: .leading, multiplier: 1.0, constant: -xInset), NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: xInset)]
        return searchBarShowingConstraints
    
    }()
    
    lazy private(set) var searchScrollView: UIScrollView = {
        
        var searchScrollView = UIScrollView()
        searchScrollView.alwaysBounceVertical = true
        searchScrollView.showsVerticalScrollIndicator = false
        searchScrollView.keyboardDismissMode = .onDrag
        searchScrollView.contentInset = UIEdgeInsets(top: yInset, left: 0.0, bottom: yInset, right: 0.0)
        searchScrollView.alpha = 0.0
        searchScrollView.isHidden = true
        
        searchScrollView.addSubview(searchTableView)
        searchTableView.attatchEdgesToSuperview()
        searchTableView.anchor(width: searchScrollView.widthAnchor)
        
        return searchScrollView
        
    }()
    
    lazy private(set) var searchTableView: SelfSizedTableView = {
        
        var searchTableView = SelfSizedTableView()
        searchTableView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        searchTableView.isScrollEnabled = true
        searchTableView.clipsToBounds = true
        searchTableView.separatorColor = UIColor.mainDARKPURPLE.withAlphaComponent(0.7)
        searchTableView.backgroundColor = .white
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = UITableView.automaticDimension
        searchTableView.register(LocationSearchCell.self, forCellReuseIdentifier: LocationSearchCell.cellIdentifier)
        return searchTableView
        
    }()
    
    lazy private(set) var helpTitleView: UIView = {
        
        let helpLabel: UILabel = UILabel()
        helpLabel.text = "Tap on the map to select a location"
        helpLabel.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        helpLabel.numberOfLines = 1
        helpLabel.textAlignment = .center
        helpLabel.textColor = .white
        
        var helpTitleView = UIView()
        helpTitleView.backgroundColor = category.getGradientColors()[0]
        helpTitleView.clipsToBounds = true
        helpTitleView.layer.cornerRadius = .getWidthFitSize(minSize: 12.0, maxSize: 14.0)
        
        helpTitleView.addSubview(helpLabel)
        helpLabel.attatchEdgesToSuperview(padding: UIEdgeInsets(top: yInset*0.5, left: xInset*0.6, bottom: yInset*0.5, right: xInset*0.6))
        
        return helpTitleView
        
    }()
    
    lazy private(set) var confirmLocationView: UIView = {
        
        let containerView = UIView()
        containerView.backgroundColor = category.getGradientColors()[0]
        containerView.clipsToBounds = true
        containerView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 14.0), shadowOpacity: 0.0, topRightMask: true, topLeftMask: true, bottomRightMask: false, bottomLeftMask: false)
        
        containerView.addSubview(saveButton)
        saveButton.anchor(top: containerView.topAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: yInset, left: 0.0, bottom: 0.0, right: xInset))
        
        containerView.addSubview(locationTitleLabel)
        locationTitleLabel.anchor(centerX: containerView.centerXAnchor, centerY: saveButton.centerYAnchor)
        
        containerView.addSubview(locationTextView)
        locationTextView.anchor(top: saveButton.bottomAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, padding: UIEdgeInsets(top: yInset*0.5, left: xInset, bottom: 0.0, right: xInset))
        
        var confirmLocationView = UIView()
        confirmLocationView.backgroundColor = category.getGradientColors()[1]
        confirmLocationView.clipsToBounds = true
        confirmLocationView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 14.0), shadowOpacity: 0.0, topRightMask: true, topLeftMask: true, bottomRightMask: false, bottomLeftMask: false)
        
        confirmLocationView.addSubview(containerView)
        containerView.attatchEdgesToSuperview(padding: UIEdgeInsets(top: yInset, left: yInset, bottom: 0.0, right: yInset))
        
        return confirmLocationView
        
    }()
    
    lazy private(set) var locationTitleLabel: UILabel = {
        
        var locationTitleLabel: UILabel = UILabel()
        locationTitleLabel.text = "Location"
        locationTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        locationTitleLabel.numberOfLines = 1
        locationTitleLabel.textAlignment = .center
        locationTitleLabel.textColor = .white
        return locationTitleLabel
        
    }()
    
    lazy private(set) var saveButton: BouncyButton = {
        
        var saveButton = BouncyButton(bouncyButtonImage: nil)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        saveButton.setTitleColor(.white, for: .normal)
        return saveButton
        
    }()
    
    lazy private(set) var locationTextView: UITextView = {
        
        var locationTextView = UITextView()
        locationTextView.clipsToBounds = true
        locationTextView.layer.cornerRadius = .getWidthFitSize(minSize: 12.0, maxSize: 14.0)
        locationTextView.backgroundColor = category.getGradientColors()[1]
        locationTextView.textColor = .white
        locationTextView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        
        if let location = location {
            
            location.lookUpLocationAddress { (address) in
                
                if let address = address {
                    
                    locationTextView.text = String(address.split(separator: "\n")[0])
                    
                } else {
                    
                    locationTextView.text = "Address unavailable"
                    
                }
                
            }
            
        } else {
            
            CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619).lookUpLocationAddress { (address) in
                
                if let address = address {
                    
                    locationTextView.text = String(address.split(separator: "\n")[0])
                    
                } else {
                    
                    locationTextView.text = "Address unavailable"
                    
                }
                
            }
            
        }
        
        locationTextView.textContainerInset = UIEdgeInsets(top: yInset*0.5, left: xInset*0.5, bottom: yInset*0.5, right: xInset*0.5)
        locationTextView.isUserInteractionEnabled = false
        locationTextView.isScrollEnabled = false
        return locationTextView
        
    }()
    
    init(category: EventCategory?, mapBoundry: MKCoordinateRegion?, location: CLLocationCoordinate2D?) {
        
        super.init(frame: .zero)
        
        if let category = category { self.category = category }
        if let mapBoundry = mapBoundry { self.mapBoundry = mapBoundry }
        self.location = location
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = category.getGradientColors()[0]
        
        addSubview(mapView)
        mapView.attatchEdgesToSuperview()
        
        addSubview(helpTitleView)
        helpTitleView.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, centerX: centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: yInset*2, right: 0.0))
        
        addSubview(confirmLocationView)
        confirmLocationView.anchor(leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        locationTextView.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: yInset*1.33, right: 0.0))
        
        blurOverlayView.frame = bounds
        addSubview(blurOverlayView)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, padding: UIEdgeInsets(top: yInset*0.77, left: xInset-(yInset*0.33), bottom: 0.0, right: 0.0))
        
        addSubview(searchBar)
        searchBar.anchor(centerY: backButton.centerYAnchor, size: CGSize(width: 0.0, height: backButton.intrinsicContentSize.height))
        
        addSubview(searchBarCancelButton)
        searchBarCancelButton.anchor(trailing: trailingAnchor, centerY: backButton.centerYAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: xInset))
        
        searchBarHiddenConstraints[0].isActive = true
        searchBarHiddenConstraints[1].isActive = true
        
        addSubview(searchScrollView)
        searchScrollView.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0.0, left: xInset, bottom: 0.0, right: xInset))
        
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        
        delegate?.dropPopsicle(at: gestureRecognizer.location(in: mapView))
        
    }
    
}
