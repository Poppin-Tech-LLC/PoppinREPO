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

class NewCreateEventCardViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate {
    
    var storage: Storage?
    
    let uid = Auth.auth().currentUser!.uid
    
    var startDateFormatted: String?
    
    var endDateFormatted: String?
    
    var hashtagTyped: Bool?
    
    var hashtagCount: Int?
    
    var address: String?
    
    var location: CLLocationCoordinate2D?
    
    var popsicleImage: UIImage?
    
    var category: String?
    
    var backgroundGradientColors: [CGColor]?
    
    let db = Firestore.firestore()
    
   

    
    
    lazy private var startDatePicker: UIDatePicker = {
        
        var d = UIDatePicker()
        
        d.minimumDate = Date()
        print(backgroundGradientColors!.count)
        d.setValue(UIColor(cgColor: backgroundGradientColors![1]), forKeyPath: "textColor")
        
        return d
        
    }()
    
    lazy private var endDatePicker: UIDatePicker = {
        
        var d = UIDatePicker()
        
        d.minimumDate = Date()
        print(backgroundGradientColors!.count)
        d.setValue(UIColor(cgColor: backgroundGradientColors![1]), forKeyPath: "textColor")
        
        return d
        
    }()
    
    lazy var mainMapView: MKMapView = {
        
        var mainMapView = MKMapView()
        mainMapView.isPitchEnabled = false
        mainMapView.isRotateEnabled = false
        mainMapView.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: mainMapViewRegion)
        mainMapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        mainMapView.setRegion(mainMapViewRegion, animated: true)
        mainMapView.delegate = self
        mainMapView.showsUserLocation = false
        var maskedCorners = CACornerMask()
        mainMapView.layer.cornerRadius = 20 - backgroundView.bounds.width * 0.015
        maskedCorners.insert(.layerMaxXMaxYCorner)
        maskedCorners.insert(.layerMinXMaxYCorner)
        mainMapView.layer.maskedCorners = maskedCorners
        return mainMapView
        
    }()
    
    lazy private var purpleMapView: UIView = {
        let purpleMapView = UIView()
        purpleMapView.backgroundColor = UIColor(cgColor: backgroundGradientColors![1])
        purpleMapView.layer.cornerRadius = 20
        return purpleMapView
    }()
    
    lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textAlignment = .center
        locationLabel.backgroundColor = .clear
        locationLabel.textColor = .white
        //locationLabel.text = "Location"
        locationLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        return locationLabel
    }()
    
    lazy var editLocationButton: BouncyButton = {
        let editLocationButton = BouncyButton(bouncyButtonImage: nil)
        editLocationButton.setTitle("Edit", for: .normal)
        editLocationButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        editLocationButton.backgroundColor = UIColor(cgColor: backgroundGradientColors![1])
        editLocationButton.setTitleColor(.white, for: .normal)
        editLocationButton.titleLabel?.textAlignment = .center
        editLocationButton.layer.cornerRadius = 15
        var maskedCorners = CACornerMask()
        
        maskedCorners.insert(.layerMaxXMaxYCorner)
        maskedCorners.insert(.layerMinXMaxYCorner)
        editLocationButton.layer.maskedCorners = maskedCorners
        
        editLocationButton.addTarget(self, action: #selector(editLocation), for: .touchUpInside)
        editLocationButton.isUserInteractionEnabled = true
        return editLocationButton
    }()
    
    lazy private var mainUserLocation: CLLocationCoordinate2D = MapViewController.defaultMapViewCenterLocation
    
    lazy private var mainMapViewRegion: MKCoordinateRegion = {
        
        let mainMapViewRegionCenter = mainUserLocation
        let mainMapViewRegionRadius = MapViewController.defaultMapViewRegionRadius
        
        var mainMapViewRegion = MKCoordinateRegion(center: mainMapViewRegionCenter, latitudinalMeters: mainMapViewRegionRadius, longitudinalMeters: mainMapViewRegionRadius)
        return mainMapViewRegion
        
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
    
    lazy var purplePopsicle: UIImageView = {
        let purplePopsicle = UIImageView()
        purplePopsicle.image = UIImage.culturePopsicleIcon256.withTintColor(UIColor(cgColor: backgroundGradientColors![1]))
        purplePopsicle.contentMode = .scaleAspectFit
        return purplePopsicle
    }()
    
    lazy var purpleLineOne: UIView = {
        let purpleLineOne = UIView()
        purpleLineOne.backgroundColor = UIColor(cgColor: backgroundGradientColors![1])
        return purpleLineOne
    }()
    
    lazy var purpleLineTwo: UIView = {
        let purpleLineTwo = UIView()
        purpleLineTwo.backgroundColor = UIColor(cgColor: backgroundGradientColors![1])
        return purpleLineTwo
    }()
    
    
    lazy var eventNameTextField: UITextView = {
        let eventNameTextField = UITextView()
        eventNameTextField.backgroundColor = .clear
        eventNameTextField.textColor = .white
        eventNameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        eventNameTextField.delegate = self
        eventNameTextField.textAlignment = .center
        eventNameTextField.autocapitalizationType = .none
        eventNameTextField.autocorrectionType = .no
        return eventNameTextField
    }()
    
    
    lazy var createButton: BouncyButton = {
        
        var cb = BouncyButton(bouncyButtonImage: nil)
        cb.backgroundColor = .white
        cb.setTitle("Create", for: .normal)
        cb.titleLabel?.textAlignment = .center
        cb.setTitleColor(UIColor(cgColor: backgroundGradientColors![1]), for: .normal)
        cb.titleLabel?.font = UIFont(name: "Octarine-Bold", size: 18)
        cb.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 2), left: .getPercentageWidth(percentage: 2), bottom: .getPercentageWidth(percentage: 2), right: .getPercentageWidth(percentage: 2))
        
        cb.addShadowAndRoundCorners(cornerRadius: 16)
        
//        cb.isUserInteractionEnabled = false
//        cb.alpha = 0.6
        
        cb.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        
        return cb
        
    }()
    
    lazy var backButton: ImageBubbleButton = {
        let purpleArrow = UIImage(systemName: "arrow.left")!.withTintColor(.white)
        let backButton = ImageBubbleButton(bouncyButtonImage: purpleArrow)
        backButton.contentMode = .scaleToFill
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
    
    
    lazy var purpleView: UIView = {
        let purpleView = UIView()
        purpleView.backgroundColor = UIColor(cgColor: backgroundGradientColors![1])
        purpleView.layer.cornerRadius = 20
        purpleView.isUserInteractionEnabled = true
        return purpleView
    }()
    
    lazy var userImage: UIImageView = {
        var userImage = UIImageView()
        userImage.contentMode = .scaleToFill
        userImage.frame = CGRect(x: 0, y: 0, width: purpleView.bounds.height * 0.7, height:  purpleView.bounds.height * 0.7)
        userImage.widthAnchor.constraint(equalToConstant: purpleView.bounds.height * 0.7).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: purpleView.bounds.height * 0.7).isActive = true
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.bounds.height/2
        userImage.isUserInteractionEnabled = true
        
        storage = Storage.storage()
        let uid = Auth.auth().currentUser!.uid
        
        
        let reference = (self.storage?.reference().child("images/\(uid)/profilepic.jpg"))!
        let placeholderImage = UIImage.defaultUserPicture256
        userImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        return userImage
    }()
    
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = .dynamicFont(with: "Octarine-Light", style: .title3)
        usernameLabel.textColor = UIColor.white
        return usernameLabel
    }()
    
    lazy var createdByLabel: UILabel = {
        let createdByLabel = UILabel()
        createdByLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
        createdByLabel.text = "Created by:"
        createdByLabel.textColor = UIColor.white
        return createdByLabel
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toWriteDetails(tapGestureRecognizer:)))
        detailsButton.isUserInteractionEnabled = true
        detailsButton.addGestureRecognizer(tapGestureRecognizer)
        detailsButton.backgroundColor = .clear
        detailsButton.isUserInteractionEnabled = true
        return detailsButton
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 30
        backgroundView.backgroundColor = UIColor(cgColor: backgroundGradientColors![0])
        return backgroundView
    }()
    
    lazy var hashtagTextView: UITextView = {
        let hashtagTextView = UITextView()
        hashtagTextView.backgroundColor = UIColor(cgColor: backgroundGradientColors![1])
        hashtagTextView.textColor = .white
        hashtagTextView.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
        //hashtagTextView.text = "Add Hashtags"
        hashtagTextView.sizeToFit()
        //eventNameTextField.attributedPlaceholder = NSAttributedString(string: "Add Title", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Bold", style: .title1), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        hashtagTextView.delegate = self
        hashtagTextView.textAlignment = .left
        hashtagTextView.layer.cornerRadius = 10
        hashtagTextView.isScrollEnabled = false
        
        //eventNameTextField.lineBreakMode = NSLineBreakMode.byWordWrapping
        //eventNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: eventNameTextField.intrinsicContentSize.height))
        //eventNameTextField.leftViewMode = .always
        //eventNameTextField.clearButtonMode = .whileEditing
        //eventNameTextField.returnKeyType = .next
        hashtagTextView.autocapitalizationType = .none
        hashtagTextView.autocorrectionType = .no
        //eventNameTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        return hashtagTextView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        /* FOR TRIAL PURPOSES */
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    
    @objc func detailsWritten(_ notification: Notification) {
        guard let text = notification.userInfo?["text"] as? String else { return }
        print ("text: \(text)")
        detailsButton.text = text
        detailsButton.textColor = .white
        
        if(eventNameTextField.text == "Add Title" || hashtagTextView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || locationLabel.text == "Location"){
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
        
        let allAnnotations = mainMapView.annotations
        mainMapView.removeAnnotations(allAnnotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mainMapView.setRegion(region, animated: true)
        mainMapView.addAnnotation(annotation)
        
        locationLabel.text = street
        locationLabel.textColor = .white
        
        if(eventNameTextField.text == "Add Title" || hashtagTextView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || locationLabel.text == "Location"){
            createButton.isUserInteractionEnabled = false
            createButton.alpha = 0.6
        }else{
            createButton.isUserInteractionEnabled = true
            createButton.alpha = 1.0
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        hashtagTyped = true
        hashtagCount = 0
        
        setPopsicleImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.detailsWritten(_:)), name: .detailsWritten, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.locationSelected(_:)), name: .locationSelected, object: nil)
        
        view.backgroundColor = UIColor(cgColor: backgroundGradientColors![1])
        transitioningDelegate = self
        
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 90)).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.frame = CGRect(x: 0, y: 0, width: .getPercentageWidth(percentage: 90), height: .getPercentageHeight(percentage: 90))
        
        backgroundView.addSubview(purplePopsicle)
        purplePopsicle.translatesAutoresizingMaskIntoConstraints = false
        purplePopsicle.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.05).isActive = true
        purplePopsicle.heightAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.05).isActive = true
        purplePopsicle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        purplePopsicle.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: backgroundView.bounds.height * 0.1).isActive = true
        
        backgroundView.addSubview(purpleLineOne)
        purpleLineOne.translatesAutoresizingMaskIntoConstraints = false
        purpleLineOne.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.35).isActive = true
        purpleLineOne.heightAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.005).isActive = true
        purpleLineOne.leadingAnchor.constraint(equalTo: purplePopsicle.trailingAnchor, constant: backgroundView.bounds.width * 0.01).isActive = true
        purpleLineOne.topAnchor.constraint(equalTo: purplePopsicle.centerYAnchor).isActive = true
        
        backgroundView.addSubview(purpleLineTwo)
        purpleLineTwo.translatesAutoresizingMaskIntoConstraints = false
        purpleLineTwo.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.35).isActive = true
        purpleLineTwo.heightAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.005).isActive = true
        purpleLineTwo.trailingAnchor.constraint(equalTo: purplePopsicle.leadingAnchor, constant: -backgroundView.bounds.width * 0.01).isActive = true
        purpleLineTwo.topAnchor.constraint(equalTo: purplePopsicle.centerYAnchor).isActive = true
        
        
        
        backgroundView.addSubview(eventNameTextField)
        eventNameTextField.translatesAutoresizingMaskIntoConstraints = false
        eventNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventNameTextField.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.8).isActive = true
        eventNameTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: backgroundView.bounds.height * 0.03).isActive = true
        eventNameTextField.bottomAnchor.constraint(equalTo: purplePopsicle.topAnchor, constant: backgroundView.bounds.height * 0.015).isActive = true
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 7)).isActive = true
        backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
        backButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: view.bounds.height * 0.02).isActive = true
        backButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: view.bounds.height * 0.02).isActive = true
        
        backgroundView.addSubview(startDateTextField)
        startDateTextField.translatesAutoresizingMaskIntoConstraints = false
        startDateTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: backgroundView.bounds.width * 0.02).isActive = true
        startDateTextField.topAnchor.constraint(equalTo: purplePopsicle.bottomAnchor, constant: backgroundView.bounds.height * 0).isActive = true
        startDateTextField.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.43).isActive = true
        startDateTextField.heightAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.04).isActive = true
        
        backgroundView.addSubview(endDateTextField)
        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        endDateTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -backgroundView.bounds.width * 0.02).isActive = true
        endDateTextField.topAnchor.constraint(equalTo: purplePopsicle.bottomAnchor, constant: backgroundView.bounds.height * 0).isActive = true
        endDateTextField.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.43).isActive = true
        endDateTextField.heightAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.04).isActive = true
        
        
        backgroundView.addSubview(purpleView)
        purpleView.translatesAutoresizingMaskIntoConstraints = false
        purpleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        purpleView.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.8).isActive = true
        purpleView.heightAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.085).isActive = true
        purpleView.topAnchor.constraint(equalTo: startDateTextField.bottomAnchor, constant: backgroundView.bounds.height * 0.03).isActive = true
        purpleView.frame = CGRect(x: 0, y: 0, width: backgroundView.bounds.width * 0.8, height: backgroundView.bounds.height * 0.085)
        
        purpleView.addSubview(userImage)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.centerYAnchor.constraint(equalTo: purpleView.centerYAnchor).isActive = true
        userImage.trailingAnchor.constraint(equalTo: purpleView.trailingAnchor, constant: -purpleView.bounds.width * 0.04).isActive = true
        
        purpleView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: purpleView.leadingAnchor, constant: purpleView.bounds.width * 0.04).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: purpleView.bottomAnchor, constant: -purpleView.bounds.height * 0.1).isActive = true
        
        purpleView.addSubview(createdByLabel)
        createdByLabel.translatesAutoresizingMaskIntoConstraints = false
        createdByLabel.leadingAnchor.constraint(equalTo: purpleView.leadingAnchor, constant: purpleView.bounds.width * 0.04).isActive = true
        createdByLabel.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: -purpleView.bounds.height * 0.07).isActive = true
        
        backgroundView.addSubview(detailsButton)
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        detailsButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        detailsButton.topAnchor.constraint(equalTo: purpleView.bottomAnchor, constant: backgroundView.bounds.height * 0.03).isActive = true
        detailsButton.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.8).isActive = true
        
        backgroundView.addSubview(hashtagTextView)
        hashtagTextView.translatesAutoresizingMaskIntoConstraints = false
        hashtagTextView.leadingAnchor.constraint(equalTo: purpleView.leadingAnchor).isActive = true
        hashtagTextView.topAnchor.constraint(equalTo: detailsButton.bottomAnchor, constant: backgroundView.bounds.height * 0.03).isActive = true
        hashtagTextView.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.8).isActive = true
        
        backgroundView.addSubview(purpleMapView)
        purpleMapView.translatesAutoresizingMaskIntoConstraints = false
        purpleMapView.topAnchor.constraint(equalTo: hashtagTextView.bottomAnchor, constant: backgroundView.bounds.height * 0.03).isActive = true
        purpleMapView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        purpleMapView.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.8).isActive = true
        purpleMapView.heightAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.2).isActive = true
        
        purpleMapView.addSubview(mainMapView)
        mainMapView.translatesAutoresizingMaskIntoConstraints = false
        mainMapView.topAnchor.constraint(equalTo: purpleMapView.topAnchor, constant: backgroundView.bounds.height * 0.05).isActive = true
        mainMapView.bottomAnchor.constraint(equalTo: purpleMapView.bottomAnchor, constant: -backgroundView.bounds.width * 0.015).isActive = true
        mainMapView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        mainMapView.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.77).isActive = true
        
        purpleMapView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.topAnchor.constraint(equalTo: purpleMapView.topAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: mainMapView.topAnchor).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        locationLabel.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.77).isActive = true
        
        backgroundView.addSubview(editLocationButton)
        editLocationButton.translatesAutoresizingMaskIntoConstraints = false
        editLocationButton.topAnchor.constraint(equalTo: purpleMapView.bottomAnchor).isActive = true
        //editLocationButton.bottomAnchor.constraint(equalTo: mainMapView.topAnchor).isActive = true
        editLocationButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        editLocationButton.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.2).isActive = true
        
        backgroundView.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 24)).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 4.5)).isActive = true
        //createButton.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 1000).isActive = true
        createButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10).isActive = true
        createButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        
    }
    
    
    @objc func goBack() {
        
        let textInfo = ["location": locationLabel.text!, "eventName": eventNameTextField.text!, "eventInfo": detailsButton.text!, "eventStartDate": startDateTextField.text!, "eventEndDate": endDateTextField.text!, "hashtags": hashtagTextView.text!, "coordinates": location ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)] as [String : Any]
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .switchCategory, object: nil, userInfo: textInfo)
        
        
    }
    
    @objc func toWriteDetails(tapGestureRecognizer: UITapGestureRecognizer){
        let vc = writeDetailsViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        vc.purpleTab.backgroundColor = UIColor(cgColor: backgroundGradientColors![0])
        vc.whiteView.backgroundColor = UIColor(cgColor: backgroundGradientColors![0])

        if(detailsButton.text == "Add details..."){
            vc.detailsTextField.text = ""
        }else{
            vc.detailsTextField.text = detailsButton.text
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func editLocation(){
        let vc = EditLocationViewController()
        if(locationLabel.text != "Location"){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location!
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            vc.mainMapView.setRegion(region, animated: true)
            vc.mainMapView.addAnnotation(annotation)
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.popsicleImage = popsicleImage
        vc.transitioningDelegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    private func getStartDateFromPicker() {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM d, h:mm a"
        
        startDateTextField.text = formatter.string(from: startDatePicker.date)
        
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        
        startDateFormatted = formatter.string(from: startDatePicker.date)
        
        endDatePicker.minimumDate = startDatePicker.date + 60
        
        
        
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
    
    
    //MARK: Textfield Delegate
    // When user press the return key in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        //textField.resignFirstResponder()
        return true
    }
    
    // It is called before text field become active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.clear
        return true
    }
    
    // It is called when text field activated
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .white
        print("textFieldDidBeginEditing")
    }
    
    // It is called when text field going to inactive
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.clear
        return true
    }
    
    // It is called when text field is inactive
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        
        if(eventNameTextField.text == "Add Title" || hashtagTextView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || locationLabel.text == "Location"){
                   createButton.isUserInteractionEnabled = false
                   createButton.alpha = 0.6
               }else{
                   createButton.isUserInteractionEnabled = true
                   createButton.alpha = 1.0
               }
    }
    
    // It is called each time user type a character by keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        textView.textColor = .white
        if(textView == eventNameTextField){
            if  eventNameTextField.text == "Add Title" && eventNameTextField.isFirstResponder {
                eventNameTextField.text = nil
                //eventNameTextField.textColor = .white
            }
            let newPosition = eventNameTextField.endOfDocument
            eventNameTextField.selectedTextRange = eventNameTextField.textRange(from: newPosition, to: newPosition)
        }
        
        if(textView == hashtagTextView){
            if  hashtagTextView.text == "Add Hashtags" && hashtagTextView.isFirstResponder {
                hashtagTextView.text = "#"
                hashtagCount = 1
                //eventNameTextField.textColor = .white
            }
            let newPosition = hashtagTextView.endOfDocument
            hashtagTextView.selectedTextRange = hashtagTextView.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        print("ENNDDDEEDDD")
        if(eventNameTextField.text == "Add Title" || hashtagTextView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || locationLabel.text == "Location"){
                   createButton.isUserInteractionEnabled = false
                   createButton.alpha = 0.6
               }else{
                   createButton.isUserInteractionEnabled = true
                   createButton.alpha = 1.0
               }
        
        if(textView == eventNameTextField){
            if eventNameTextField.text.isEmpty || eventNameTextField.text == "" {
                eventNameTextField.textColor = .white
                eventNameTextField.text = "Add Title"
            }
            

        }
        
        if(textView == hashtagTextView){
            if hashtagTextView.text.isEmpty || hashtagTextView.text == "#" {
                hashtagTextView.textColor = .white
                hashtagTextView.text = "Add Hashtags"
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        if(textView == eventNameTextField){
            if text == "\n" {
                eventNameTextField.resignFirstResponder()
                if(eventNameTextField.text == "Add Title" || hashtagTextView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || locationLabel.text == "Location"){
                    createButton.isUserInteractionEnabled = false
                    createButton.alpha = 0.6
                }else{
                    createButton.isUserInteractionEnabled = true
                    createButton.alpha = 1.0
                }
                return false
            }
            
            let newText = (eventNameTextField.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            
            if(numberOfChars >= 10 && numberOfChars < 20){
                eventNameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .title2)
                
            }
            if(numberOfChars >= 20 && numberOfChars <= 30){
                eventNameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
                
            }
            if(numberOfChars < 10){
                eventNameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
                
            }
            return numberOfChars <= 30
            
        }
        
        if(textView == hashtagTextView){
            
            let newText = (hashtagTextView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            
            let regex = try! NSRegularExpression(pattern: "\\s")
            let numberOfWhitespaceCharacters = regex.numberOfMatches(in: newText, range: NSRange(location: 0, length: newText.utf16.count))
            
            let substring = (hashtagTextView.text as NSString).substring(with: range)
            
            if(hashtagTextView.text == ""){
                hashtagTyped = false
                hashtagTextView.text = "#"
            }
            
            if text == "\n" {
                hashtagTextView.resignFirstResponder()
                if(eventNameTextField.text == "Add Title" || hashtagTextView.text == "Add Hashtags" || detailsButton.text == "Add details..." || startDateTextField.text == "Start Date" || endDateTextField.text == "End Date" || locationLabel.text == "Location"){
                    createButton.isUserInteractionEnabled = false
                    createButton.alpha = 0.6
                }else{
                    createButton.isUserInteractionEnabled = true
                    createButton.alpha = 1.0
                }
                return false
            }
            
            if(substring == "#"){
                hashtagTextView.text.removeLast()
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
                hashtagTextView.text = hashtagTextView.text + " #"
                return false
            }
            
            print(substring)
            
            return numberOfWhitespaceCharacters < 5 && numberOfChars < 60
            
        }
        
        return false
    }
    
    func setPopsicleImage(){
        if(backgroundGradientColors![0] == UIColor.cultureLIGHTPURPLE.cgColor){
            popsicleImage = .culturePopsicleIcon128
            category = "culture"
        }
        
        if(backgroundGradientColors![0] == UIColor.educationLIGHTBLUE.cgColor){
            popsicleImage = .educationPopsicleIcon128
            category = "education"
        }
        
        if(backgroundGradientColors![0] == UIColor.socialLIGHTRED.cgColor){
            popsicleImage = .socialPopsicleIcon128
            category = "social"
        }
        
        if(backgroundGradientColors![0] == UIColor.foodLIGHTORANGE.cgColor){
            popsicleImage = .foodPopsicleIcon128
            category = "food"
        }
        
        if(backgroundGradientColors![0] == UIColor.sportsLIGHTGREEN.cgColor){
            popsicleImage = .sportsPopsicleIcon128
            category = "sports"
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = popsicleImage
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
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
            "longitude": location?.longitude,
            "latitude": location?.latitude,
            "eventName": eventNameTextField.text!,
            "eventDetails": detailsButton.text!,
            "startDate": startDateFormatted!,
            "endDate": endDateFormatted!,
            "hashtags": hashtagTextView.text!,
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
//            ref.child("currentPopsicles/\(identifier.uuidString)/eventName").setValue(eventNameTextField.text)
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
            
           // let textInfo = ["location": location!, "eventName": eventNameTextField.text!, "eventInfo": detailsButton.text!, "eventStartDate": startDateFormatted!, "eventEndDate": endDateFormatted!, "eventCategory": category!, "hashtags": hashtagTextView.text!, "createdBy": uid ] as [String : Any]
            
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
            return FlipPresentAnimationController(originFrame: backgroundView.frame)
    }
    
    func animationController(forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
//            guard let _ = ((dismissed as? EditLocationViewController) != nil) || ((dismissed as? writeDetailsViewController) != nil) else {
//                return nil
//            }
            
            if let _ = dismissed as? writeDetailsViewController {
                return FlipDismissAnimationController(destinationFrame: backgroundView.frame)
            }else if let _ = dismissed as? EditLocationViewController{
                return FlipDismissAnimationController(destinationFrame: backgroundView.frame)
            }else{
                
                return nil
            }

            
            return FlipDismissAnimationController(destinationFrame: backgroundView.frame)
    }
}
