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
import Contacts

/// Event Location Input Page UI.
final class LocationInputView: UIView {
    
    /// Event annotation representing the current selected location.
    lazy private(set) var eventAnnotation = EventAnnotation(id: nil, location: MapViewController.defaultMapViewCenterLocation, category: EventCategory.allCases[0])
    
    // Top margin.
    lazy private var topLayoutGuide = UILayoutGuide()
    
    /// Event location input map.
    lazy private(set) var mapView = MapView(center: MapViewController.defaultMapViewCenterLocation, radius: MapViewController.defaultMapViewRegionRadius, showsUserLocation: false, tapAction: { [weak self] (point) in
        
        guard let self = self else { return }
        guard let point = point else { return }
        self.dropAnnotation(at: point)
        
    })
    
    /// Dim overlay shown on top of the map when the search bar begins editing. Hidden by default.
    lazy private(set) var dimOverlayView: CardView = {
        
        let dimOverlayView = CardView(bgColor: UIColor.black.withAlphaComponent(0.5))
        
        // 1. Add subviews.
        dimOverlayView.addSubview(searchView)
        
        dimOverlayView.alpha = 0.0
        dimOverlayView.isHidden = true
        return dimOverlayView
        
    }()
    
    /// Button that closes the input field and ignore changes.
    lazy private(set) var backButton: OctarineButton = {
        
        let backButton = OctarineButton(bgColor: .clear, label: nil, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 3.0), right: .width(percent: 4.0)))
        backButton.setImage(UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .bold)).withTintColor(EventCategory.allCases[0].getGradientColors()[1], renderingMode: .alwaysOriginal), for: .normal)
        return backButton
        
    }()
    
    /// Top search bar. Used to search for locations around.
    lazy private(set) var searchBarView = SearchBarView(searchBarColor: .white, searchBarPlaceholder: "Search or tap anywhere on the map",  padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: .width(percent: 4.0)))
    
    /// Constraint activated when search bar begins editing. Hides the back button.
    lazy private(set) var searchBarEditingConstraint = NSLayoutConstraint(item: searchBarView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: backButton.padding.left)
    
    /// Constraint activated when search bar finishes editing. Shows the back button.
    lazy private(set) var searchBarNotEditingConstraint = NSLayoutConstraint(item: searchBarView, attribute: .leading, relatedBy: .equal, toItem: backButton, attribute: .trailing, multiplier: 1.0, constant: 0.0)
    
    /// Table of location results according to the input from the search bar.
    lazy private(set) var searchView: ScrollableTableView = {
        
        let searchView = ScrollableTableView(tableView: TableView(bgColor: .white, cornerRadius: .width(percent: 4.0), shadow: Shadow(color: .lightGray, radius: 0.4, x: 0.0, y: 1.0), separatorColor: .mainDARKPURPLE), padding: UIEdgeInsets(top: .width(percent: 4.0), left: 0.0, bottom: .width(percent: 4.0), right: 0.0))
        searchView.tableView.register(LocationCell.self, forCellReuseIdentifier: LocationCell.defaultReuseIdentifier)
        return searchView
        
    }()
    
    // Dimmed Background.
    lazy private var cardBackgroundView: CardView = {
       
        let cardBackgroundView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[1], padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 3.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [cardView].map { cardBackgroundView.addSubview($0) }
        
        // 2. Apply constraints.
        cardView.anchor(top: cardBackgroundView.layoutMarginsGuide.topAnchor, leading: cardBackgroundView.layoutMarginsGuide.leadingAnchor, bottom: cardBackgroundView.layoutMarginsGuide.bottomAnchor, trailing: cardBackgroundView.layoutMarginsGuide.trailingAnchor)
        
        return cardBackgroundView
        
    }()
    
    /// Card container.
    lazy private var cardView: CardView = {
        
        let cardView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0], padding: UIEdgeInsets(top: 0.0, left: .width(percent: 8.0), bottom: 0.0, right: .width(percent: 9.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [locationTextView, navigationBar].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        navigationBar.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor)
        
        locationTextView.anchor(top: navigationBar.bottomAnchor, leading: cardView.layoutMarginsGuide.leadingAnchor, trailing: cardView.layoutMarginsGuide.trailingAnchor)
        
        return cardView
        
    }()
    
    /// Constraint activated when card view is showing.
    lazy private(set) var cardViewShowingConstraint = NSLayoutConstraint(item: locationTextView, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -.width(percent: 2.0))
    
    /// Constraint activated when card view is hiding.
    lazy private(set) var cardViewHidingConstraint = NSLayoutConstraint(item: cardBackgroundView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    
    // Top bar containing the input title label, and the save button.
    lazy private var navigationBar: CardView = {
        
        let navigationBar = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0], padding: .zero, cornerRadius: 0.0)
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [titleLabel, saveButton].map { navigationBar.addSubview($0) }
        
        // 2. Apply constraints.
        titleLabel.anchor(top: navigationBar.topAnchor, bottom: navigationBar.bottomAnchor, centerX: navigationBar.centerXAnchor, padding: UIEdgeInsets(top: saveButton.padding.top, left: 0.0, bottom: saveButton.padding.bottom, right: 0.0))
        
        saveButton.anchor(top: navigationBar.topAnchor, bottom: navigationBar.bottomAnchor, trailing: navigationBar.trailingAnchor)
        
        return navigationBar
        
    }()
    
    // Input title label.
    lazy private var titleLabel = OctarineLabel(text: "Event Location", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1)
    
    /// Closes the input field and updates the event details.
    lazy private(set) var saveButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[0], label: OctarineLabel(text: "Save", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 4.0), left: .width(percent: 4.0), bottom: .width(percent: 4.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 4.0))
    
    /// Event location input field.
    lazy private(set) var locationTextView: UITextView = {
        
        let locationTextView = UITextView()
        locationTextView.clipsToBounds = true
        locationTextView.layer.cornerRadius = .width(percent: 4.0)
        locationTextView.backgroundColor = EventCategory.allCases[0].getGradientColors()[1]
        locationTextView.textColor = .white
        locationTextView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        locationTextView.text = "Address unavailable"
        locationTextView.textContainerInset = UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 2.0), bottom: .width(percent: 2.0), right: .width(percent: 2.0))
        locationTextView.isUserInteractionEnabled = false
        locationTextView.isScrollEnabled = false
        return locationTextView
        
    }()
    
    /**
    Overrides superclass initializer to configure the UI.

    - Parameter frame: Ignored by AutoLayout (default it to .zero)
    */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configureView()
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder from storyboard.
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure UI.
    private func configureView() {
        
        // 1. Sets the color of the background to the current event category (defaults to culture purple).
        backgroundColor = EventCategory.allCases[0].getGradientColors()[1]
        
        // 2. Add layout guides to the root view.
        _ = [topLayoutGuide].map { self.addLayoutGuide($0) }
        
        // 3. Add subviews to the root view (each one on top of the others).
        _ = [mapView, cardBackgroundView, dimOverlayView, backButton, searchBarView].map { self.addSubview($0) }
    
        // 4. Apply constraints.
        topLayoutGuide.attatchEdgesTo(superview: self, safeArea: true, padding: UIEdgeInsets(top: .width(percent: 4.0), left: 0.0, bottom: 0.0, right: 0.0))
        
        mapView.attatchEdgesToSuperview()
        
        cardBackgroundView.anchor(leading: leadingAnchor, trailing: trailingAnchor, size: CGSize(width: 0.0, height: .height(percent: 100)))
        cardViewHidingConstraint.isActive = true
        
        dimOverlayView.attatchEdgesToSuperview()
        
        backButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        backButton.anchor(top: topLayoutGuide.topAnchor, leading: leadingAnchor)
        
        searchBarView.setContentHuggingPriority(.defaultLow, for: .vertical)
        searchBarView.anchor(top: topLayoutGuide.topAnchor, bottom: backButton.bottomAnchor, trailing: trailingAnchor)
        searchBarNotEditingConstraint.isActive = true
        
        searchView.anchor(top: backButton.bottomAnchor, leading: dimOverlayView.leadingAnchor, bottom: dimOverlayView.bottomAnchor, trailing: dimOverlayView.trailingAnchor, padding: UIEdgeInsets(top: 0.0, left: backButton.padding.left, bottom: 0.0, right: backButton.padding.right))
        
    }
    
    /// Updates the UI according to the current input entered for the event being created. If any values are nil, default ones are used.
    func updateUI(eventInput: EventModel?) {
        
        let lightColor = eventInput?.category?.getGradientColors()[0] ?? EventCategory.allCases[0].getGradientColors()[0]
        let highlightedColor = lightColor.darkerColor(percent: 0.1)
        let darkColor = eventInput?.category?.getGradientColors()[1] ?? EventCategory.allCases[0].getGradientColors()[1]
     
        // 1. Change background and card color.
        backgroundColor = darkColor
        cardBackgroundView.backgroundColor = darkColor
        cardView.backgroundColor = lightColor
        
        // 2. Change navigation bar background color.
        navigationBar.backgroundColor = lightColor
        
        // 3. Change cancel button color.
        backButton.highlightedColor = highlightedColor
        backButton.nonHighlightedColor = lightColor
        
        // 4. Change save button color.
        saveButton.backgroundColor = lightColor
        saveButton.highlightedColor = highlightedColor
        saveButton.nonHighlightedColor = lightColor
        
        // 5. Update location text view, card view, and event annotation.
        locationTextView.backgroundColor = darkColor
        
        if let location = eventInput?.location {
            
            location.lookUpLocationAddress { [weak self] (address) in
                
                guard let self = self else { return }
                
                if let address = address {
                    
                    self.locationTextView.text = String(address.split(separator: "\n")[0])
                    
                } else {
                    
                    self.locationTextView.text = "Address unavailable"
                    
                }
                
                self.animateCardIn(animated: true)
                
            }
            
            eventAnnotation.category = eventInput?.category ?? EventCategory.allCases[0]
            eventAnnotation.coordinate = location
            
            mapView.addAnnotation(eventAnnotation)
            mapView.zoom(to: MKCoordinateRegion(center: self.eventAnnotation.coordinate, latitudinalMeters: 200.0, longitudinalMeters: 200.0), animated: false)
            
        } else {
            
            locationTextView.text = "Address unavailable"
            animateCardOut(animated: false)
            
            eventAnnotation.category = eventInput?.category ?? EventCategory.allCases[0]
            
        }
        
    }
    
    /**
    Hides the card view with an animation or without one.

    - Parameter animated: Determines whether to hide the elements with an animation or not.
    */
    func animateCardOut(animated: Bool) {
        
        cardViewHidingConstraint.isActive = true
        cardViewShowingConstraint.isActive = false
        
        if animated {
            
            UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.layoutIfNeeded()
                        
            }, completion: nil)
            
        }
        
    }
    
    /**
    Shows the card view with an animation or without one.

    - Parameter animated: Determines whether to show the elements with an animation or not.
    */
    func animateCardIn(animated: Bool) {
        
        cardViewHidingConstraint.isActive = false
        cardViewShowingConstraint.isActive = true
        
        if animated {
            
            UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.layoutIfNeeded()
                        
            }, completion: nil)
            
        }
        
    }
    
    /**
    Drops an annotation at the selected placemark and updates the location text view with the respective address.

    - Parameter placemark: Map placemark selected by the user.
    */
    func dropAnnotation(at placemark: MKPlacemark) {
     
        // 1. Reset map with new coordinate.
        mapView.removeAnnotations(mapView.annotations)
        eventAnnotation.coordinate = placemark.coordinate
        mapView.addAnnotation(eventAnnotation)
        
        // 2. Update address of location text view from placemark passed.
        if let postalAddress = placemark.postalAddress {
            
            let address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
            locationTextView.text = String(address.split(separator: "\n")[0])
            
        } else {
            
            locationTextView.text = "Address unavailable"
            
        }
        
        // 3. If card view is hidden, show it.
        if cardViewHidingConstraint.isActive { animateCardIn(animated: true) }
        
        // 4. Zoom to the newly created annotation.
        mapView.zoom(to: MKCoordinateRegion(center: self.eventAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
        
    }
    
    /**
    Drops an annotation at the selected location and updates the location text view with the respective address.

    - Parameter point: Map location where the user tapped.
    */
    func dropAnnotation(at point: CGPoint) {
        
        // 1. Get coordinate of touch point.
        let touchCoordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        // 2. Reset map with new coordinate.
        mapView.removeAnnotations(mapView.annotations)
        eventAnnotation.coordinate = touchCoordinate
        mapView.addAnnotation(eventAnnotation)
        
        // 3. Update address of location text view from coordinate passed.
        eventAnnotation.coordinate.lookUpLocationAddress { [weak self] (address) in
            
            guard let self = self else { return }
            
            if let address = address {
                
                self.locationTextView.text = String(address.split(separator: "\n")[0])
                
            } else {
                
                self.locationTextView.text = "Address unavailable"
                
            }
            
        }
        
        // 4. If card view is hidden, show it.
        if cardViewHidingConstraint.isActive { animateCardIn(animated: true) }
        
        // 5. Zoom to the newly created annotation.
        mapView.zoom(to: MKCoordinateRegion(center: self.eventAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
        
    }
    
    /// Displays the search view.
    func showSearch() {
        
        // 1. Show search view and dim overlay view. Also, hide back button.
        dimOverlayView.isHidden = false
        
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.825, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            self.searchBarEditingConstraint.isActive = true
            self.searchBarNotEditingConstraint.isActive = false
            self.backButton.alpha = 0.0
            self.dimOverlayView.alpha = 1.0
            self.layoutIfNeeded()
            
        }, completion: nil)
        
    }
    
    /// Hided the search view.
    func hideSearch() {
        
        // 1. Hide search view and dim overlay view. Also, show back button.
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.825, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            self.searchBarEditingConstraint.isActive = false
            self.searchBarNotEditingConstraint.isActive = true
            self.backButton.alpha = 1.0
            self.dimOverlayView.alpha = 0.0
            self.layoutIfNeeded()
            
        }, completion: { finished in
        
            self.dimOverlayView.isHidden = true
        
        })
        
    }
    
}

