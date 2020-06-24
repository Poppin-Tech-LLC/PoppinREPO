//
//  MapViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/29/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import Network
import Kronos
import Contacts

final class MapViewController: UIViewController {
    
    public static let defaultMapViewRegionRadius = 3000.0 // 3km
    public static let defaultMapViewCenterLocation = CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619) // DU Campus
        
    private let mapVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let mapHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    private var shouldPresentLoginVC: Bool = false
    
    lazy private var userPicture: UIImage = .defaultUserPicture64
    
    lazy private var launchScreenOverlayView: UIView = {
        
        let backgroundImageView = UIImageView(image: UIImage.appBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        
        let poppinLogoImageView = UIImageView(image: UIImage.poppinEventPopsicleIcon256)
        poppinLogoImageView.contentMode = .scaleAspectFit
        
        poppinLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        poppinLogoImageView.heightAnchor.constraint(equalTo: poppinLogoImageView.widthAnchor).isActive = true
        
        var launchScreenOverlayView = UIView()
        launchScreenOverlayView.backgroundColor = .poppinLIGHTGOLD
        
        launchScreenOverlayView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: launchScreenOverlayView.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: launchScreenOverlayView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: launchScreenOverlayView.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: launchScreenOverlayView.bottomAnchor).isActive = true
        
        launchScreenOverlayView.addSubview(poppinLogoImageView)
        poppinLogoImageView.centerXAnchor.constraint(equalTo: launchScreenOverlayView.centerXAnchor).isActive = true
        poppinLogoImageView.bottomAnchor.constraint(equalTo: launchScreenOverlayView.safeAreaLayoutGuide.centerYAnchor).isActive = true
        poppinLogoImageView.widthAnchor.constraint(equalTo: launchScreenOverlayView.widthAnchor, multiplier: 0.33).isActive = true
        
        return launchScreenOverlayView
        
    }()
    
    lazy private var mapView: MKMapView = {
        
        var mapView = MKMapView()
        mapView.addGestureRecognizer(mapMenuOutsideTapGestureRecognizer)
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mapViewRegion)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        mapView.setRegion(mapViewRegion, animated: true)
        mapView.delegate = self
        mapView.showsUserLocation = false
        return mapView
        
    }()
    
    lazy private var mapMenuOutsideTapGestureRecognizer: UITapGestureRecognizer = {
        
        var mapMenuOutsideTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        return mapMenuOutsideTapGestureRecognizer
        
    }()
    
    lazy private var mapViewRegion: MKCoordinateRegion = {
        
        let mapViewRegionCenter = userLocation
        let mapViewRegionRadius = MapViewController.defaultMapViewRegionRadius
        
        var mapViewRegion = MKCoordinateRegion(center: mapViewRegionCenter, latitudinalMeters: mapViewRegionRadius, longitudinalMeters: mapViewRegionRadius)
        return mapViewRegion
        
    }()
    
    fileprivate lazy var mapLocationManager: CLLocationManager = {
        
        var mapLocationManager = CLLocationManager()
        mapLocationManager.requestWhenInUseAuthorization()
        mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapLocationManager.distanceFilter = kCLDistanceFilterNone
        mapLocationManager.startUpdatingLocation()
        mapLocationManager.delegate = self
        return mapLocationManager
        
    }()
    
    lazy private var userLocation: CLLocationCoordinate2D = MapViewController.defaultMapViewCenterLocation
    
    lazy private var mapCreateEventButton: BubbleButton = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 3.3)
        
        var mapCreateEventButton = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .plus, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .bold)).withTintColor(UIColor.mainDARKPURPLE, renderingMode: .alwaysOriginal))
        mapCreateEventButton.backgroundColor = .white
        mapCreateEventButton.contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        mapCreateEventButton.addTarget(self, action: #selector(transitionToCreateEvent), for: .touchUpInside)
        
        mapCreateEventButton.translatesAutoresizingMaskIntoConstraints = false
        mapCreateEventButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 17)).isActive = true
        mapCreateEventButton.heightAnchor.constraint(equalTo: mapCreateEventButton.widthAnchor).isActive = true
        
        return mapCreateEventButton
        
    }()
    
    lazy private var mapTopStackView: UIStackView = {
        
        let mapSearchBar = SearchBar()
        mapSearchBar.delegate = self
        
        let mapMenuButton = ImageBubbleButton(bouncyButtonImage: userPicture)
        mapMenuButton.layer.borderColor = UIColor.white.cgColor
        mapMenuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        mapMenuButton.translatesAutoresizingMaskIntoConstraints = false
        mapMenuButton.heightAnchor.constraint(equalTo: mapMenuButton.widthAnchor).isActive = true
        
        let mapRefreshButton = RefreshButton()
        
        mapRefreshButton.translatesAutoresizingMaskIntoConstraints = false
        mapRefreshButton.heightAnchor.constraint(equalTo: mapRefreshButton.widthAnchor).isActive = true
        
        var mapTopStackView = UIStackView(arrangedSubviews: [mapMenuButton, mapSearchBar, mapRefreshButton])
        mapTopStackView.axis = .horizontal
        mapTopStackView.alignment = .fill
        mapTopStackView.distribution = .fill
        mapTopStackView.spacing = mapHorizontalEdgeInset
        
        mapTopStackView.translatesAutoresizingMaskIntoConstraints = false
        mapTopStackView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
        mapTopStackView.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 11)).isActive = true
        
        return mapTopStackView
        
    }()
    
    lazy private var mapFiltersView: FiltersView = {
        
        var mapFiltersView = FiltersView()
        
        for view in mapFiltersView.filtersStackView.arrangedSubviews {
            
            if let filterButton = view as? PopsicleBubbleButton {
                
                filterButton.addTarget(self, action: #selector(filterPopsicles), for: .touchUpInside)
                
            } else if let showHideFiltersButton = view as? BubbleButton {
                
                showHideFiltersButton.addTarget(self, action: #selector(toggleMapDarkOverlayView), for: .touchUpInside)
                
            }
            
        }
        
        return mapFiltersView
        
    }()
    
    lazy private var mapDarkOverlayView: DarkOverlayView = {
    
        var mapDarkOverlayView = DarkOverlayView()
        
        let darkOverlayViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleFilters))
        let darkOverlayViewSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(toggleFilters))
        mapDarkOverlayView.addGestureRecognizer(darkOverlayViewTapRecognizer)
        mapDarkOverlayView.addGestureRecognizer(darkOverlayViewSwipeRecognizer)
        mapDarkOverlayView.isUserInteractionEnabled = true
        
        mapDarkOverlayView.toggleDarkOverlayView()
        
        return mapDarkOverlayView
    
    }()
    
    @objc func toggleMapDarkOverlayView() {
        
        mapDarkOverlayView.toggleDarkOverlayView()
        
    }
    
    @objc func toggleFilters() {
        
        toggleMapDarkOverlayView()
        mapFiltersView.toggleFilters()
        
    }
    
    @objc func filterPopsicles() {
        
        if mapDarkOverlayView.isVisible {
            
            toggleMapDarkOverlayView()
            
        }
        
    }
    
    @objc func transitionToCreateEvent() {
        
        if mapDarkOverlayView.isVisible {
            
            toggleFilters()
            
        }
        
        // For trial purposes, present the new create event view controller modally
        // later, need to change to using navigation controller
        //self.modalPresentationStyle = .overFullScreen
        self.present(NewCreateEventViewController(), animated: true, completion: nil)
        
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        
        
    }
    
    @objc func openMenu() {
        
        
        
    }
    
    @objc func zoomToUserLocation(_ sender: UIButton) {
        
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 50.0, longitudinalMeters: 50.0)
        
        MKMapView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.mapView.setRegion(region, animated: true)
            
        }, completion: nil)
        
    }
    
    init(shouldShowLoginVC: Bool) {
        
        super.init(nibName: nil, bundle: nil)
        
        shouldPresentLoginVC = shouldShowLoginVC
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .mainCREAM
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(mapDarkOverlayView)
        mapDarkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        mapDarkOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapDarkOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapDarkOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapDarkOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(mapCreateEventButton)
        mapCreateEventButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -mapVerticalEdgeInset).isActive = true
        mapCreateEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        view.addSubview(mapTopStackView)
        mapTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: mapVerticalEdgeInset).isActive = true
        mapTopStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(mapFiltersView)
        mapFiltersView.translatesAutoresizingMaskIntoConstraints = false
        mapFiltersView.trailingAnchor.constraint(equalTo: mapTopStackView.trailingAnchor).isActive = true
        mapFiltersView.topAnchor.constraint(equalTo: mapTopStackView.bottomAnchor, constant: mapHorizontalEdgeInset).isActive = true
        
        if shouldPresentLoginVC {
            
            view.addSubview(launchScreenOverlayView)
            launchScreenOverlayView.translatesAutoresizingMaskIntoConstraints = false
            launchScreenOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            launchScreenOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            launchScreenOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            launchScreenOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(animated)
        
        if shouldPresentLoginVC {
            
            let loginNavigationController = UINavigationController(rootViewController: StartViewController())
            loginNavigationController.modalPresentationStyle = .overFullScreen
            loginNavigationController.modalTransitionStyle = .coverVertical
            loginNavigationController.setNavigationBarHidden(true, animated: false)
            
            present(loginNavigationController, animated: false, completion: {
                
                self.launchScreenOverlayView.removeFromSuperview()
                self.shouldPresentLoginVC = false
            
            })
            
        }
        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse {
            
            manager.requestLocation()
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            
            userLocation = location.coordinate
            
            if !mapView.visibleMapRect.contains(MKMapPoint(userLocation)) {
                
                mapViewRegion.center = userLocation
                mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mapViewRegion)
                
            }
            
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if let error = error as? CLError, error.code == .denied {
            
            print("ERROR: LocationManager failed to get user's location.")
            
        }
        
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        if !mapView.showsUserLocation {
        
            mapView.showsUserLocation = true
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
       /*
        if placingPin {
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.eventLocationDraggingNotification.alpha = 0.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        }
        */
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      /*
        if placingPin {
            
            let centerCoordinate = mapView.centerCoordinate
            
            let centerLocation = CLLocation(latitude: centerCoordinate.latitude - 0.0001, longitude: centerCoordinate.longitude)
            
            lookUpAddress(from: centerLocation) { (address) in
                
                if (address != nil) {
                    
                    self.eventLocationConfirmationAddress.text = address
                    
                    if (!self.confirmationViewIsVisible) {
                        
                        self.eventLocationConfirmationContainerView.transform = CGAffineTransform(translationX: 0, y: +self.eventLocationConfirmationContainerView.frame.height)
                        self.eventLocationConfirmationContainerView.alpha = 1.0
                        self.view.layoutIfNeeded()
                        
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                            
                            self.eventLocationConfirmationContainerView.transform = .identity
                            self.view.layoutIfNeeded()
                            
                        }, completion: nil)
                        
                        self.confirmationViewIsVisible = true
                        
                    }
                    
                } else {
                    
                    print("Error: mainMapView was unable to retrieve the address from the current center location.")
                    
                }
                
            }
            
        }*/
        
    }
    
    private func lookUpAddress(from location: CLLocation, completionHandler: @escaping (String?) -> Void ) {
        
        let geocoder = CLGeocoder()
        let postalAddressFormatter = CNPostalAddressFormatter()
        postalAddressFormatter.style = .mailingAddress
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            if error == nil, let addressLocation = placemarks?[0], let address = addressLocation.postalAddress {
                
                completionHandler(postalAddressFormatter.string(from: address))
                
            } else {
                
                print("ERROR: CLGeocoder was unable to retrieve a location.")
                completionHandler(nil)
                
            }
            
        })
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            
            var userLocationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: UserLocationAnnotationView.defaultUserLocationAnnotationViewReuseIdentifier)
            
            if userLocationAnnotationView == nil {
                
                userLocationAnnotationView = UserLocationAnnotationView(annotation: annotation, reuseIdentifier: UserLocationAnnotationView.defaultUserLocationAnnotationViewReuseIdentifier)
                
            }
            
            (userLocationAnnotationView as! UserLocationAnnotationView).setUserLocationIcon(icon: nil)
            
            return userLocationAnnotationView
            
        } else if annotation is PopsicleAnnotation {
            
            var popsicleAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PopsicleAnnotationView.defaultPopsicleAnnotationViewReuseIdentifier)
            
            if popsicleAnnotationView == nil {
                
                popsicleAnnotationView = PopsicleAnnotationView(annotation: annotation, reuseIdentifier: PopsicleAnnotationView.defaultPopsicleAnnotationViewReuseIdentifier)
                
            }
            
            return popsicleAnnotationView
            
        } else if annotation is MKClusterAnnotation {
            
            var popsicleGroupAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PopsicleGroupAnnotationView.defaultPopsicleGroupAnnotationViewReuseIdentifier)
            
            if popsicleGroupAnnotationView == nil {
                
                popsicleGroupAnnotationView = PopsicleGroupAnnotationView(annotation: annotation, reuseIdentifier: PopsicleGroupAnnotationView.defaultPopsicleGroupAnnotationViewReuseIdentifier)
                
            }
            
            (popsicleGroupAnnotationView as! PopsicleGroupAnnotationView).setGroupCount(count: (annotation as! MKClusterAnnotation).memberAnnotations.count)
            
            return popsicleGroupAnnotationView
            
        }
        
        return nil
        
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for annotationView in views {
            
            if annotationView is PopsicleAnnotationView, let annotationCoordinates = annotationView.annotation?.coordinate, mapView.visibleMapRect.contains(MKMapPoint(annotationCoordinates)) {
                
                let endFrame:CGRect = annotationView.frame
                
                annotationView.frame = CGRect(origin: CGPoint(x: annotationView.frame.origin.x, y: annotationView.frame.origin.y - self.view.frame.size.height), size: CGSize(width: annotationView.frame.size.width, height: annotationView.frame.size.height))
                
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations:{() in
                    
                    annotationView.frame = endFrame
                    
                    self.view.layoutIfNeeded()
                    
                }, completion: nil)
                
            } else if annotationView is PopsicleGroupAnnotationView || annotationView is UserLocationAnnotationView, let annotationCoordinates = annotationView.annotation?.coordinate, mapView.visibleMapRect.contains(MKMapPoint(annotationCoordinates)) {
                
                annotationView.alpha = 0
                annotationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                               options: .curveEaseOut, animations: {
                                
                                annotationView.transform = .identity
                                annotationView.alpha = 1
                                
                }, completion: nil)
                
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let selectedPopsicle = view.annotation, selectedPopsicle is PopsicleAnnotation {
            
            print("Popsicle selected.")
            
        } else if let selectedPopsicle = view.annotation, selectedPopsicle is MKUserLocation {
            
            print("User location selected.")
            
        }
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if mapDarkOverlayView.isVisible {
            
            toggleFilters()
            
        }
        
        let searchVC = SearchViewController()
        //searchVC.transitioningDelegate = self
        searchVC.searchType = "searchUsers"
        self.present(searchVC, animated: true, completion: nil)
        //  self.present(searchVC.searchController, animated: true, completion: nil)

        
        return false
        
    }
    
}

/*extension MapViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return ViewControllerFadeTransitionAnimator(presenting: true)
        
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return ViewControllerFadeTransitionAnimator(presenting: false)
        
    }
}*/


