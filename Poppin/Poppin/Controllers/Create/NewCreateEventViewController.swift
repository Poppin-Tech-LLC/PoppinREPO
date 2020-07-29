//
//  NewCreateEventViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 5/13/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import MapKit
import SwiftDate

class NewCreateEventViewController : UIViewController {
    
    private var eventData: PopsicleAnnotationData = PopsicleAnnotationData()
    
    private let createEventVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let createEventHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let createEventInnerInset: CGFloat = .getPercentageWidth(percentage: 7)
    
    private var currentPage: Int = 0
    
    lazy private var eventCategories: [PopsicleCategory] = [.Culture, .Social, .Food, .Sports, .Education]
    
    lazy private var eventCategoryGradients: [UIImage] = {
        
        var eventCategoryGradients: [UIImage] = []
        
        for eventCategory in eventCategories {
            
            eventCategoryGradients.append(eventCategory.getPopsicleCategoryGradient())
            
        }
        
        return eventCategoryGradients
        
    }()
    
    lazy private var eventCategoryIcons: [UIImage] = {
        
        var eventCategoryIcons: [UIImage] = []
        
        for eventCategory in eventCategories {
            
            eventCategoryIcons.append(eventCategory.getPopsicleCategoryIcon())
            
        }
        
        return eventCategoryIcons
        
    }()
    
    lazy private var createEventBackgroundView: UIImageView = {
        
        var createEventBackgroundView = UIImageView(image: eventCategories[0].getPopsicleCategoryGradient())
        createEventBackgroundView.contentMode = .scaleAspectFill
        return createEventBackgroundView
        
    }()
    
    lazy private var createEventCancelButton: BubbleButton = {
        
        var createEventCancelButton = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .multiply, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
        createEventCancelButton.contentEdgeInsets = UIEdgeInsets(top: createEventTopLabel.intrinsicContentSize.height*0.5, left: createEventTopLabel.intrinsicContentSize.height*0.5, bottom: createEventTopLabel.intrinsicContentSize.height*0.5, right: createEventTopLabel.intrinsicContentSize.height*0.5)
        createEventCancelButton.backgroundColor = .clear
        createEventCancelButton.addTarget(self, action: #selector(dismissCreateEvent), for: .touchUpInside)
        
        createEventCancelButton.translatesAutoresizingMaskIntoConstraints = false
        createEventCancelButton.heightAnchor.constraint(equalToConstant: createEventTopLabel.intrinsicContentSize.height*2).isActive = true
        createEventCancelButton.widthAnchor.constraint(equalTo: createEventCancelButton.heightAnchor).isActive = true
        
        return createEventCancelButton
        
    }()
    
    @objc private func dismissCreateEvent() {
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    lazy private var createEventTopLabel: UILabel = {
        
        var createEventTopLabel = UILabel()
        createEventTopLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        createEventTopLabel.text = "What's your event like?"
        createEventTopLabel.numberOfLines = 1
        createEventTopLabel.textAlignment = .center
        createEventTopLabel.textColor = .white
        
        createEventTopLabel.translatesAutoresizingMaskIntoConstraints = false
        createEventTopLabel.heightAnchor.constraint(equalToConstant: createEventTopLabel.intrinsicContentSize.height).isActive = true
        createEventTopLabel.widthAnchor.constraint(equalToConstant: createEventTopLabel.intrinsicContentSize.width).isActive = true
        
        return createEventTopLabel
        
    }()
    
    lazy var categoryCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        
        return cv
        
    }()
    
    let cellReuseIdentifier = "cell"
    
    init(userLocation: CLLocationCoordinate2D?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let userLocation = userLocation { eventData.eventLocation = userLocation }
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    @objc func eventCreated(_ notification: Notification) {
        self.dismiss(animated: true, completion: nil)
       }
    
    /*@objc func switchCategory(_ notification: Notification) {
        guard let eventName = notification.userInfo?["eventName"] as? String else { return }
        guard let eventInfo = notification.userInfo?["eventInfo"] as? String else { return }
        guard let location = notification.userInfo?["location"] as? String else { return }
        guard let eventStartDate = notification.userInfo?["eventStartDate"] as? String else { return }
        guard let eventEndDate = notification.userInfo?["eventEndDate"] as? String else { return }
        guard let hashtags = notification.userInfo?["hashtags"] as? String else { return }
        
        if(location != "Location"){
            guard let coordinates = notification.userInfo?["coordinates"] as? CLLocationCoordinate2D else { return }
            self.coordinates = coordinates
        }
        
        if(eventStartDate == ""){
            startDateText = "Start Date"
        }else{
            startDateText = eventStartDate
        }
        
        if(eventEndDate == ""){
            endDateText = "End Date"
        }else{
            endDateText = eventEndDate
        }
       
        eventNameText = eventName
        detailsText = eventInfo
        locationText = location
        hashtagsText = hashtags
        
        categoryCollectionView.isHidden = false
        createEventCancelButton.isHidden = false
        createEventTopLabel.isHidden = false
        
    }*/

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(self.eventCreated(_:)), name: .eventCreated, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.switchCategory(_:)), name: .switchCategory, object: nil)*/
        