struct PreviewLocationInputView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIViewType {

        return UIViewType()

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

class MapView: MKMapView {
    
    private(set) var isLoading: Bool = false
    
    var tapAction: ((CGPoint?) -> Void)?
    
    lazy private var loadingView: CardView = {
        
        let loadingView = CardView(bgColor: UIColor.black.withAlphaComponent(0.5))
        loadingView.addSubview(loadingIndicatorView)
        loadingIndicatorView.anchor(centerX: loadingView.centerXAnchor, centerY: loadingView.centerYAnchor)
        return loadingView
        
    }()
    
    lazy private var loadingIndicatorView: UIActivityIndicatorView = {
        
        let loadingIndicatorView = UIActivityIndicatorView(style: .large)
        loadingIndicatorView.isUserInteractionEnabled = false
        loadingIndicatorView.color = .white
        return loadingIndicatorView
        
    }()
    
    lazy private var tapGesture: UITapGestureRecognizer = {
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        return tapGesture
        
    }()
    
    init(center: CLLocationCoordinate2D = .DU, radius: Double = 3000, showsUserLocation: Bool = false, tapAction: ((CGPoint?) -> Void)? = nil) {
        
        super.init(frame: .zero)
        
        self.isPitchEnabled = false
        self.isRotateEnabled = false
        self.updateBoundaryRegion(center: center, radius: radius)
        self.updateVisibleRegion(center: center, radius: radius, animated: true)
        self.showsUserLocation = showsUserLocation
        self.tapAction = tapAction
        self.addGestureRecognizer(tapGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) { tapAction?(sender?.location(in: self)) }
    
    func startLoading() {
        
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.isUserInteractionEnabled = false
                        self.loadingIndicatorView.startAnimating()
                        self.addSubview(self.loadingView)
                        self.loadingView.attatchEdgesToSuperview()
                        self.isLoading = true
                        
        }, completion: nil)
        
    }
    
