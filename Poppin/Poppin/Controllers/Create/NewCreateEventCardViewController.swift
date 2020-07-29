//
//  NewCreateEventCardViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 6/6/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GeoFire
import FirebaseFirestore
import Geofirestore
import SwiftDate

class NewCreateEventCardViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate {
    
    var storage: Storage = Storage.storage()
    
    let uid = Auth.auth().currentUser!.uid
    
    var startDateFormatted: String?
    
    var endDateFormatted: String?
    
    var hashtagTyped: Bool?
    
    var hashtagCount: Int?
    
    var address: String?
    
    var location: CLLocationCoordinate2D?
    
    var popsicleImage: UIImage?
    
    var category: String?
    
    let db = Firestore.firestore()
    
    private let createEventVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let createEventHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let createEventInnerInset: CGFloat = .getPercentageWidth(percentage: 7)
    
    lazy private var eventData: PopsicleAnnotationData = PopsicleAnnotationData()
    
    lazy private var backgroundGradientColors: [CGColor] = {
        
        var backgroundGradientColors: [CGColor] = []
        
        for color in eventData.eventCategory.getPopsicleCategoryGradientColors() {
            
            backgroundGradientColors.append(color.cgColor)
            
        }
        
        return backgroundGradientColors
        
    }()
    
