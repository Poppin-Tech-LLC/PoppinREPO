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
import GeoFire
import Geofirestore

protocol MenuDelegate: class {
    
    func closeMenu(with action: MenuAction?)
    func openMenu()
    
}

final class MapViewController: UIViewController {
    
    public static let defaultMapViewRegionRadius = 3000.0 // 3km
    public static let defaultMapViewCenterLocation = CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619) // DU Campus
        
    private let mapVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let mapHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    private let mapMenuWidth: CGFloat = .getPercentageWidth(percentage: 83)
    
    private var shouldPresentLoginVC: Bool = false
    private var menuIsVisible: Bool = false
    
    let monitor = NWPathMonitor()
    
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    lazy private var userPicture: UIImage = .defaultUserPicture64
    
    var mapPopsicles: [PopsicleAnnotation] = []
    
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
    
    lazy private var mapContainerView: UIView = {
        
        var mapContainerView = UIView(frame: .zero)
        mapContainerView.backgroundColor = .clear
        
        mapContainerView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: mapContainerView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor).isActive = true
        
        mapContainerView.addSubview(mapEdgePanView)
        mapEdgePanView.translatesAutoresizingMaskIntoConstraints = false
        mapEdgePanView.topAnchor.constraint(equalTo: mapContainerView.topAnchor).isActive = true
        mapEdgePanView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor).isActive = true
        mapEdgePanView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor).isActive = true
        mapEdgePanView.widthAnchor.constraint(equalTo: mapContainerView.widthAnchor, multiplier: 0.03).isActive = true
        
        mapContainerView.addSubview(mapDarkOverlayView)
        mapDarkOverlayView.translatesAutoresizingMaskIntoConstraints = false
        mapDarkOverlayView.topAnchor.constraint(equalTo: mapContainerView.topAnchor).isActive = true
        mapDarkOverlayView.bottomAnchor.constraint(equalTo: mapContainerView.bottomAnchor).isActive = true
        mapDarkOverlayView.leadingAnchor.constraint(equalTo: mapContainerView.leadingAnchor).isActive = true
        mapDarkOverlayView.trailingAnchor.constraint(equalTo: mapContainerView.trailingAnchor).isActive = true
        
        mapContainerView.addSubview(mapCreateEventButton)
        mapCreateEventButton.bottomAnchor.constraint(equalTo: mapContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -mapVerticalEdgeInset).isActive = true
        mapCreateEventButton.centerXAnchor.constraint(equalTo: mapContainerView.centerXAnchor).isActive = true
        
        mapContainerView.addSubview(mapTopStackView)
        mapTopStackView.topAnchor.constraint(equalTo: mapContainerView.safeAreaLayoutGuide.topAnchor, constant: mapVerticalEdgeInset).isActive = true
        mapTopStackView.centerXAnchor.constraint(equalTo: mapContainerView.centerXAnchor).isActive = true
        
        mapContainerView.addSubview(mapFiltersView)
        mapFiltersView.translatesAutoresizingMaskIntoConstraints = false
        mapFiltersView.trailingAnchor.constraint(equalTo: mapTopStackView.trailingAnchor).isActive = true
        mapFiltersView.topAnchor.constraint(equalTo: mapTopStackView.bottomAnchor, constant: mapHorizontalEdgeInset).isActive = true
        
        return mapContainerView
        
    }()
    
    lazy private var mapContainerLeadingConstraint: NSLayoutConstraint = {
        
        var mapContainerLeadingConstraint = NSLayoutConstraint(item: mapContainerView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0)
        return mapContainerLeadingConstraint
        
    }()
    
    lazy private var mapEdgePanView: UIView = {
        
        var mapEdgePanView = UIView()
        mapEdgePanView.backgroundColor = .clear
        mapEdgePanView.addGestureRecognizer(mapMenuSlidePanGestureRecognizer)
        return mapEdgePanView
        
    }()
        
    lazy private var mapView: MKMapView = {
        
        var mapView = MKMapView()
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mapViewRegion)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        mapView.setRegion(mapViewRegion, animated: true)
        mapView.delegate = self
        mapView.showsUserLocation = false
        return mapView
        
    }()
    
    lazy private var mapCloseMenuTapGestureRecognizer: UITapGestureRecognizer = {
        
        var mapCloseMenuTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeMenu(sender:)))
        return mapCloseMenuTapGestureRecognizer
        
    }()
    
    lazy private var mapMenuSlidePanGestureRecognizer: UIPanGestureRecognizer = {
     
        var mapMenuSlidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMenuPan(sender:)))
        return mapMenuSlidePanGestureRecognizer
        
    }()
    
    lazy private var mapViewRegion: MKCoordinateRegion = {
        
        let mapViewRegionCenter = userLocation
        let mapViewRegionRadius = MapViewController.defaultMapViewRegionRadius
        
        var mapViewRegion = MKCoordinateRegion(center: mapViewRegionCenter, latitudinalMeters: mapViewRegionRadius, longitudinalMeters: mapViewRegionRadius)
        return mapViewRegion
        
    }()
    
    fileprivate lazy var mapLocationManager: CLLocationManager = {
        
        var mapLocationManager = CLLocationManager()
        mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapLocationManager.distanceFilter = kCLDistanceFilterNone
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

        var mapTopStackView = UIStackView(arrangedSubviews: [mapMenuButton, mapSearchBar, mapRefreshButton])
        mapTopStackView.axis = .horizontal
        mapTopStackView.alignment = .fill
        mapTopStackView.distribution = .fill
        mapTopStackView.spacing = mapHorizontalEdgeInset
        
        mapTopStackView.translatesAutoresizingMaskIntoConstraints = false
        mapTopStackView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
        mapTopStackView.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10.5)).isActive = true
        
        return mapTopStackView
        
    }()
    
    lazy private var mapSearchBar: SearchBar = {
        
        var mapSearchBar = SearchBar()
        mapSearchBar.delegate = self
        return mapSearchBar
        
    }()
    
    lazy private var mapMenuButton: ImageBubbleButton = {
        
        var mapMenuButton = ImageBubbleButton(bouncyButtonImage: userPicture)
        mapMenuButton.addTarget(self, action: #selector(openMenu(sender:)), for: .touchUpInside)
        
        mapMenuButton.translatesAutoresizingMaskIntoConstraints = false
        mapMenuButton.heightAnchor.constraint(equalTo: mapMenuButton.widthAnchor).isActive = true
        
        return mapMenuButton
        
    }()
    
    lazy private var mapMenuViewController: MenuViewController = {
        
        var mapMenuViewController = MenuViewController()
        mapMenuViewController.delegate = self
        return mapMenuViewController
        
    }()
    
    lazy private var menuLeadingConstraint: NSLayoutConstraint = {
        
        var menuLeadingConstraint = NSLayoutConstraint(item: mapMenuViewController.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: -mapMenuWidth)
        return menuLeadingConstraint
        
    }()
    
    lazy private var mapRefreshButton: RefreshButton = {
        
        var mapRefreshButton = RefreshButton()
        
        mapRefreshButton.translatesAutoresizingMaskIntoConstraints = false
        mapRefreshButton.heightAnchor.constraint(equalTo: mapRefreshButton.widthAnchor).isActive = true
        
        return mapRefreshButton
        
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
    
    
    lazy var noInternetView: UIView = {
       let noInternetView = UIView()
        noInternetView.backgroundColor = .clear
        noInternetView.sizeToFit()
        return noInternetView
    }()
    
    lazy var noInternetLabel: UILabel = {
         let noInternetLabel = UILabel()
          noInternetLabel.backgroundColor = .clear
        noInternetLabel.text = "No Internet Connection"
        noInternetLabel.textColor = .mainDARKPURPLE
        noInternetLabel.textAlignment = .center
          noInternetLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
          noInternetLabel.sizeToFit()
        noInternetLabel.alpha = 0.0
          return noInternetLabel
      }()
    
    lazy var noInternetIcon: UIImageView = {
        let purpleWifi = UIImage(systemName: "wifi.exclamationmark")!.withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal)
       let noInternetIcon = UIImageView()
        noInternetIcon.image = .sadPopsicle
        noInternetIcon.contentMode = .scaleAspectFit
        noInternetIcon.alpha = 0.0
        //noInternetIcon.backgroundColor = .clear
        return noInternetIcon
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
    
    @objc private func handleMenuPan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            
            if menuIsVisible, translation.x < 0 {
                
                closeMenu(with: nil)
                
            } else if menuIsVisible, translation.x > 0 {
                
                menuIsVisible = !menuIsVisible
                openMenu()
                
            } else if translation.x > 100.0 {
                
                openMenu()
                
            } else {
                
                menuIsVisible = !menuIsVisible
                closeMenu(with: nil)
                
            }
            
            return
            
        }
        
        if !menuIsVisible, translation.x > 0.0, translation.x <= mapMenuWidth {
            
            let alphaFactorMenuButton = 1 - (translation.x / mapMenuWidth)
            let alphaFactorContainerView = 1.2 - ((translation.x * 0.8) / mapMenuWidth)
            
            mapMenuButton.alpha = alphaFactorMenuButton
            mapContainerView.alpha = alphaFactorContainerView
            
            menuLeadingConstraint.constant = translation.x - mapMenuWidth
            mapContainerLeadingConstraint.constant = translation.x
            
        }
        
        if menuIsVisible, translation.x >= -mapMenuWidth, translation.x < 0.0 {
            
            let alphaFactorMenuButton = translation.x / -mapMenuWidth
            let alphaFactorContainerView = 0.2 + ((0.8 * translation.x) / -mapMenuWidth)
            
            mapMenuButton.alpha = alphaFactorMenuButton
            mapContainerView.alpha = alphaFactorContainerView
            
            menuLeadingConstraint.constant = translation.x
            mapContainerLeadingConstraint.constant = mapMenuWidth + translation.x
            
        }
        
    }
    
    @objc private func closeMenu(sender: BouncyButton) {
        
        closeMenu(with: nil)
        
    }
    
    @objc private func openMenu(sender: BouncyButton) {
        
        openMenu()
        
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
        
        view.backgroundColor = .black
        
        view.addSubview(mapContainerView)
        mapContainerView.translatesAutoresizingMaskIntoConstraints = false
        mapContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapContainerLeadingConstraint.isActive = true
        mapContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        addChild(mapMenuViewController)
        
        view.addSubview(mapMenuViewController.view)
        mapMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        mapMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuLeadingConstraint.isActive = true
        mapMenuViewController.view.widthAnchor.constraint(equalToConstant: mapMenuWidth).isActive = true
        
        mapMenuViewController.didMove(toParent: self)
        
        view.addSubview(noInternetView)
        noInternetView.translatesAutoresizingMaskIntoConstraints = false
        noInternetView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.3).isActive = true
        noInternetView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.6).isActive = true
        noInternetView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //noInternetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        noInternetView.addSubview(noInternetLabel)
        noInternetLabel.translatesAutoresizingMaskIntoConstraints = false
        noInternetLabel.bottomAnchor.constraint(equalTo: noInternetView.bottomAnchor).isActive = true
        noInternetLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.6).isActive = true
        noInternetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        noInternetView.addSubview(noInternetIcon)
        noInternetIcon.translatesAutoresizingMaskIntoConstraints = false
        noInternetIcon.bottomAnchor.constraint(equalTo: noInternetLabel.topAnchor, constant: -view.bounds.height * 0.02).isActive = true
        noInternetIcon.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        noInternetIcon.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        noInternetIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if shouldPresentLoginVC {
            
            view.addSubview(launchScreenOverlayView)
            launchScreenOverlayView.translatesAutoresizingMaskIntoConstraints = false
            launchScreenOverlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            launchScreenOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            launchScreenOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            launchScreenOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
        }
        
        mapLocationManager.requestWhenInUseAuthorization()
        mapLocationManager.startUpdatingLocation()
        
        monitor.pathUpdateHandler = { pathUpdateHandler in
                if pathUpdateHandler.status == .satisfied {
                    DispatchQueue.main.async {
                        self.noInternetIcon.image = .happyPopsicle
                        self.view.layoutIfNeeded()
                        
                        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                            //self.view.layoutIfNeeded()
                            
                            self.noInternetView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height * 0.5)
                            
                            //self.confirmLocView.alpha = 1.0
                            self.noInternetIcon.alpha = 0.0
                            self.noInternetLabel.alpha = 0.0
                            self.mapCreateEventButton.isUserInteractionEnabled = true
                            self.mapCreateEventButton.alpha = 1.0
                            
                            self.view.layoutIfNeeded()
                            
                            
                        })
                    }
                    print("Internet connection is on.")
                } else {
                    DispatchQueue.main.async {
                        
                        if(self.noInternetIcon.alpha != 1.0){
                            // UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                            self.noInternetIcon.image = .sadPopsicle
                        self.noInternetView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height * 0.5)
                        self.view.layoutIfNeeded()
                        
                            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations:{
                            //self.view.layoutIfNeeded()
                            
                            self.noInternetView.transform = .identity
                            
                            //self.confirmLocView.alpha = 1.0
                            self.noInternetIcon.alpha = 1.0
                            self.noInternetLabel.alpha = 1.0
                            self.mapCreateEventButton.isUserInteractionEnabled = false
                            self.mapCreateEventButton.alpha = 0.6
                            
                            self.view.layoutIfNeeded()
                            
                            
                        })
                        }
                    }
                    print("There's no internet connection.")
                }
            }
            
            monitor.start(queue: queue)
            
            getPopsicles()
        
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
    
     public func getPopsicles(){
            
            for annotation in mapView.annotations{
                
                if annotation is PopsicleAnnotation{
                    
                    mapView.removeAnnotation(annotation)
                    
                }
                
            }
            
            mapPopsicles = []
        
        let geoFirestoreRef = Firestore.firestore()

        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef.collection("geolocs"))
        
        let popRef = geoFirestoreRef.collection("currentPopsicles")
        // Query using CLLocation
        let center = CLLocation(latitude: 39.6766, longitude: -104.9619)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        var circleQuery2 = geoFirestore.query(withCenter: center, radius: 3)
        
        let queryHandle = circleQuery2.observe(.documentEntered, with: { (key, location) in
            print("The document with documentID '\(key)' entered the search area and is at location '\(location)'")
            popRef.document(key!).getDocument{ (document, error) in
                if let document = document, document.exists {
    //                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    let data = document.data()
                    print(document.data())
                    
                    let eventStartDate = data!["startDate"] as! String
                    let eventEndDate = data!["endDate"] as! String

                    let eventName = data!["eventName"] as! String
                    let eventCategory = data!["category"] as! String
                    let hashtags = data!["hashtags"] as! String
                    let eventInfo = data!["eventDetails"] as! String
                    let latitude = data!["latitude"] as! CLLocationDegrees
                    let longitude = data!["longitude"] as! CLLocationDegrees
                    
                    let popsicleCategory: PopsicleCategory

                    if (eventCategory == "education") {

                        popsicleCategory = PopsicleCategory.Education



                    } else if (eventCategory == "food") {

                        popsicleCategory = PopsicleCategory.Food


                    } else if (eventCategory == "social") {

                        popsicleCategory = PopsicleCategory.Social


                    } else if (eventCategory == "sports") {

                        popsicleCategory = PopsicleCategory.Sports
                    } else {

                        popsicleCategory = PopsicleCategory.Culture
                    }
                            
                    let popsicleToAdd = PopsicleAnnotation(eventTitle: eventName, eventDetails: eventInfo, eventStartDate: eventStartDate, eventEndDate: eventEndDate, eventCategory: popsicleCategory, eventHashtags: hashtags, eventLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), eventAttendees: [])
                    
                    self.mapPopsicles.append(popsicleToAdd)
                    self.mapView.addAnnotation(popsicleToAdd)
                   // print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            
        }
        })
        }
    
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        
        case .authorizedAlways: manager.startUpdatingLocation()
        case .authorizedWhenInUse: manager.startUpdatingLocation()
        case .denied: manager.requestWhenInUseAuthorization()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        case .restricted: manager.requestWhenInUseAuthorization()
        default: manager.requestWhenInUseAuthorization()
            
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
        
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController(searchTypes: [.Users, .Events], userID: nil, username: nil, shouldActivateSearchBar: true))
        searchNavigationController.modalPresentationStyle = .overFullScreen
        searchNavigationController.modalTransitionStyle = .crossDissolve
        searchNavigationController.setNavigationBarHidden(true, animated: false)
        present(searchNavigationController, animated: true, completion: nil)
        
        return false
        
    }
    
}

