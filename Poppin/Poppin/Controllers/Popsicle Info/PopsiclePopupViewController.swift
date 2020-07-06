//
//  PopsiclePopupViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 6/24/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit
import MapKit

class PopsiclePopupViewController : UIViewController, HashtagViewDelegate {
    
    var popsicleCategory = PopsicleCategory.Default
    var popsicleName = ""
    var popsicleStartDate = ""
    var popsicleEndDate = ""
    var popsicleDetails = ""
    var popsicleAddy = CLLocationCoordinate2D()
    var popsicleHashtags = [""]
    
    lazy var catColor1 : UIColor = {
        switch(popsicleCategory) {
            case PopsicleCategory.Education :
                return .educationDARKBLUE
            case PopsicleCategory.Food :
                return .foodDARKORANGE
            case PopsicleCategory.Social :
                return .socialDARKRED
            case PopsicleCategory.Sports :
                return .sportsDARKGREEN
            case PopsicleCategory.Culture :
                return .cultureDARKPURPLE
            default :
                return .white
        }
    }()
    
    lazy var catColor2 : UIColor = {
        switch(popsicleCategory) {
            case PopsicleCategory.Education :
                return .educationLIGHTBLUE
            case PopsicleCategory.Food :
                return .foodLIGHTORANGE
            case PopsicleCategory.Social :
                return .socialLIGHTRED
            case PopsicleCategory.Sports :
                return .sportsLIGHTGREEN
            case PopsicleCategory.Culture :
                return .cultureLIGHTPURPLE
            default :
                return .white
        }
    }()
    
    let themedCornerRadius = CGFloat(20)
    
    lazy var card : UIView = {
        var c = UIView()
        c.backgroundColor = catColor2
        c.layer.cornerRadius = themedCornerRadius
        return c
    }()
    
    lazy var tabBar : UIView = {
        var t = UIView()
        t.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        t.layer.cornerRadius = 4
        return t
    }()
    
    /* for the popsicle border */
    lazy var catOfEvent : UIImageView = {
        var i = UIImageView(image: UIImage(named: "defaultPopsicleIcon256")?.withTintColor(catColor1))
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    lazy var leftBorder : UIView = {
        var b = UIView()
        b.backgroundColor = catColor1
        b.layer.cornerRadius = 5
        return b
    }()
    
    lazy var rightBorder : UIView = {
        var b = UIView()
        b.backgroundColor = catColor1
        b.layer.cornerRadius = 5
        return b
    }()
    
    lazy var nameOfEvent : UILabel = {
        var t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0)
        t.font = UIFont(name: "Octarine-Bold", size: 20)
        t.textColor = .white
        t.text = popsicleName
        t.textAlignment = .center
        return t
    }()
    
    lazy var startOfEvent : UILabel = {
        var t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0)
        t.font = UIFont(name: "Octarine-LightOblique", size: 18)
        t.textColor = .white
        t.text = popsicleStartDate
        t.textAlignment = .center
        return t
    }()
    
    lazy var endOfEvent : UILabel = {
        var t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0)
        t.font = UIFont(name: "Octarine-LightOblique", size: 18)
        t.textColor = .white
        t.text = popsicleEndDate
        t.textAlignment = .center
        return t
    }()
    
    /* created by view */
    lazy var userThatCreatedEventImage : ImageBubbleButton = {
        var i = ImageBubbleButton(bouncyButtonImage: .defaultUserPicture256)
        return i
    }()
    
    lazy var userThatCreatedEventName : UIView = {
        var t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0)
        t.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .body)
        t.textColor = .white
        t.numberOfLines = 2
        t.text = "Created by:\n@mrchoperini"
        return t
    }()
    
//    lazy var userChat : BouncyButton = {
//        var i = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .messageCircleFill).withTintColor(.mainDARKPURPLE))
//        return i
//    }()
    
    lazy var createdBy : UIView = {
        var c = UIView()
        c.backgroundColor = catColor1
        c.layer.cornerRadius = themedCornerRadius
        
        c.addSubview(userThatCreatedEventImage)
        userThatCreatedEventImage.translatesAutoresizingMaskIntoConstraints = false
        userThatCreatedEventImage.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 11)).isActive = true
        userThatCreatedEventImage.heightAnchor.constraint(equalTo: userThatCreatedEventImage.widthAnchor).isActive = true
        userThatCreatedEventImage.topAnchor.constraint(equalTo: c.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 1.25)).isActive = true
        userThatCreatedEventImage.leadingAnchor.constraint(equalTo: c.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 57)).isActive = true
        
        c.addSubview(userThatCreatedEventName)
        userThatCreatedEventName.translatesAutoresizingMaskIntoConstraints = false
        userThatCreatedEventName.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 45)).isActive = true
        userThatCreatedEventName.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 5)).isActive = true
        userThatCreatedEventName.topAnchor.constraint(equalTo: c.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 1.5)).isActive = true
        userThatCreatedEventName.leadingAnchor.constraint(equalTo: c.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 4)).isActive = true
        
        //c.addSubview(userChat)