        view.backgroundColor = .mainCREAM
        
        view.addSubview(createEventBackgroundView)
        createEventBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        createEventBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        createEventBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        createEventBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        createEventBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        view.addSubview(categoryCollectionView)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: createEventInnerInset).isActive = true
        categoryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -createEventVerticalEdgeInset).isActive = true
        
        view.addSubview(createEventCancelButton)
        createEventCancelButton.translatesAutoresizingMaskIntoConstraints = false
        createEventCancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: createEventVerticalEdgeInset - createEventTopLabel.intrinsicContentSize.height*0.25).isActive = true
        createEventCancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: createEventHorizontalEdgeInset - createEventTopLabel.intrinsicContentSize.height*0.25).isActive = true
        
        view.addSubview(createEventTopLabel)
        createEventTopLabel.translatesAutoresizingMaskIntoConstraints = false
        createEventTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createEventTopLabel.topAnchor.constraint(equalTo: createEventCancelButton.bottomAnchor, constant: createEventInnerInset).isActive = true
        
    }
    
}

extension NewCreateEventViewController : UICollectionViewDataSource {
    // hardcode to show 10 cells, you can use array for this if you want
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CollectionViewCell
        switch (indexPath.row)   {
          case 0:
            //cell.contentView.backgroundColor = .purple
            cell.popsicleIconImageView.image = .culturePopsicleIcon256
            cell.categoryLabel.text = "Culture \"Dragonfruit\""
            //cell.flavorLabel.text = "\"Dragonfruit\""
            cell.descriptionLabel.text = "You're doing it for the culture! Let everyone know that this is a cultural event that you wish to share."
            
            for subview in cell.pageIconsStackView.arrangedSubviews {
                
                if subview is UIImageView {
                    
                    (subview as! UIImageView).image = UIImage.nonFilledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                    
                }
                
            }
            
            if cell.pageIconsStackView.arrangedSubviews[indexPath.row] is UIImageView {
                
                (cell.pageIconsStackView.arrangedSubviews[indexPath.row] as! UIImageView).image = UIImage.filledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                
            }
            
          case 1:
            //cell.contentView.backgroundColor = .red
            cell.popsicleIconImageView.image = UIImage(named: "socialPopsicleIcon256")
            cell.categoryLabel.text = "Social \"Strawberry\""
            //cell.flavorLabel.text = "\"Strawberry\""
            cell.descriptionLabel.text = "The core of any event, grab a group of people and go have yourselves some fun!"
            
            for subview in cell.pageIconsStackView.arrangedSubviews {
                
                if subview is UIImageView {
                    
                    (subview as! UIImageView).image = UIImage.nonFilledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                    
                }
                
            }
            
            if cell.pageIconsStackView.arrangedSubviews[indexPath.row] is UIImageView {
                
                (cell.pageIconsStackView.arrangedSubviews[indexPath.row] as! UIImageView).image = UIImage.filledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                
            }
            
          case 2:
            //cell.contentView.backgroundColor = .orange
            cell.popsicleIconImageView.image = UIImage(named: "foodPopsicleIcon256")
            cell.categoryLabel.text = "Food \"Orange\""
            //cell.flavorLabel.text = "\"Orange\""
            cell.descriptionLabel.text = "Food is the fastest way to someones heart! No one shall leave your event on an empty stomach."
            
            for subview in cell.pageIconsStackView.arrangedSubviews {
                
                if subview is UIImageView {
                    
                    (subview as! UIImageView).image = UIImage.nonFilledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                    
                }
                
            }
            
            if cell.pageIconsStackView.arrangedSubviews[indexPath.row] is UIImageView {
                
                (cell.pageIconsStackView.arrangedSubviews[indexPath.row] as! UIImageView).image = UIImage.filledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                
            }
            
          case 3:
            //cell.contentView.backgroundColor = .yellow
            cell.popsicleIconImageView.image = UIImage(named: "sportsPopsicleIcon256")
            cell.categoryLabel.text = "Sports \"Lime\""
            //cell.flavorLabel.text = "\"Lime\""
            cell.descriptionLabel.text = "Sports? E-Sports? It's going to be competitive regardless, may the best competitor win!"
            
            for subview in cell.pageIconsStackView.arrangedSubviews {
                
                if subview is UIImageView {
                    
                    (subview as! UIImageView).image = UIImage.nonFilledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                    
                }
                
            }
            
            if cell.pageIconsStackView.arrangedSubviews[indexPath.row] is UIImageView {
                
                (cell.pageIconsStackView.arrangedSubviews[indexPath.row] as! UIImageView).image = UIImage.filledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                
            }
            
          case 4:
            //cell.contentView.backgroundColor = .green
            cell.popsicleIconImageView.image = UIImage(named: "educationPopsicleIcon256")
            cell.categoryLabel.text = "Education \"Blueberry\""
            //cell.flavorLabel.text = "\"Blueberry\""
            cell.descriptionLabel.text = "There's always time to learn new things! Everyone who leaves your event will learn something new from it."
            
            for subview in cell.pageIconsStackView.arrangedSubviews {
                
                if subview is UIImageView {
                    
                    (subview as! UIImageView).image = UIImage.nonFilledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                    
                }
                
            }
            
            if cell.pageIconsStackView.arrangedSubviews[indexPath.row] is UIImageView {
                
                (cell.pageIconsStackView.arrangedSubviews[indexPath.row] as! UIImageView).image = UIImage.filledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                
            }
            
        default:
           break
         }
        