    lazy private var cardContainerView: UIView = {
        
        let borderView = PopsicleBorderView(with: UIColor(cgColor: backgroundGradientColors[1]))
        
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.heightAnchor.constraint(equalToConstant: eventNameTextView.intrinsicContentSize.height*0.85).isActive = true
        
        let backButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .medium)).withTintColor(UIColor.white))
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let editEventLocationButtonView = UIView()
        editEventLocationButtonView.backgroundColor = .clear
        
        editEventLocationButtonView.addSubview(editEventLocationButton)
        editEventLocationButton.translatesAutoresizingMaskIntoConstraints = false
        editEventLocationButton.centerXAnchor.constraint(equalTo: editEventLocationButtonView.centerXAnchor).isActive = true
        editEventLocationButton.topAnchor.constraint(equalTo: editEventLocationButtonView.topAnchor).isActive = true
        editEventLocationButton.bottomAnchor.constraint(equalTo: editEventLocationButtonView.bottomAnchor).isActive = true
        
        let cardContainerStackView = UIStackView(arrangedSubviews: [eventNameTextView, borderView, eventDateTextField, eventLocationView, editEventLocationButtonView, eventDetailsTextView, eventHashtagsView])
        cardContainerStackView.axis = .vertical
        cardContainerStackView.alignment = .fill
        cardContainerStackView.distribution = .fill
        cardContainerStackView.spacing = createEventVerticalEdgeInset
        cardContainerStackView.setCustomSpacing(createEventVerticalEdgeInset*0.45, after: eventNameTextView)
        cardContainerStackView.setCustomSpacing(createEventVerticalEdgeInset*0.45, after: borderView)
        cardContainerStackView.setCustomSpacing(0, after: eventLocationView)
        
        let cardContainerScrollView = UIScrollView()
        cardContainerScrollView.alwaysBounceVertical = true
        cardContainerScrollView.showsVerticalScrollIndicator = false
        cardContainerScrollView.keyboardDismissMode = .onDrag
        cardContainerScrollView.contentInset = UIEdgeInsets(top: createEventVerticalEdgeInset, left: 0, bottom: (createEventVerticalEdgeInset*2) + .getPercentageWidth(percentage: 3) + createButton.titleLabel!.intrinsicContentSize.height, right: 0)
        
        cardContainerScrollView.addSubview(cardContainerStackView)
        cardContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerStackView.topAnchor.constraint(equalTo: cardContainerScrollView.topAnchor).isActive = true
        cardContainerStackView.bottomAnchor.constraint(equalTo: cardContainerScrollView.bottomAnchor).isActive = true
        cardContainerStackView.leadingAnchor.constraint(equalTo: cardContainerScrollView.leadingAnchor).isActive = true
        cardContainerStackView.trailingAnchor.constraint(equalTo: cardContainerScrollView.trailingAnchor).isActive = true
        cardContainerStackView.widthAnchor.constraint(equalTo: cardContainerScrollView.widthAnchor).isActive = true
        
        var cardContainerView = UIView()
        cardContainerView.clipsToBounds = true
        cardContainerView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        cardContainerView.backgroundColor = UIColor(cgColor: backgroundGradientColors[0])
        
        cardContainerView.addSubview(cardContainerScrollView)
        cardContainerScrollView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerScrollView.topAnchor.constraint(equalTo: cardContainerView.topAnchor).isActive = true
        cardContainerScrollView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: createEventHorizontalEdgeInset).isActive = true
        cardContainerScrollView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -createEventHorizontalEdgeInset).isActive = true
        cardContainerScrollView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor).isActive = true
        
        cardContainerView.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -createEventHorizontalEdgeInset).isActive = true
        createButton.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor).isActive = true
        
        cardContainerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.heightAnchor.constraint(equalTo: createButton.heightAnchor, multiplier: 0.75).isActive = true
        backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor).isActive = true
        backButton.centerYAnchor.constraint(equalTo: createButton.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: createEventHorizontalEdgeInset).isActive = true
        
        return cardContainerView
        
    }()
    
    lazy private(set) var eventNameTextView: UITextView = {
        
        var eventNameTextView = UITextView()
        eventNameTextView.backgroundColor = .clear
        eventNameTextView.textColor = .white
        eventNameTextView.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        
        if eventData.eventTitle == "" {
            
            eventNameTextView.text = "Event Title"
            
        } else {
            
            eventNameTextView.text = eventData.eventTitle
            
        }
        
        eventNameTextView.textContainerInset.bottom = 0.0
        eventNameTextView.textContainerInset.top = 4.0
        eventNameTextView.delegate = self
        eventNameTextView.isScrollEnabled = false
        eventNameTextView.sizeToFit()
        eventNameTextView.textAlignment = .center
        eventNameTextView.autocapitalizationType = .none
        eventNameTextView.autocorrectionType = .no
        return eventNameTextView
        
    }()
    
    lazy private(set) var eventDateTextField: UITextField = {
        
        var eventDateTextField = UITextField()
        eventDateTextField.delegate = self
        eventDateTextField.font = UIFont.dynamicFont(with: "Octarine-Light", style: .callout)
        eventDateTextField.backgroundColor = .clear
        eventDateTextField.textColor = .white
        eventDateTextField.textAlignment = .center
        eventDateTextField.attributedPlaceholder = NSAttributedString(string: Date.getFormattedDateInterval(start: eventData.eventStartDate, end: eventData.eventEndDate) ?? "Event Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .callout)])
        return eventDateTextField
        
    }()
    
    lazy private var eventLocationView: UIView = {
        
        let verticalInset: CGFloat = .getPercentageWidth(percentage: 2.0)
        let horizontalInset: CGFloat = .getPercentageWidth(percentage: 1.5)
        
        var eventLocationView = UIView()
        eventLocationView.backgroundColor = UIColor(cgColor: backgroundGradientColors[1])
        eventLocationView.clipsToBounds = true
        eventLocationView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        
        eventLocationView.addSubview(eventLocationLabel)
        eventLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        eventLocationLabel.topAnchor.constraint(equalTo: eventLocationView.topAnchor, constant: verticalInset).isActive = true
        eventLocationLabel.leadingAnchor.constraint(equalTo: eventLocationView.leadingAnchor, constant: horizontalInset).isActive = true
        eventLocationLabel.trailingAnchor.constraint(equalTo: eventLocationView.trailingAnchor, constant: -horizontalInset).isActive = true
        
        eventLocationView.addSubview(eventLocationMapView)
        eventLocationMapView.translatesAutoresizingMaskIntoConstraints = false
        eventLocationMapView.topAnchor.constraint(equalTo: eventLocationLabel.bottomAnchor, constant: verticalInset).isActive = true
        eventLocationMapView.leadingAnchor.constraint(equalTo: eventLocationLabel.leadingAnchor).isActive = true
        eventLocationMapView.trailingAnchor.constraint(equalTo: eventLocationLabel.trailingAnchor).isActive = true
        eventLocationMapView.bottomAnchor.constraint(equalTo: eventLocationView.bottomAnchor, constant: -verticalInset*0.75).isActive = true
        
        return eventLocationView
        
    }()
    
    lazy private(set) var eventLocationLabel: UILabel = {
        
        var eventLocationLabel = UILabel()
        eventLocationLabel.textAlignment = .center
        eventLocationLabel.backgroundColor = .clear
        eventLocationLabel.numberOfLines = 1
        //eventLocationLabel.sizeToFit()
        eventLocationLabel.textColor = .white
        eventLocationLabel.text = "Event Location"
        eventLocationLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        return eventLocationLabel
        
    }()
    
    lazy private(set) var eventLocationMapView: MKMapView = {
        
        let eventLocationMapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventData.eventLocation.latitude + 0.00015, longitude: eventData.eventLocation.longitude), latitudinalMeters: 100.0, longitudinalMeters: 100.0)
        
        var eventLocationMapView = MKMapView()
        eventLocationMapView.isPitchEnabled = false
        eventLocationMapView.isRotateEnabled = false
        eventLocationMapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: eventLocationMapRegion)
        eventLocationMapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        eventLocationMapView.setRegion(eventLocationMapRegion, animated: true)
        eventLocationMapView.delegate = self
        eventLocationMapView.showsUserLocation = false
        eventLocationMapView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        eventLocationMapView.layer.masksToBounds = true
        
        eventLocationMapView.translatesAutoresizingMaskIntoConstraints = false
        eventLocationMapView.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 25)).isActive = true
        
        eventLocationMapView.addAnnotation(PopsicleAnnotation(popsicleAnnotationData: eventData))
        
        return eventLocationMapView
        
    }()
    
    lazy private(set) var editEventLocationButton: UIButton = {
        
        let innerInset: CGFloat = .getPercentageWidth(percentage: 1.8)
        
        var editEventLocationButton = UIButton()
        editEventLocationButton.setTitle("Edit", for: .normal)
        editEventLocationButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        editEventLocationButton.backgroundColor = UIColor(cgColor: backgroundGradientColors[1])
        editEventLocationButton.setTitleColor(.white, for: .normal)
        editEventLocationButton.titleLabel?.textAlignment = .center
        editEventLocationButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset*2, bottom: innerInset, right: innerInset*2)
        editEventLocationButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        editEventLocationButton.addTarget(self, action: #selector(editEventLocation), for: .touchUpInside)
        editEventLocationButton.isUserInteractionEnabled = true
        return editEventLocationButton
        
    }()
    
    lazy private(set) var eventDetailsTextView: UITextView = {
        
        var eventDetailsTextView = UITextView()
        eventDetailsTextView.backgroundColor = .clear
        eventDetailsTextView.textColor = .white
        eventDetailsTextView.font = .dynamicFont(with: "Octarine-Light", style: .headline)
        eventDetailsTextView.text = "Add Details"
        eventDetailsTextView.textContainerInset = .zero
        eventDetailsTextView.delegate = self
        eventDetailsTextView.isScrollEnabled = false
        eventDetailsTextView.sizeToFit()
        eventDetailsTextView.textAlignment = .center
        eventDetailsTextView.autocapitalizationType = .none
        eventDetailsTextView.autocorrectionType = .no
        return eventDetailsTextView
        
    }()
    
    lazy private(set) var eventHashtagsView : UITextView = {
        
        var eventHashtagsView = UITextView()
        eventHashtagsView.backgroundColor = UIColor(cgColor: backgroundGradientColors[1])
        eventHashtagsView.textColor = .white
        eventHashtagsView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        eventHashtagsView.text = "Add Hashtags"
        eventHashtagsView.sizeToFit()
        eventHashtagsView.delegate = self
        eventHashtagsView.textAlignment = .center
        eventHashtagsView.layer.cornerRadius = 10
        eventHashtagsView.isScrollEnabled = false
        eventHashtagsView.autocapitalizationType = .none
        eventHashtagsView.autocorrectionType = .no
        return eventHashtagsView
        
    }()
    
    lazy private(set) var createButton: BouncyButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 1.5)
        
        var createButton = BouncyButton(bouncyButtonImage: nil)
        createButton.backgroundColor = .white
        createButton.setTitle("Create", for: .normal)
        createButton.titleLabel?.textAlignment = .center
        createButton.setTitleColor(UIColor(cgColor: backgroundGradientColors[1]), for: .normal)
        createButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        createButton.contentEdgeInsets = UIEdgeInsets(top: innerEdgeInset, left: innerEdgeInset*2, bottom: innerEdgeInset, right: innerEdgeInset*2)
        createButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        createButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        return createButton
        
    }()
    
    lazy private var startDatePicker: UIDatePicker = {
        
        var d = UIDatePicker()
        
        d.minimumDate = Date()
        print(backgroundGradientColors.count)
        d.setValue(UIColor(cgColor: backgroundGradientColors[1]), forKeyPath: "textColor")
        
        return d
        
    }()
    
    lazy private var endDatePicker: UIDatePicker = {
        
        var d = UIDatePicker()
        
        d.minimumDate = Date()
        print(backgroundGradientColors.count)
        d.setValue(UIColor(cgColor: backgroundGradientColors[1]), forKeyPath: "textColor")
        
        return d
        
    }()
    
    lazy var startDateTextField: UITextField = {
        let startDateTextField = UITextField()
        startDateTextField.delegate = self
        
        let dateToolbar = UIToolbar()
        
        dateToolbar.sizeToFit()
        
        let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneStartActionDate))
        
        let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        dateToolbar.setItems([dateFlexSpace,dateDoneButton], animated: true)
        
        startDateTextField.inputAccessoryView = dateToolbar
        startDateTextField.font = UIFont.dynamicFont(with: "Octarine-LightOblique", style: .subheadline)
        startDateTextField.backgroundColor = .clear
        startDateTextField.textColor = .white
        startDateTextField.inputView = startDatePicker
        startDateTextField.attributedPlaceholder = NSAttributedString(string: "Start Date", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-LightOblique", style: .title3), NSAttributedString.Key.foregroundColor : UIColor.white])
        return startDateTextField
    }()
    
    lazy var endDateTextField: UITextField = {
        let endDateTextField = UITextField()
        endDateTextField.delegate = self
        
        let dateToolbar = UIToolbar()
        
        dateToolbar.sizeToFit()
        
        let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEndActionDate))
        
        let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        dateToolbar.setItems([dateFlexSpace,dateDoneButton], animated: true)
        
        endDateTextField.inputAccessoryView = dateToolbar
        endDateTextField.font = UIFont.dynamicFont(with: "Octarine-LightOblique", style: .subheadline)
        endDateTextField.backgroundColor = .clear
        endDateTextField.textColor = .white
        endDateTextField.textAlignment = .right
        
        //endDateTextField.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        endDateTextField.inputView = endDatePicker
        endDateTextField.attributedPlaceholder = NSAttributedString(string: "End Date", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-LightOblique", style: .title3), NSAttributedString.Key.foregroundColor : UIColor.white])
        return endDateTextField
    }()
    
    lazy var detailsButton: UILabel = {
        let detailsButton = UILabel()
        //detailsButton.text = "Add details..."
        //detailsButton.setTitle("Add details...", for: .normal)
        detailsButton.font = .dynamicFont(with: "Octarine-Light", style: .title3)
        //detailsButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        detailsButton.textColor = .white
        //detailsButton.titleLabel?.textAlignment = .left
        //detailsButton.contentVerticalAlignment = .top
        detailsButton.textAlignment = .left
        detailsButton.numberOfLines = 5;
        detailsButton.sizeToFit()
        return detailsButton
    }()
    
    @objc func detailsWritten(_ notification: Notification) {
        guard let text = notification.userInfo?["text"] as? String else { return }
        print ("text: \(text)")
        detailsButton.text = text
        detailsButton.textColor = .white
        
        if(eventNameTextView.text == "Add Title" || eventHashtagsView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || eventLocationLabel.text == "Location"){
                   createButton.isUserInteractionEnabled = false
                   createButton.alpha = 0.6
               }else{
                   createButton.isUserInteractionEnabled = true
                   createButton.alpha = 1.0
               }
    }
    
    @objc func locationSelected(_ notification: Notification) {
        guard let street = notification.userInfo?["street"] as? String else { return }
        guard let address = notification.userInfo?["address"] as? String else { return }
        guard let location = notification.userInfo?["location"] as? CLLocationCoordinate2D else { return }
        
        self.address = address
        self.location = location
        
        let allAnnotations = eventLocationMapView.annotations
        eventLocationMapView.removeAnnotations(allAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        eventLocationMapView.setRegion(region, animated: true)
        eventLocationMapView.addAnnotation(annotation)
        
        eventLocationLabel.text = street
        eventLocationLabel.textColor = .white
        
        if(eventNameTextView.text == "Add Title" || eventHashtagsView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || eventLocationLabel.text == "Location"){
            createButton.isUserInteractionEnabled = false
            createButton.alpha = 0.6
        }else{
            createButton.isUserInteractionEnabled = true
            createButton.alpha = 1.0
        }
    }
    
    init(eventData: PopsicleAnnotationData) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.eventData = eventData
        configureController()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        configureController()
        
    }
    
    private func configureController() {
        
        eventData.eventLocation.lookUpLocationAddress { [weak self] (address) in
            
            guard let self = self else { return }
            
            if address != nil { self.eventLocationLabel.text = address }
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hashtagTyped = true
        hashtagCount = 0
        
        setPopsicleImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.detailsWritten(_:)), name: .detailsWritten, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationSelected(_:)), name: .locationSelected, object: nil)
        
        view.backgroundColor = UIColor(cgColor: backgroundGradientColors[1])
        transitioningDelegate = self
        
        view.addSubview(cardContainerView)
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: createEventVerticalEdgeInset).isActive = true
        cardContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -createEventVerticalEdgeInset).isActive = true
        cardContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: createEventHorizontalEdgeInset).isActive = true
        cardContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -createEventHorizontalEdgeInset).isActive = true
        
        cardContainerView.addSubview(startDateTextField)
        startDateTextField.translatesAutoresizingMaskIntoConstraints = false
        startDateTextField.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: cardContainerView.bounds.width * 0.02).isActive = true
        //startDateTextField.topAnchor.constraint(equalTo: purplePopsicle.bottomAnchor, constant: cardContainerView.bounds.height * 0).isActive = true
        startDateTextField.widthAnchor.constraint(equalToConstant: cardContainerView.bounds.width * 0.43).isActive = true
        startDateTextField.heightAnchor.constraint(equalToConstant: cardContainerView.bounds.height * 0.04).isActive = true
        
        cardContainerView.addSubview(endDateTextField)
        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        endDateTextField.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -cardContainerView.bounds.width * 0.02).isActive = true
        //endDateTextField.topAnchor.constraint(equalTo: purplePopsicle.bottomAnchor, constant: cardContainerView.bounds.height * 0).isActive = true
        endDateTextField.widthAnchor.constraint(equalToConstant: cardContainerView.bounds.width * 0.43).isActive = true
        endDateTextField.heightAnchor.constraint(equalToConstant: cardContainerView.bounds.height * 0.04).isActive = true
        
        cardContainerView.addSubview(detailsButton)
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        detailsButton.centerXAnchor.constraint(equalTo: cardContainerView.centerXAnchor).isActive = true
        //detailsButton.topAnchor.constraint(equalTo: purpleView.bottomAnchor, constant: cardContainerView.bounds.height * 0.03).isActive = true
        detailsButton.widthAnchor.constraint(equalToConstant: cardContainerView.bounds.width * 0.8).isActive = true
        
    }
    
    @objc func goBack() {
        
        let textInfo = ["location": eventLocationLabel.text!, "eventName": eventNameTextView.text!, "eventInfo": detailsButton.text!, "eventStartDate": startDateTextField.text!, "eventEndDate": endDateTextField.text!, "hashtags": eventHashtagsView.text!, "coordinates": location ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)] as [String : Any]
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: .switchCategory, object: nil, userInfo: textInfo)
        
        
    }
    
    @objc private func toWriteDetails() {
        
        let vc = EventDetailsInputViewController(with: UIColor(cgColor: backgroundGradientColors[0]), text: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical

        /*if(detailsButton.text == "Add details..."){
            vc.eventDetailsTextView.text = ""
        }else{
            vc.eventDetailsTextView.text = detailsButton.text
        }*/
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc private func editEventLocation() {
        
        let editEventLocationVC = EditLocationViewController()
        
        if location != nil {
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location!
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            editEventLocationVC.mainMapView.setRegion(region, animated: true)
            editEventLocationVC.mainMapView.addAnnotation(annotation)
            
        }
        
        editEventLocationVC.modalPresentationStyle = .overCurrentContext
        editEventLocationVC.popsicleImage = popsicleImage
        editEventLocationVC.transitioningDelegate = self
        self.present(editEventLocationVC, animated: true, completion: nil)
        
    }
    
    private func getStartDateFromPicker() {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM d, h:mm a"
        
        startDateTextField.text = formatter.string(from: startDatePicker.date)
        
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        startDateFormatted = formatter.string(from: startDatePicker.date)
        
        //endDatePicker.minimumDate = startDatePicker.date + 60
        
        
        
        if(endDateTextField.text != "End Date"){
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm"
            let startDate = dateFormatter.date(from:startDateFormatted!)
            let endDate = dateFormatter.date(from:endDateFormatted!)
            
            
            if(endDate! <= startDate!){
                endDateTextField.text = "End Date"
                
            }
        }
    }
    
    private func getEndDateFromPicker() {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM d, h:mm a"
        
        endDateTextField.text = formatter.string(from: endDatePicker.date)
        
        
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        endDateFormatted = formatter.string(from: endDatePicker.date)
        
    }
    
    @objc func doneStartActionDate() {
        
        getStartDateFromPicker()
        
        view.endEditing(true)
        
    }
    
    @objc func doneEndActionDate() {
        
        getEndDateFromPicker()
        
        view.endEditing(true)
        
    }
    
    // It is called when text field is inactive
    /*func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        
        if(eventNameTextView.text == "Add Title" || hashtagTextView.text == "Add Hashtags" || eventDetailsTextView.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || locationLabel.text == "Location"){
                   createButton.isUserInteractionEnabled = false
                   createButton.alpha = 0.6
               }else{
                   createButton.isUserInteractionEnabled = true
                   createButton.alpha = 1.0
               }
    }*/
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView == eventDetailsTextView {
            
            toWriteDetails()
            
            return false
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        
        if textView == eventDetailsTextView {
            
            if eventDetailsTextView.text == "Add Details", eventDetailsTextView.isFirstResponder {
                
                eventDetailsTextView.textAlignment = .left
                eventDetailsTextView.text = ""
            }
            
            /*let newPosition = eventDetailsTextView.endOfDocument
            eventDetailsTextView.selectedTextRange = eventDetailsTextView.textRange(from: newPosition, to: newPosition)*/
            
        }
        
        if(textView == eventNameTextView){
            
            if  eventNameTextView.text == "Add Title" && eventNameTextView.isFirstResponder {
                eventNameTextView.text = ""
                //eventNameTextView.textColor = .white
            }
            /*let newPosition = eventNameTextView.endOfDocument
            eventNameTextView.selectedTextRange = eventNameTextView.textRange(from: newPosition, to: newPosition)*/
        }
        
        if(textView == eventHashtagsView){
            if  eventHashtagsView.text == "Add Hashtags" && eventHashtagsView.isFirstResponder {
                eventHashtagsView.text = "#"
                hashtagCount = 1
                //eventNameTextView.textColor = .white
            }
            let newPosition = eventHashtagsView.endOfDocument
            eventHashtagsView.selectedTextRange = eventHashtagsView.textRange(from: newPosition, to: newPosition)
        }
        
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        print("ENNDDDEEDDD")
        if(eventNameTextView.text == "Add Title" || eventHashtagsView.text == "Add Hashtags" || eventDetailsTextView.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || eventLocationLabel.text == "Location"){
            createButton.isUserInteractionEnabled = false
            createButton.alpha = 0.6
        }else{
            createButton.isUserInteractionEnabled = true
            createButton.alpha = 1.0
        }
        
        if(textView == eventDetailsTextView){
            
            if eventDetailsTextView.text.isEmpty || eventDetailsTextView.text == "" {
                
                eventDetailsTextView.textAlignment = .center
                eventDetailsTextView.text = "Add Details"
                
            }
            
        }
        
        if(textView == eventNameTextView){
            if eventNameTextView.text.isEmpty || eventNameTextView.text == "" {
                eventNameTextView.text = "Add Title"
            }
            
            
        }
        
        if(textView == eventHashtagsView){
            if eventHashtagsView.text.isEmpty || eventHashtagsView.text == "#" {
                eventHashtagsView.textColor = .white
                eventHashtagsView.text = "Add Hashtags"
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(textView == eventNameTextView){
            if text == "\n" {
                eventNameTextView.resignFirstResponder()
                if(eventNameTextView.text == "Add Title" || eventHashtagsView.text == "Add Hashtags" || eventDetailsTextView.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || eventLocationLabel.text == "Location"){
                    createButton.isUserInteractionEnabled = false
                    createButton.alpha = 0.6
                }else{
                    createButton.isUserInteractionEnabled = true
                    createButton.alpha = 1.0
                }
                return false
            }

            let newText = (eventNameTextView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            return numberOfChars <= 30

        }
        
        if textView == eventDetailsTextView {
            
            if text == "\n" {
                eventDetailsTextView.resignFirstResponder()
                if(eventNameTextView.text == "Add Title" || eventHashtagsView.text == "Add Hashtags" || eventDetailsTextView.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || eventLocationLabel.text == "Location"){
                    createButton.isUserInteractionEnabled = false
                    createButton.alpha = 0.6
                }else{
                    createButton.isUserInteractionEnabled = true
                    createButton.alpha = 1.0
                }
                return false
            }

            let newText = (eventDetailsTextView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            return numberOfChars <= 250
            
        }
        
        if(textView == eventHashtagsView){
            
            let newText = (eventHashtagsView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            
            let regex = try! NSRegularExpression(pattern: "\\s")
            let numberOfWhitespaceCharacters = regex.numberOfMatches(in: newText, range: NSRange(location: 0, length: newText.utf16.count))
            
            let substring = (eventHashtagsView.text as NSString).substring(with: range)
            
            if(eventHashtagsView.text == ""){
                hashtagTyped = false
                eventHashtagsView.text = "#"
            }
            
            if text == "\n" {
                eventHashtagsView.resignFirstResponder()
                if(eventNameTextView.text == "Add Title" || eventHashtagsView.text == "Add Hashtags" || eventDetailsTextView.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || eventLocationLabel.text == "Location"){
                    createButton.isUserInteractionEnabled = false
                    createButton.alpha = 0.6
                }else{
                    createButton.isUserInteractionEnabled = true
                    createButton.alpha = 1.0
                }
                return false
            }
            
            if(substring == "#"){
                eventHashtagsView.text.removeLast()
                //return true
            }
            
            
            if(!hashtagTyped!){
                if(text == " "){
                    return false
                }else{
                    hashtagTyped = true
                    return numberOfWhitespaceCharacters < 5 && numberOfChars < 60
                }
            }
            if(text == " " && numberOfWhitespaceCharacters < 5){
                hashtagTyped = false
                hashtagCount! += 1
                eventHashtagsView.text = eventHashtagsView.text + " #"
                return false
            }
            
            print(substring)
            
            return numberOfWhitespaceCharacters < 5 && numberOfChars < 60
            
        }
        
        return false
    }
    
    func setPopsicleImage(){
        if(backgroundGradientColors[0] == UIColor.cultureLIGHTPURPLE.cgColor){
            popsicleImage = .culturePopsicleIcon128
            category = "culture"
        }
        
        if(backgroundGradientColors[0] == UIColor.educationLIGHTBLUE.cgColor){
            popsicleImage = .educationPopsicleIcon128
            category = "education"
        }
        
        if(backgroundGradientColors[0] == UIColor.socialLIGHTRED.cgColor){
            popsicleImage = .socialPopsicleIcon128
            category = "social"
        }
        
        if(backgroundGradientColors[0] == UIColor.foodLIGHTORANGE.cgColor){
            popsicleImage = .foodPopsicleIcon128
            category = "food"
        }
        
        if(backgroundGradientColors[0] == UIColor.sportsLIGHTGREEN.cgColor){
            popsicleImage = .sportsPopsicleIcon128
            category = "sports"
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("HEREEE 2")
        
        if let popsicleAnnotation = annotation as? PopsicleAnnotation {
            
            if let popsicleAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PopsicleAnnotationView.defaultPopsicleAnnotationViewReuseIdentifier) as? PopsicleAnnotationView {
                
                popsicleAnnotationView.setPopsicleAnnotation(popsicleAnnotation: popsicleAnnotation)
                return popsicleAnnotationView
                
            } else {
                
                let popsicleAnnotationView = PopsicleAnnotationView(annotation: popsicleAnnotation, reuseIdentifier: PopsicleAnnotationView.defaultPopsicleAnnotationViewReuseIdentifier)
                popsicleAnnotationView.setPopsicleAnnotation(popsicleAnnotation: popsicleAnnotation)
                return popsicleAnnotationView
                
            }
            
        } else {
            
            return nil
            
        }
        
    }
    
    @objc func createEvent() {
 //       let ref = Database.database().reference()
        
      //  let geoFireRef = Database.database().reference().child("Geolocs")
        
//        let geoFire = GeoFire(firebaseRef: geoFireRef)
//
//        let identifier = UUID()
        
         let geoFirestore = GeoFirestore(collectionRef: db.collection("geolocs"))
        
        var ref2: DocumentReference? = nil
        ref2 = db.collection("currentPopsicles").addDocument(data: [
            "longitude": location?.longitude as Any,
            "latitude": location?.latitude as Any,
            "eventName": eventNameTextView.text!,
            "eventDetails": detailsButton.text!,
            "startDate": startDateFormatted!,
            "endDate": endDateFormatted!,
            "hashtags": eventHashtagsView.text!,
            "createdBy": uid ,
            "category": category!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref2!.documentID)")
                geoFirestore.setLocation(location: CLLocation(latitude: self.location!.latitude, longitude: self.location!.longitude), forDocumentWithID: ref2!.documentID) { (error) in
                    if let error = error {
                        print("An error occured: \(error)")
                    } else {
                        print("Saved location successfully!")
                    }
                }
            }
        }

        
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/latitude").setValue(location?.latitude)
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/longitude").setValue(mainMapView.centerCoordinate.longitude)
//
//            geoFire.setLocation(CLLocation(latitude: mainMapView.centerCoordinate.latitude , longitude: mainMapView.centerCoordinate.longitude), forKey: (identifier.uuidString))
//
//
//            // let en = newPopsicle.popsicleData.eventName
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/eventName").setValue(eventNameTextView.text)
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/eventInfo").setValue(detailsButton.text)
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/eventStartDate").setValue(startDateFormatted)
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/eventEndDate").setValue(endDateFormatted)
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/eventCategory").setValue(category)
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/hashtags").setValue(hashtagTextView.text)
//
//            ref.child("currentPopsicles/\(identifier.uuidString)/createdBy").setValue(uid)
            
           // let textInfo = ["location": location!, "eventName": eventNameTextView.text!, "eventInfo": detailsButton.text!, "eventStartDate": startDateFormatted!, "eventEndDate": endDateFormatted!, "eventCategory": category!, "hashtags": hashtagTextView.text!, "createdBy": uid ] as [String : Any]
            
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: .eventCreated, object: nil)
            
        
        
    }
    
    
    
    
}

extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
extension Notification.Name {
    public static let myNotificationKey = Notification.Name(rawValue: "myNotificationKey")
}

extension NewCreateEventCardViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            return FlipPresentAnimationController(originFrame: cardContainerView.frame)
            
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            
            return FlipDismissAnimationController(destinationFrame: cardContainerView.frame)
            
    }
}