//        userChat.translatesAutoresizingMaskIntoConstraints = false
//        userChat.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 12)).isActive = true
//        userChat.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 5)).isActive = true
//        userChat.topAnchor.constraint(equalTo: c.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 1.5)).isActive = true
//        userChat.leadingAnchor.constraint(equalTo: c.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 68)).isActive = true
        
        return c
    }()
    
    lazy var infoOfEvent : UIScrollView = {
        var s = UIScrollView()
        s.backgroundColor = catColor1
        s.layer.masksToBounds = true
        s.layer.cornerRadius = themedCornerRadius
        var t = UILabel()
        t.font = UIFont.dynamicFont(with: "Octarine-Light", style: .body)
        t.textColor = .white
        t.numberOfLines = 15
//        t.text = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
        t.text = popsicleDetails
        t.allowsDefaultTighteningForTruncation = true
        t.sizeToFit()
        s.addSubview(t)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.widthAnchor.constraint(equalTo: s.safeAreaLayoutGuide.widthAnchor, constant: -(.getPercentageWidth(percentage: 3))).isActive = true
//        t.heightAnchor.constraint(equalTo: s.safeAreaLayoutGuide.heightAnchor, constant: -(.getPercentageWidth(percentage: 2))).isActive = true
        t.topAnchor.constraint(equalTo: s.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        t.centerXAnchor.constraint(equalTo: s.safeAreaLayoutGuide.centerXAnchor).isActive = true
        s.bouncesZoom = true
        s.isScrollEnabled = true
        return s
    }()
    
    lazy var hashtagView : HashtagView = {
        var h = HashtagView()
        h.backgroundColor = catColor1
        h.tagBackgroundColor = catColor2
        h.tagTextColor = .white
        h.cornerRadius = themedCornerRadius
        h.tagCornerRadius = 10
        //h.tagPadding = 5.0
        h.horizontalTagSpacing = 7.0
        h.verticalTagSpacing = 5.0
        return h
    }()
    
    lazy var mapAddy : UILabel = {
        var l = UILabel()
        l.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .body)
        l.text = ""
        getAddressFromLatLon(Latitude: popsicleAddy.latitude, Longitude: popsicleAddy.longitude)
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    lazy var map : MKMapView = {
        var m = MKMapView()
        m.layer.cornerRadius = themedCornerRadius - 3
        m.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        let viewRegion = MKCoordinateRegion(center: popsicleAddy, latitudinalMeters: 75, longitudinalMeters: 75)
        m.setRegion(viewRegion, animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = popsicleAddy
        m.addAnnotation(annotation)
        return m
    }()
    
    lazy var mapView : UIView = {
        var v = UIView()
        v.backgroundColor = catColor1
        v.layer.cornerRadius = themedCornerRadius
        
        v.addSubview(mapAddy)
        mapAddy.translatesAutoresizingMaskIntoConstraints = false
        mapAddy.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 72.5)).isActive = true
        mapAddy.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 2.5)).isActive = true
        mapAddy.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 0.65)).isActive = true
        mapAddy.centerXAnchor.constraint(equalTo: v.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        v.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        map.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 69.5)).isActive = true
        map.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 12.5)).isActive = true
        map.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 3.35)).isActive = true
        map.centerXAnchor.constraint(equalTo: v.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        return v
    }()
    
    lazy var whosGoingButton : BouncyButton = {
        var g = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .rectangleStackPersonCrop).withTintColor(.white))
        g.addTarget(self, action: #selector(seeWhosGoing), for: .touchUpInside)
        return g
    }()
    
    private var isGoing = false
    
    lazy var goingButton : BubbleButton = {
        var g = BubbleButton(bouncyButtonImage: nil)
        g.backgroundColor = .white
        g.setTitleColor(catColor1, for: .normal)
        g.setTitle("going", for: .normal)
        g.titleLabel?.font = UIFont(name: "Octarine-Bold", size: 20)
        g.contentHorizontalAlignment = .center
        g.addTarget(self, action: #selector(updateIfGoing), for: .touchUpInside)
        return g
    }()
    
    lazy var shareButton : BouncyButton = {
        var g = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .squareAndArrowUp).withTintColor(.white))
        g.addTarget(self, action: #selector(sharePopsicleInfo), for: .touchUpInside)
        return g
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = catColor1
        
        /* adding hashtags */
        hashtagView.addTag(tag: HashTag(word: "food"))
        hashtagView.addTag(tag: HashTag(word: "Ethiopia"))
        hashtagView.addTag(tag: HashTag(word: "habesha"))
        hashtagView.addTag(tag: HashTag(word: "BoardGames"))
        hashtagView.addTag(tag: HashTag(word: "PleaseCome"))
        hashtagView.addTag(tag: HashTag(word: "yosi"))
        hashtagView.addTag(tag: HashTag(word: "yosiiscool"))
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        card.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
        card.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 89)).isActive = true
        card.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(.getPercentageHeight(percentage: 1.75))).isActive = true
        card.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 20)).isActive = true
        tabBar.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 0.75)).isActive = true
        tabBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(.getPercentageHeight(percentage: 3.70))).isActive = true
        tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(catOfEvent)
        catOfEvent.translatesAutoresizingMaskIntoConstraints = false
        catOfEvent.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 3)).isActive = true
        catOfEvent.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
        catOfEvent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 4.5)).isActive = true
        catOfEvent.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(leftBorder)
        leftBorder.translatesAutoresizingMaskIntoConstraints = false
        leftBorder.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 36)).isActive = true
        leftBorder.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 0.3)).isActive = true
        leftBorder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 5.5)).isActive = true
        leftBorder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 9)).isActive = true
        
        view.addSubview(rightBorder)
        rightBorder.translatesAutoresizingMaskIntoConstraints = false
        rightBorder.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 36)).isActive = true
        rightBorder.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 0.3)).isActive = true
        rightBorder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 5.5)).isActive = true
        rightBorder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 55)).isActive = true
        
        view.addSubview(nameOfEvent)
        nameOfEvent.translatesAutoresizingMaskIntoConstraints = false
        nameOfEvent.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 75)).isActive = true
        nameOfEvent.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 5)).isActive = true
        nameOfEvent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -(.getPercentageHeight(percentage: 0.5))).isActive = true
        nameOfEvent.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(startOfEvent)
        startOfEvent.translatesAutoresizingMaskIntoConstraints = false
        startOfEvent.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 40)).isActive = true
        startOfEvent.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 5)).isActive = true
        startOfEvent.topAnchor.constraint(equalTo: leftBorder.safeAreaLayoutGuide.bottomAnchor, constant: .getPercentageHeight(percentage: 0.25)).isActive = true
        startOfEvent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 4.5)).isActive = true
        
        view.addSubview(endOfEvent)
        endOfEvent.translatesAutoresizingMaskIntoConstraints = false
        endOfEvent.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 40)).isActive = true
        endOfEvent.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 5)).isActive = true
        endOfEvent.topAnchor.constraint(equalTo: rightBorder.safeAreaLayoutGuide.bottomAnchor, constant: .getPercentageHeight(percentage: 0.25)).isActive = true
        endOfEvent.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 55)).isActive = true
        
        view.addSubview(createdBy)
        createdBy.translatesAutoresizingMaskIntoConstraints = false
        createdBy.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 72)).isActive = true
        createdBy.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 8)).isActive = true
        createdBy.topAnchor.constraint(equalTo: catOfEvent.safeAreaLayoutGuide.bottomAnchor, constant: .getPercentageHeight(percentage: 4)).isActive = true
        createdBy.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(infoOfEvent)
        infoOfEvent.translatesAutoresizingMaskIntoConstraints = false
        infoOfEvent.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 72)).isActive = true
        infoOfEvent.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 15)).isActive = true
        infoOfEvent.topAnchor.constraint(equalTo: createdBy.safeAreaLayoutGuide.bottomAnchor, constant: .getPercentageHeight(percentage: 2.75)).isActive = true
        infoOfEvent.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(hashtagView)
        hashtagView.translatesAutoresizingMaskIntoConstraints = false
        hashtagView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 72)).isActive = true
        //hashtagView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 13)).isActive = true
        hashtagView.topAnchor.constraint(equalTo: infoOfEvent.safeAreaLayoutGuide.bottomAnchor, constant: .getPercentageHeight(percentage: 2.75)).isActive = true
        hashtagView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        /* hashtag view has dynamic height constraint that depends on number of hashtags in view */
        hashtagView.resize()
        
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 72)).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 16.5)).isActive = true
        mapView.topAnchor.constraint(equalTo: hashtagView.safeAreaLayoutGuide.bottomAnchor, constant: .getPercentageHeight(percentage: 2.75)).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(whosGoingButton)
        whosGoingButton.translatesAutoresizingMaskIntoConstraints = false
        whosGoingButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        whosGoingButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 4)).isActive = true
        whosGoingButton.topAnchor.constraint(equalTo: card.safeAreaLayoutGuide.bottomAnchor, constant: -(.getPercentageHeight(percentage: 7))).isActive = true
        whosGoingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 10)).isActive = true
        
        view.addSubview(goingButton)
        goingButton.translatesAutoresizingMaskIntoConstraints = false
        goingButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 28)).isActive = true
        goingButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 4.25)).isActive = true
        goingButton.topAnchor.constraint(equalTo: card.safeAreaLayoutGuide.bottomAnchor, constant: -(.getPercentageHeight(percentage: 6.5))).isActive = true
        goingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 4)).isActive = true
        shareButton.topAnchor.constraint(equalTo: card.safeAreaLayoutGuide.bottomAnchor, constant: -(.getPercentageHeight(percentage: 7))).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 78)).isActive = true
        
        roundViews()
    }
    
    /* controls the animation of the popup when it first appears */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.6, animations: {
            self.moveView(state: .partial)
        })
    }
    
    private func moveView(state: State) {
        var yPosition = CGFloat()
        if(state == .partial) {
            yPosition = Constant.partialViewYPosition
        } else if(state == .full) {
            yPosition = Constant.fullViewYPosition
        } else if(state == .dismissed) {
            yPosition = Constant.dismissedYPosition
        }
//        let yPosition = state == .partial ? Constant.partialViewYPosition : Constant.fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
    }

    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= Constant.fullViewYPosition) && (minY + translation.y <= Constant.partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        } else if(minY + translation.y > Constant.partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        var dismissed = false
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.6, delay: 0.0, options: [.allowUserInteraction], animations: {
                if(recognizer.velocity(in: self.view).y < 0) {
                    self.moveView(state: .full)
                } else if(recognizer.velocity(in: self.view).y >= 0 && self.view.frame.minY > Constant.partialViewYPosition) {
                    self.moveView(state: .dismissed)
                    dismissed = true
                } else {
                    self.moveView(state: .partial)
                }
            }, completion: { (finished: Bool) in
                if(dismissed) {
                    // dismiss posicle info view
                    self.view.removeFromSuperview()
                    print("dismissed")
                }
            })
        }
        
    }
    
    func roundViews() {
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
    }
    
    /* functions to conform to Hashtag delegate */
    func hashtagRemoved(hashtag: HashTag) {
        //
    }
    
    func viewShouldResizeTo(size: CGSize) {
        hashtagView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* button controls */
    @objc func updateIfGoing() {
        if(isGoing) {
            goingButton.backgroundColor = .white
            goingButton.setTitleColor(catColor1, for: .normal)
        } else {
            goingButton.backgroundColor = .sportsLIGHTGREEN
            goingButton.setTitleColor(.white, for: .normal)
        }
        isGoing = !isGoing
    }
    
    @objc func seeWhosGoing() {
        // TO-DO
    }
    
    @objc func sharePopsicleInfo() {
        // TO-DO
    }
    
    /* converts a CLLocationCoordinate2D to a compact address string */
    func getAddressFromLatLon(Latitude: Double, Longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()


        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = Latitude
        center.longitude = Longitude

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    if pm.subThoroughfare != nil {
                        self.mapAddy.text = self.mapAddy.text! + pm.subThoroughfare! + " "
                    }
                    if pm.thoroughfare != nil {
                        self.mapAddy.text = self.mapAddy.text! + pm.thoroughfare!
                    }
                }
        })
    }

}

extension PopsiclePopupViewController {
    private enum State {
        case dismissed
        case partial
        case full
    }
    
    private enum Constant {
        static let fullViewYPosition: CGFloat = .getPercentageHeight(percentage: 5)
        static let partialViewYPosition: CGFloat = .getPercentageHeight(percentage: 76)
        static let dismissedYPosition: CGFloat = .getPercentageHeight(percentage: 100)
    }
}