extension MapViewController: MenuDelegate {

    func closeMenu(with action: MenuAction?) {
        
        if menuIsVisible {
         
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.menuLeadingConstraint.constant = -self.mapMenuWidth
                self.mapContainerLeadingConstraint.constant = 0
                self.mapContainerView.alpha = 1.0
                self.mapMenuButton.alpha = 1.0
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
                
                self.menuIsVisible = !self.menuIsVisible
                self.mapContainerView.removeGestureRecognizer(self.mapCloseMenuTapGestureRecognizer)
                self.mapView.isUserInteractionEnabled = true
                self.view.removeGestureRecognizer(self.mapMenuSlidePanGestureRecognizer)
                self.mapEdgePanView.addGestureRecognizer(self.mapMenuSlidePanGestureRecognizer)
                
                guard let action = action else { return }
                
                switch action {
                    
                case .YourSchedule: print(action)
                case .YourEvents: print(action)
                case .Subscription: print(action)
                case .FriendGroups: print(action)
                case .Settings: print(action)
                case .Help: print(action)
                case .Logout:
                    
                    do {
                        
                        try Auth.auth().signOut()
                        
                        let loginNavigationController = UINavigationController(rootViewController: StartViewController())
                        loginNavigationController.modalPresentationStyle = .overFullScreen
                        loginNavigationController.modalTransitionStyle = .coverVertical
                        loginNavigationController.setNavigationBarHidden(true, animated: false)
                        
                        self.present(loginNavigationController, animated: true, completion: nil)
                        
                    } catch let error {
                        
                        let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
                        let alertVC = AlertViewController(alertTitle: "Unable to logout", alertMessage: error.localizedDescription, alertButtons: [button1])
                        
                        self.present(alertVC, animated: true, completion: nil)
                    
                    }
                    
                case .Default: print(action)
                    
                }
                
            })
            
        }
        
    }
    
    func openMenu() {
     
        if !menuIsVisible {
        
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.menuLeadingConstraint.constant = 0
                self.mapContainerLeadingConstraint.constant = self.mapMenuWidth
                self.mapContainerView.alpha = 0.2
                self.mapMenuButton.alpha = 0.0
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
            
                self.menuIsVisible = !self.menuIsVisible
                self.mapContainerView.addGestureRecognizer(self.mapCloseMenuTapGestureRecognizer)
                self.mapView.isUserInteractionEnabled = false
                self.mapEdgePanView.removeGestureRecognizer(self.mapMenuSlidePanGestureRecognizer)
                self.view.addGestureRecognizer(self.mapMenuSlidePanGestureRecognizer)
            
            })
            
        }
        
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