        cell.pageIconsStackView.layoutIfNeeded()
        
        return cell
    }
}

// Cell height is equal to the collection view's height
// Cell width = cell height = collection view's height
extension NewCreateEventViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}

extension NewCreateEventViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        eventData.eventCategory = eventCategories[indexPath.row]
        
        let refDate = Region.current.nowInThisRegion().date.dateRoundedAt(at: .toCeil5Mins)
        
        if eventData.eventStartDate.isBeforeDate(refDate, granularity: .minute) {
            
            eventData.eventStartDate = refDate
            
        }
        
        if eventData.eventEndDate.isInRange(date: eventData.eventStartDate, and: eventData.eventStartDate + 15.minutes) {
            
            eventData.eventEndDate = eventData.eventStartDate + 15.minutes
            
        }
        
        let vc = NewCreateEventCardViewController(eventData: eventData)
        
        /*vc.startDateTextField.text = startDateText
        vc.endDateTextField.text = endDateText
        vc.eventLocationLabel.text = locationText
        vc.detailsButton.text = detailsText
        vc.eventHashtagsView.text = hashtagsText
        
        if(locationText != "Location"){
            let allAnnotations = vc.eventLocationMapView.annotations
            vc.eventLocationMapView.removeAnnotations(allAnnotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates!
            
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            vc.location = coordinates
            vc.eventLocationMapView.setRegion(region, animated: true)
            vc.eventLocationMapView.addAnnotation(annotation)
            
            if( vc.eventHashtagsView.text == "Add Hashtags" || vc.detailsButton.text == "Add details..." || vc.startDateTextField.text == "Start Date" || vc.endDateTextField.text == "End Date" || vc.eventLocationLabel.text == "Location"){
                vc.createButton.isUserInteractionEnabled = false
                vc.createButton.alpha = 0.6
            }else{
                vc.createButton.isUserInteractionEnabled = true
                vc.createButton.alpha = 1.0
            }
        }*/
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension NewCreateEventViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageOffset = scrollView.contentOffset.x / view.frame.width
        
        if pageOffset >= 0.0, pageOffset < CGFloat(eventCategories.count) {
            
            let minOffset = CGFloat(currentPage) - 0.5
            let maxOffset = CGFloat(currentPage) + 0.5
            
            if pageOffset < minOffset {
                
                currentPage-=1
                
                UIView.transition(with: createEventBackgroundView,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.createEventBackgroundView.image = self.eventCategoryGradients[self.currentPage] },
                                  completion: nil)
                
            } else if pageOffset > maxOffset {
                
                currentPage+=1
                
                UIView.transition(with: createEventBackgroundView,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve,
                                  animations: { self.createEventBackgroundView.image = self.eventCategoryGradients[self.currentPage] },
                                  completion: nil)
                
            }
            
        }
        
        // center X of collection View
        let centerX = self.categoryCollectionView.center.x
        
        // only perform the scaling on cells that are visible on screen
        for cell in self.categoryCollectionView.visibleCells {
            
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterX = basePosition.x + self.categoryCollectionView.frame.size.width / 2.0
            
            let distance = abs(cellCenterX - centerX)
            
            let tolerance : CGFloat = 0.02
            var scale = 1.00 + tolerance - (( distance / centerX ) * 0.105)
            if(scale > 1.0){
                scale = 1.0
            }
            
            // set minimum scale so the previous and next album art will have the same size
            if(scale < 0.860091){
                scale = 0.860091
            }
            
            // Transform the cell size based on the scale
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // change the alpha of the image view
            let coverCell = cell as! CollectionViewCell
            coverCell.contentView.alpha = changeSizeScaleToAlphaScale(scale)
            
        }
        
    }
    
    // map the scale of cell size to alpha of image view using formula below
    // https://stackoverflow.com/questions/5294955/how-to-scale-down-a-range-of-numbers-with-a-known-min-and-max-value
    func changeSizeScaleToAlphaScale(_ x : CGFloat) -> CGFloat {
        let minScale : CGFloat = 0.86
        let maxScale : CGFloat = 1.0
        
        let minAlpha : CGFloat = 0.25
        let maxAlpha : CGFloat = 1.0
        
        return ((maxAlpha - minAlpha) * (x - minScale)) / (maxScale - minScale) + minAlpha
    }
    
}

