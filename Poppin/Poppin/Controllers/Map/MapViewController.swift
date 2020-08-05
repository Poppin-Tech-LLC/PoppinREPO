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
import CoreData
import SwiftDate

protocol MenuDelegate: class {
    
    func closeMenu(with action: MenuAction?)
    func openMenu()
    
}

protocol ActivityDelegate: class {
    
    func closeAV()
    func openAV()
    
}

final class MapViewController: UIViewController {
    
    public static var defaultMapViewRegionRadius = 3000.0 // 3km
    public static var defaultMapViewCenterLocation = CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619) // DU Campus
        
    private let mapVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let mapHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    private let mapMenuWidth: CGFloat = .getPercentageWidth(percentage: 83)
    private let avWidth: CGFloat = .getPercentageWidth(percentage: 90)
    
    private var shouldPresentLoginVC: Bool = false
    private var menuIsVisible: Bool = false
    private var avIsVisible: Bool = false
    
    let monitor = NWPathMonitor()
    
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    lazy private var userPicture: UIImage = .defaultUserPicture64
    
    var mapPopsicles: [PopsicleAnnotation] = []
    
    public static var username: String = ""
    
    public static var uid: String = ""
    
    public static var bio: String = ""
    
    public static var fullName: String = ""
    
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
    
    lazy private var mapCloseTapGestureRecognizer: UITapGestureRecognizer = {
        
        var mapCloseTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeMenu(sender:)))
        mapCloseTapGestureRecognizer.addTarget(self, action: #selector(closeAV(sender:)))
        return mapCloseTapGestureRecognizer
        
    }()

    lazy private var mapMenuSlidePanGestureRecognizer: UIPanGestureRecognizer = {
        
        var mapMenuSlidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleMenuPan(sender:)))
        
        return mapMenuSlidePanGestureRecognizer
        
    }()
    
    lazy private var mapView: MKMapView = {
        
        var mapView = MKMapView()
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mapViewRegion)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius*0.07, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        mapView.setRegion(mapViewRegion, animated: true)
        mapView.delegate = self
        mapView.showsUserLocation = false
        return mapView
        
    }()
    
    lazy private var mapAVSlidePanGestureRecognizer: UIPanGestureRecognizer = {
        var mapAVSlidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleAVPan(sender:)))
        
        return mapAVSlidePanGestureRecognizer
        
    }()
    
    lazy private var mapViewRegion: MKCoordinateRegion = {
        
        let mapViewRegionCenter = MapViewController.defaultMapViewCenterLocation
        let mapViewRegionRadius = MapViewController.defaultMapViewRegionRadius
        
        print("LOCAATIOONN")
        print(userLocation)
        
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

        var mapTopStackView = UIStackView(arrangedSubviews: [mapMenuButton, mapSearchBar, mapAVButton])
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
        mapMenuViewController.username = MapViewController.username
        mapMenuViewController.fullName = MapViewController.fullName
        return mapMenuViewController
        
    }()
    
    lazy private var menuLeadingConstraint: NSLayoutConstraint = {
        
        var menuLeadingConstraint = NSLayoutConstraint(item: mapMenuViewController.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: -mapMenuWidth)
        return menuLeadingConstraint
        
    }()
    
    lazy private var mapAVButton: ActivityButton = {
        
        var mapAVButton = ActivityButton()
        
        mapAVButton.addTarget(self, action: #selector(openAV(sender:)), for: .touchUpInside)
        
        mapAVButton.increaseCounter(by: self.mapAVController.activities.count)
        
        mapAVButton.translatesAutoresizingMaskIntoConstraints = false
        mapAVButton.heightAnchor.constraint(equalTo: mapAVButton.widthAnchor).isActive = true
        
        return mapAVButton
        
    }()
    
    lazy private var mapAVController: ActivityViewController = {
           
           var mapAVController = ActivityViewController()
           mapAVController.delegate = self
           return mapAVController
           
    }()
       
    lazy private var avLeadingConstraint: NSLayoutConstraint = {
           
        var avLeadingConstraint = NSLayoutConstraint(item: mapAVController.view!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0)
        return avLeadingConstraint
           
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
        
        let createEventNavigationController = UINavigationController(rootViewController: CreateEventFirstSectionViewController()/*NewCreateEventViewController(userLocation: userLocation)*/)
        createEventNavigationController.modalPresentationStyle = .overFullScreen
        createEventNavigationController.modalTransitionStyle = .coverVertical
        createEventNavigationController.setNavigationBarHidden(true, animated: false)
        self.present(createEventNavigationController, animated: true, completion: nil)
        
    }
    
    @objc private func handleMenuPan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            
            if menuIsVisible, !avIsVisible, translation.x < 0 {
                closeMenu(with: nil)
            } else if !menuIsVisible, !avIsVisible, translation.x > 0 {
                openMenu()
            }
            
            return
            
        }
        
        if !menuIsVisible, translation.x > 0.0, translation.x <= mapMenuWidth, !avIsVisible {
            
            let alphaFactorMenuButton = 1 - (translation.x / mapMenuWidth)
            let alphaFactorContainerView = 1.2 - ((translation.x * 0.8) / mapMenuWidth)
            
            mapMenuButton.alpha = alphaFactorMenuButton
            mapContainerView.alpha = alphaFactorContainerView
            
            menuLeadingConstraint.constant = translation.x - mapMenuWidth
            mapContainerLeadingConstraint.constant = translation.x
            
        }
        
        if menuIsVisible, translation.x >= -mapMenuWidth, translation.x < 0.0, !avIsVisible {
            
            let alphaFactorMenuButton = translation.x / -mapMenuWidth
            let alphaFactorContainerView = 0.2 + ((0.8 * translation.x) / -mapMenuWidth)
            
            mapMenuButton.alpha = alphaFactorMenuButton
            mapContainerView.alpha = alphaFactorContainerView
            
            menuLeadingConstraint.constant = translation.x
            mapContainerLeadingConstraint.constant = mapMenuWidth + translation.x
            
        }
        
    }
    
    @objc private func handleAVPan(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        
        if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            
            if avIsVisible, !menuIsVisible, translation.x > 0 {
                closeAV()
            } else if !avIsVisible, !menuIsVisible, translation.x < 0 {
                openAV()
            }
            
            return
            
        }
        
        if !avIsVisible, translation.x < 0.0, translation.x >= -avWidth, !menuIsVisible {
            
            let alphaFactorAVButton = 1 - (translation.x / -avWidth)
            let alphaFactorContainerView = 1.2 - ((translation.x * 0.8) / -avWidth)
            
            mapAVButton.alpha = alphaFactorAVButton
            mapContainerView.alpha = alphaFactorContainerView
            
            avLeadingConstraint.constant = translation.x
            mapContainerLeadingConstraint.constant = translation.x
            
        }
        
        if avIsVisible, translation.x > 0.0, translation.x <= avWidth, !menuIsVisible {
            
            let alphaFactorAVButton = translation.x / avWidth
            let alphaFactorContainerView = 0.2 + ((0.8 * translation.x) / avWidth)
            
            mapAVButton.alpha = alphaFactorAVButton
            mapContainerView.alpha = alphaFactorContainerView
            
            avLeadingConstraint.constant = translation.x - avWidth
            mapContainerLeadingConstraint.constant = translation.x - avWidth
            
        }
        
    }
    
    @objc private func closeMenu(sender: BouncyButton) {
        
        closeMenu(with: nil)

    }
    
    @objc private func openMenu(sender: BouncyButton) {
        
        openMenu()
        
    }
    @objc private func closeAV(sender: BouncyButton) {
        
        closeAV()
        
    }
    
    @objc private func openAV(sender: BouncyButton) {
        
        openAV()
        
    }
    
    @objc private func handleMapTap(sender: UITapGestureRecognizer? = nil) {
        
        mapView.isZoomEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.mapView.isZoomEnabled = true }
        
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
    
    @objc func editedProfile(_ notification: Notification) {
        let user = DataController.getUser()
        
        MapViewController.uid = user.value(forKey: "uid") as? String ?? ""
        MapViewController.username = user.value(forKey: "username") as? String ?? ""
        MapViewController.bio = user.value(forKey: "bio") as? String ?? ""
        MapViewController.fullName = user.value(forKey: "fullName") as? String ?? ""
        
        mapMenuViewController.username = MapViewController.username
        mapMenuViewController.fullName = MapViewController.fullName
      
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        print("SAVED USER")

        let user = DataController.getUser()
        
        MapViewController.uid = user.value(forKey: "uid") as? String ?? ""
        MapViewController.username = user.value(forKey: "username") as? String ?? ""
        MapViewController.bio = user.value(forKey: "bio") as? String ?? ""
        MapViewController.fullName = user.value(forKey: "fullName") as? String ?? ""
        
        mapMenuViewController.username = MapViewController.username
        mapMenuViewController.fullName = MapViewController.fullName
 
        let radius = user.value(forKey: "radius") as? Double ?? 0.0
        let longitude = user.value(forKey: "longitude") as? Double ?? 0.0
        let latitude = user.value(forKey: "latitude") as? Double ?? 0.0
        
        MapViewController.defaultMapViewRegionRadius = radius * 1000
        MapViewController.defaultMapViewCenterLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        mapViewRegion = MKCoordinateRegion(center: MapViewController.defaultMapViewCenterLocation, latitudinalMeters: MapViewController.defaultMapViewRegionRadius, longitudinalMeters: MapViewController.defaultMapViewRegionRadius)
        mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mapViewRegion)
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: radius * 1000)
        mapView.setRegion(mapViewRegion, animated: true)
        
        getPopsicles()
        
    }
    
    private func setLocation() {
        if(Auth.auth().currentUser != nil){
        let user = DataController.getUser()
            
        MapViewController.uid = user.value(forKey: "uid") as? String ?? ""
        MapViewController.username = user.value(forKey: "username") as? String ?? ""
        MapViewController.bio = user.value(forKey: "bio") as? String ?? ""
        MapViewController.fullName = user.value(forKey: "fullName") as? String ?? ""
        
        let radius = user.value(forKey: "radius") as? Double ?? 0.0
        let longitude = user.value(forKey: "longitude") as? Double ?? 0.0
        let latitude = user.value(forKey: "latitude") as? Double ?? 0.0
                
        MapViewController.defaultMapViewRegionRadius = radius * 1000
        MapViewController.defaultMapViewCenterLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        print("LOADDEDDD")
        
        setLocation()
    
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: .userSignedIn, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(editedProfile(_:)), name: .editedProfileMap, object: nil)
        
        let mapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        mapGestureRecognizer.numberOfTapsRequired = 1
        mapGestureRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(mapGestureRecognizer)
        
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
        
        addChild(mapAVController)
        
        view.addSubview(mapAVController.view)
        mapAVController.view.translatesAutoresizingMaskIntoConstraints = false
        mapAVController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapAVController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        avLeadingConstraint.isActive = true
        mapAVController.view.widthAnchor.constraint(equalToConstant: avWidth).isActive = true
        
        mapAVController.didMove(toParent: self)
        
        mapAVButton.increaseCounter(by: self.mapAVController.activities.count)
        
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
        
        print("Getting popsicles")
        
        mapView.removeAnnotations(mapPopsicles)
        mapPopsicles = []
        
        let geoFirestoreRef = Firestore.firestore()
        
        let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef.collection("geolocs"))
        
        let popRef = geoFirestoreRef.collection("currentPopsicles")
        // Query using CLLocation
        let center = CLLocation(latitude: MapViewController.defaultMapViewCenterLocation.latitude, longitude: MapViewController.defaultMapViewCenterLocation.longitude)

        let circleQuery2 = geoFirestore.query(withCenter: center, radius: 3)
        
        let group = DispatchGroup()
        
        _ = circleQuery2.observe(.documentEntered, with: { (key, location) in
            print("The document with documentID '\(String(describing: key))' entered the search area and is at location '\(String(describing: location))'")
            
            group.enter()
            popRef.document(key!).getDocument{ (document, error) in
                if let document = document, document.exists {
                    
                    let data = document.data()
                    
                    let eventStartDate: Date = DateInRegion(data!["startDate"] as! String, format: "yyyy-MM-dd HH:mm", region: .current)!.date
                    let eventEndDate: Date = DateInRegion(data!["endDate"] as! String, format: "yyyy-MM-dd HH:mm", region: .current)!.date
                    
                    let eventName = data!["eventName"] as! String
                    let eventCategory = data!["category"] as! String
                    let hashtags = data!["hashtags"] as! String
                    let eventInfo = data!["eventDetails"] as! String
                    let latitude = data!["latitude"] as! CLLocationDegrees
                    let longitude = data!["longitude"] as! CLLocationDegrees
                    
                    let popsicleCategory: EventCategory
                    
                    if (eventCategory == "education") {
                        
                        popsicleCategory = .Education
                        
                        
                        
                    } else if (eventCategory == "food") {
                        
                        popsicleCategory = .Food
                        
                        
                    } else if (eventCategory == "social") {
                        
                        popsicleCategory = .Social
                        
                        
                    } else if (eventCategory == "sports") {
                        
                        popsicleCategory = .Sports
                    } else {
                        
                        popsicleCategory = .Culture
                    }
                    
                    let popsicleToAdd = PopsicleAnnotation(eventTitle: eventName, eventDetails: eventInfo, eventStartDate: eventStartDate, eventEndDate: eventEndDate, eventCategory: popsicleCategory, eventHashtags: hashtags, eventLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), eventAttendees: [])
                    
                    self.mapPopsicles.append(popsicleToAdd)
                    
                    // print("Document data: \(dataDescription)")
                    
                } else {
                    print("Document does not exist")
                }
                
                group.leave()
                
            }
            
            group.notify(queue: .main) {
             
                self.mapView.addAnnotations(self.mapPopsicles)
                
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
               // mapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mapViewRegion)
                
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
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
        
        if let userAnnotation = annotation as? MKUserLocation {
            
            if let userLocationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: UserLocationAnnotationView.defaultUserLocationAnnotationViewReuseIdentifier) as? UserLocationAnnotationView {
             
                userLocationAnnotationView.setUserLocationIcon(icon: nil)
                return userLocationAnnotationView
                
            } else {
             
                let userLocationAnnotationView = UserLocationAnnotationView(annotation: userAnnotation, reuseIdentifier: UserLocationAnnotationView.defaultUserLocationAnnotationViewReuseIdentifier)
                userLocationAnnotationView.setUserLocationIcon(icon: nil)
                return userLocationAnnotationView
                
            }
            
        } else if let popsicleAnnotation = annotation as? PopsicleAnnotation {
            
            if let popsicleAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PopsicleAnnotationView.defaultPopsicleAnnotationViewReuseIdentifier) as? PopsicleAnnotationView {
                
                popsicleAnnotationView.setPopsicleAnnotation(popsicleAnnotation: popsicleAnnotation)
                return popsicleAnnotationView
                
            } else {
                
                let popsicleAnnotationView = PopsicleAnnotationView(annotation: popsicleAnnotation, reuseIdentifier: PopsicleAnnotationView.defaultPopsicleAnnotationViewReuseIdentifier)
                popsicleAnnotationView.setPopsicleAnnotation(popsicleAnnotation: popsicleAnnotation)
                return popsicleAnnotationView
                
            }
            
        } else if let popsicleGroupAnnotation = annotation as? MKClusterAnnotation {
            
            if let popsicleGroupAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PopsicleGroupAnnotationView.defaultPopsicleGroupAnnotationViewReuseIdentifier) as? PopsicleGroupAnnotationView {
             
                popsicleGroupAnnotationView.setGroupCount(count: popsicleGroupAnnotation.memberAnnotations.count)
                return popsicleGroupAnnotationView
                
            } else {
             
                let popsicleGroupAnnotationView = PopsicleGroupAnnotationView(annotation: popsicleGroupAnnotation, reuseIdentifier: PopsicleGroupAnnotationView.defaultPopsicleGroupAnnotationViewReuseIdentifier)
                popsicleGroupAnnotationView.setGroupCount(count: popsicleGroupAnnotation.memberAnnotations.count)
                return popsicleGroupAnnotationView
                
            }
            
        }
        
        return nil
        
    }
    
    /*func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
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
        
    }*/
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.isZoomEnabled = true
        
        if let selectedPopsicle = view.annotation, selectedPopsicle is PopsicleAnnotation {
            
            print("Popsicle selected.")
            
            let bottomSheetVC = PopsiclePopupViewController()
            
            //bottomSheetVC.pops = (selectedPopsicle as! PopsicleAnnotation).popsicleAnnotationData.eventCategory
            bottomSheetVC.popsicleName = (selectedPopsicle as! PopsicleAnnotation).popsicleAnnotationData.eventTitle
            bottomSheetVC.popsicleStartDate = (selectedPopsicle as! PopsicleAnnotation).popsicleAnnotationData.eventStartDate.toString(.standard)
            bottomSheetVC.popsicleEndDate = (selectedPopsicle as! PopsicleAnnotation).popsicleAnnotationData.eventEndDate.toString(.standard)
            bottomSheetVC.popsicleDetails = (selectedPopsicle as! PopsicleAnnotation).popsicleAnnotationData.eventDetails!
            bottomSheetVC.popsicleAddy = (selectedPopsicle as! PopsicleAnnotation).popsicleAnnotationData.eventLocation
//            bottomSheetVC.popsicleHashtags = (selectedPopsicle as! PopsicleAnnotation).popsicleAnnotationData.eventHashtags
            
            self.addChild(bottomSheetVC)
            self.view.addSubview(bottomSheetVC.view)
            bottomSheetVC.didMove(toParent: self)
            
            let height = self.view.frame.height
            let width  = self.view.frame.width
            bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
            
        } else if let selectedPopsicle = view.annotation, selectedPopsicle is MKUserLocation {
            
            print("User location selected.")
            
        } else if let selectedAnnotation = view.annotation as? MKClusterAnnotation {
         
            var minLat = selectedAnnotation.memberAnnotations[0].coordinate.latitude
            var maxLat = selectedAnnotation.memberAnnotations[0].coordinate.latitude
            var minLng = selectedAnnotation.memberAnnotations[0].coordinate.longitude
            var maxLng = selectedAnnotation.memberAnnotations[0].coordinate.longitude
            
            for annotation in selectedAnnotation.memberAnnotations {
             
                minLat = min(minLat, annotation.coordinate.latitude)
                maxLat = max(maxLat, annotation.coordinate.latitude)
                minLng = min(minLng, annotation.coordinate.longitude)
                maxLng = max(maxLng, annotation.coordinate.longitude)
                
            }
            
            let midLat = (minLat + maxLat) / 2
            let midLng = (minLng + maxLng) / 2

            let deltaLat = (maxLat - minLat) * 5
            let deltaLng = (maxLng - minLng) * 5
            
            let expandedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: midLat, longitude: midLng), span: MKCoordinateSpan(latitudeDelta: deltaLat, longitudeDelta: deltaLng))
            
            MKMapView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                
                self.mapView.setRegion(expandedRegion, animated: true)
                
            }, completion: nil)
            
        }
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        
    }
    
}