    func stopLoading() {
        
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.isUserInteractionEnabled = true
                        self.loadingIndicatorView.stopAnimating()
                        self.loadingView.removeFromSuperview()
                        self.isLoading = false
                        
        }, completion: nil)
        
    }
    
    func updateBoundaryRegion(center: CLLocationCoordinate2D? = nil, radius: Double? = nil, animated: Bool = false) {
        
        guard let center = center else { return }
        guard let radius = radius else { return }
        
        self.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius)), animated: animated)
        self.setCameraZoomRange(MKMapView.CameraZoomRange(minCenterCoordinateDistance: radius*0.07, maxCenterCoordinateDistance: radius), animated: animated)
        
    }
    
    func updateVisibleRegion(center: CLLocationCoordinate2D? = nil, radius: Double? = nil, animated: Bool = true) {
        
        guard let center = center else { return }
        guard let radius = radius else { return }
        
        self.setRegion(MKCoordinateRegion(center: center, latitudinalMeters: radius, longitudinalMeters: radius), animated: animated)
        
    }
    
    func zoom(to region: MKCoordinateRegion? = nil, animated: Bool = true) {
        
        guard let region = region else { return }
        
        MKMapView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.825, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            
            self.setRegion(region, animated: animated)
            
        }, completion: nil)
        
    }
    
    func expand(eventGroup: MKClusterAnnotation? = nil, animated: Bool = true) {
        
        guard let eventGroup = eventGroup else { return }
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            var minLat = eventGroup.memberAnnotations[0].coordinate.latitude
            var maxLat = eventGroup.memberAnnotations[0].coordinate.latitude
            var minLng = eventGroup.memberAnnotations[0].coordinate.longitude
            var maxLng = eventGroup.memberAnnotations[0].coordinate.longitude
            
            for annotation in eventGroup.memberAnnotations {
             
                minLat = min(minLat, annotation.coordinate.latitude)
                maxLat = max(maxLat, annotation.coordinate.latitude)
                minLng = min(minLng, annotation.coordinate.longitude)
                maxLng = max(maxLng, annotation.coordinate.longitude)
                
            }
            
            let midLat = (minLat + maxLat) / 2
            let midLng = (minLng + maxLng) / 2

            let deltaLat = (maxLat - minLat) * 5
            let deltaLng = (maxLng - minLng) * 5
            
            self.zoom(to: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: midLat, longitude: midLng), span: MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLng)), animated: animated)
            
        }
        
    }
    
}