class CollectionViewCell : UICollectionViewCell {
    
    private let cellVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let cellHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let cellInnerInset: CGFloat = .getPercentageWidth(percentage: 3.5)
    
    lazy private var eventCategories: [PopsicleCategory] = [.Culture, .Social, .Food, .Sports, .Education]
    
    lazy private var containerStackView: UIStackView = {
        
        var containerStackView = UIStackView(arrangedSubviews: [popsicleIconImageView, categoryLabel, /*flavorLabel,*/ popsicleBorderImageView, descriptionLabel, pageIconsStackView])
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.distribution = .fill
        containerStackView.spacing = cellInnerInset
        return containerStackView
        
    }()
    
    lazy private(set) var popsicleIconImageView : UIImageView = {
        
        var popsicleIconImageView = UIImageView(image: PopsicleCategory.Default.getPopsicleCategoryIcon())
        popsicleIconImageView.contentMode = .scaleAspectFit
        return popsicleIconImageView
        
    }()
    
    lazy private(set) var categoryLabel: UILabel = {
        
        var categoryLabel = UILabel()
        categoryLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        categoryLabel.textColor = .white
        categoryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        categoryLabel.numberOfLines = 0
        categoryLabel.textAlignment = .center
        return categoryLabel
        
    }()
    
    /*lazy private(set) var flavorLabel: UILabel = {
        
        var flavorLabel = UILabel()
        flavorLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        flavorLabel.textColor = .white
        flavorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        flavorLabel.numberOfLines = 0
        flavorLabel.textAlignment = .center
        return flavorLabel
        
    }()*/
    
    lazy private(set) var popsicleBorderImageView : UIImageView = {
        
        var popsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder256.withTintColor(UIColor.white, renderingMode: .alwaysOriginal))
        popsicleBorderImageView.contentMode = .scaleAspectFill
        return popsicleBorderImageView
        
    }()
    
    lazy private(set) var descriptionLabel: UILabel = {
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        descriptionLabel.textColor = .white
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        return descriptionLabel
        
    }()
    
    lazy private(set) var pageIconsStackView: UIStackView = {
        
        var pageIconImageViews: [UIImageView] = []
        
        for _ in eventCategories {
            
            let pageIconImageView = UIImageView(image: UIImage.nonFilledPopsicleIcon128.withTintColor(UIColor.white, renderingMode: .alwaysOriginal))
            pageIconImageView.contentMode = .scaleAspectFit
            pageIconImageViews.append(pageIconImageView)
            
        }
        
        var pageIconsStackView = UIStackView(arrangedSubviews: pageIconImageViews)
        pageIconsStackView.axis = .horizontal
        pageIconsStackView.alignment = .fill
        pageIconsStackView.distribution = .equalCentering
        return pageIconsStackView
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellHorizontalEdgeInset*2).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellHorizontalEdgeInset*2).isActive = true
        
        popsicleIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleIconImageView.bottomAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        popsicleIconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        
        pageIconsStackView.translatesAutoresizingMaskIntoConstraints = false
        pageIconsStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.03).isActive = true
        pageIconsStackView.widthAnchor.constraint(equalTo: popsicleIconImageView.widthAnchor, multiplier: 1.4).isActive = true
        
        popsicleBorderImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleBorderImageView.widthAnchor.constraint(equalTo: popsicleIconImageView.widthAnchor, multiplier: 1.4).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