extension MapViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if mapDarkOverlayView.isVisible {
            
            toggleFilters()
            
        }
        
        let searchNavigationController = UINavigationController(rootViewController: SearchViewController(searchTypes: [.Users, .Events], startIndex: 0, userID: nil, username: nil, shouldActivateSearchBar: true, alwaysShowsCancelButton: true))
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
                
                self.view.removeGestureRecognizer(self.mapMenuSlidePanGestureRecognizer)
                
                self.menuIsVisible = false
                self.mapContainerView.removeGestureRecognizer(self.mapCloseTapGestureRecognizer)
                self.mapView.isUserInteractionEnabled = true
                
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
                case .Profile: print(action)
                case .Default: print(action)
                    
                }
                
            })
            
        }
        
    }
    
    func openMenu() {
     
        if(!menuIsVisible && !avIsVisible) {
        
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.menuLeadingConstraint.constant = 0
                self.mapContainerLeadingConstraint.constant = self.mapMenuWidth
                self.mapContainerView.alpha = 0.2
                self.mapMenuButton.alpha = 0.0
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
            
                self.view.addGestureRecognizer(self.mapMenuSlidePanGestureRecognizer)
                
                self.menuIsVisible = true
                self.mapContainerView.addGestureRecognizer(self.mapCloseTapGestureRecognizer)
                self.mapView.isUserInteractionEnabled = false
            
            })
            
        }
        
    }
        
}

extension MapViewController: ActivityDelegate {

    func closeAV() {
        
        if avIsVisible {
         
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.avLeadingConstraint.constant = 0
                self.mapContainerLeadingConstraint.constant = 0
                self.mapContainerView.alpha = 1.0
                self.mapAVButton.alpha = 1.0
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
                
                self.view.removeGestureRecognizer(self.mapAVSlidePanGestureRecognizer)
                
                self.avIsVisible = false
                self.mapContainerView.removeGestureRecognizer(self.mapCloseTapGestureRecognizer)
                self.mapView.isUserInteractionEnabled = true
                print("av not visible")
                
            })
            
        }
            
    }
    
    func openAV() {
        
        if(!avIsVisible && !menuIsVisible){
            
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.avLeadingConstraint.constant = -(self.avWidth)
                self.mapContainerLeadingConstraint.constant = -(self.avWidth)
                self.mapContainerView.alpha = 0.2
                self.mapAVButton.alpha = 0.0
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
                
                self.view.addGestureRecognizer(self.mapAVSlidePanGestureRecognizer)
            
                self.avIsVisible = true
                self.mapContainerView.addGestureRecognizer(self.mapCloseTapGestureRecognizer)
                self.mapView.isUserInteractionEnabled = false
                print("av is visible")
                
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


