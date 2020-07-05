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

class NewCreateEventViewController : UIViewController {
    
    var username: String?
    
    var eventNameText = "Add Title"
    
    var startDateText = "Start Date"
    
    var endDateText = "End Date"
    
    var locationText = "Location"
    
    var hashtagsText = "Add Hashtags"
    
    var detailsText = "Add details..."
    
    var coordinates: CLLocationCoordinate2D?
    
    lazy private var cancelButton: BubbleButton = {
        var cb = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .multiply, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .medium)).withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal))
        cb.backgroundColor = .white
        cb.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 2), left: .getPercentageWidth(percentage: 2), bottom: .getPercentageWidth(percentage: 2), right: .getPercentageWidth(percentage: 2))
        cb.addTarget(self, action: #selector(dismissCreateEvent), for: .touchUpInside)
        return cb
    }()
    
    @objc func dismissCreateEvent() {
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var gLayer : CAGradientLayer = {
        let g = CAGradientLayer()
        //g.type = .radial
        g.colors = [ UIColor.cultureLIGHTPURPLE.cgColor,
                     UIColor.cultureDARKPURPLE.cgColor]
//        g.locations = [ 0 , 1 ]
//        g.startPoint = CGPoint(x: 0.5, y: 0.5)
//        g.endPoint = CGPoint(x: 1.4, y: 1.15)
        g.frame = backgroundView.layer.bounds
        g.cornerRadius = 30
        return g
    }()
    
    lazy var eventLabel: UILabel = {
       let eventLabel = UILabel()
        eventLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title2)
        eventLabel.text = "what's your event about?"
        eventLabel.textAlignment = .center
        eventLabel.textColor = .black
       return eventLabel
    }()
    
    lazy var categoryCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .getPercentageWidth(percentage: 5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = UIColor(white: 1, alpha: 0.0)
        cv.dataSource = self
        cv.delegate = self
        //cv.isPagingEnabled = true
        //cv.contentInsetAdjustmentBehavior = .always
        cv.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // content padding so first cell appears in center of screen
        let leftPadding = CGFloat.getPercentageWidth(percentage: 10)
        let rightPadding = leftPadding
        
        cv.contentInset = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
        
        // hide the scroll indicator
        cv.showsHorizontalScrollIndicator = false
        return cv
        
    }()
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 30
        //backgroundView.backgroundColor = .showsPURPLE
        return backgroundView
    }()
    
    let cellReuseIdentifier = "cell"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        /* FOR TRIAL PURPOSES */
        modalPresentationStyle = .fullScreen
    }
    
    @objc func eventCreated(_ notification: Notification) {
        self.dismiss(animated: true, completion: nil)
       }
    
    @objc func switchCategory(_ notification: Notification) {
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
        cancelButton.isHidden = false
        eventLabel.isHidden = false
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.eventCreated(_:)), name: .eventCreated, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(self.switchCategory(_:)), name: .switchCategory, object: nil)
        
        view.backgroundColor = .cultureDARKPURPLE

        getUsername()
        
//        view.addSubview(backgroundView)
//        backgroundView.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
//        backgroundView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 90)).isActive = true
//        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        backgroundView.frame = CGRect(x: 0, y: 0, width: .getPercentageWidth(percentage: 90), height: .getPercentageHeight(percentage: 90))

        // gradient
        //backgroundView.layer.insertSublayer(gLayer, at: 0)
        

        // collection view
        view.addSubview(categoryCollectionView)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        categoryCollectionView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.5).isActive = true
        categoryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.3).isActive = true
        categoryCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
        // cancel button
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.bounds.height * 0.02).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.height * 0.02).isActive = true
        
        view.addSubview(eventLabel)
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        eventLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        eventLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: view.bounds.height * 0.02).isActive = true
        
       // eventLabel.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: backgroundView.bounds.height * 0).isActive = true
    }
    
    func getUsername(){
        let ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser!.uid
        ref.child("users/\(uid)/username").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? String
            
            
            self.username = "@" + (value!)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}

extension NewCreateEventViewController : UICollectionViewDataSource {
    // hardcode to show 10 cells, you can use array for this if you want
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CollectionViewCell
        switch (indexPath.row)   {
          case 0:
            //cell.contentView.backgroundColor = .purple
            cell.pImage.image = UIImage(named: "culturePopsicleIcon256")
            cell.popsicleLabel.text = "culture \"dragonfruit\""
            cell.descLabel.text = "You're doing it for the culture! Let everyone know that this is a cultural event that you wish to share."
            cell.pageOne.image = .culturePopsicleIcon256
            cell.pageTwo.image = .defaultPopsicleIcon256
            cell.pageThree.image = .defaultPopsicleIcon256
            cell.pageFour.image = .defaultPopsicleIcon256
            cell.pageFive.image = .defaultPopsicleIcon256
          case 1:
            //cell.contentView.backgroundColor = .red
            cell.pImage.image = UIImage(named: "educationPopsicleIcon256")
            cell.popsicleLabel.text = "education \"blueberry\""
            cell.descLabel.text = "There's always time to learn new things! Everyone who leaves your event will learn something new from it."
            cell.pageOne.image = .defaultPopsicleIcon256
            cell.pageTwo.image = .educationPopsicleIcon256
            cell.pageThree.image = .defaultPopsicleIcon256
            cell.pageFour.image = .defaultPopsicleIcon256
            cell.pageFive.image = .defaultPopsicleIcon256
          case 2:
            //cell.contentView.backgroundColor = .orange
            cell.pImage.image = UIImage(named: "foodPopsicleIcon256")
            cell.popsicleLabel.text = "food \"orange\""
            cell.descLabel.text = "Food is the fastest way to someones heart! No one shall leave your event on an empty stomach."
            cell.pageOne.image = .defaultPopsicleIcon256
            cell.pageTwo.image = .defaultPopsicleIcon256
            cell.pageThree.image = .foodPopsicleIcon256
            cell.pageFour.image = .defaultPopsicleIcon256
            cell.pageFive.image = .defaultPopsicleIcon256
          case 3:
            //cell.contentView.backgroundColor = .yellow
            cell.pImage.image = UIImage(named: "socialPopsicleIcon256")
            cell.popsicleLabel.text = "social \"strawberry\""
            cell.descLabel.text = "The core of any event, grab a group of people and go have yourselves some fun!"
            cell.pageOne.image = .defaultPopsicleIcon256
            cell.pageTwo.image = .defaultPopsicleIcon256
            cell.pageThree.image = .defaultPopsicleIcon256
            cell.pageFour.image = .socialPopsicleIcon256
            cell.pageFive.image = .defaultPopsicleIcon256
          case 4:
            //cell.contentView.backgroundColor = .green
            cell.pImage.image = UIImage(named: "sportsPopsicleIcon256")
            cell.popsicleLabel.text = "sports \"lime\""
            cell.descLabel.text = "Sports? E-Sports? It's going to be competitive regardless, may the best competitor win!"
            cell.pageOne.image = .defaultPopsicleIcon256
            cell.pageTwo.image = .defaultPopsicleIcon256
            cell.pageThree.image = .defaultPopsicleIcon256
            cell.pageFour.image = .defaultPopsicleIcon256
            cell.pageFive.image = .sportsPopsicleIcon256
        default:
           break
         }
        return cell
    }
}

// Cell height is equal to the collection view's height
// Cell width = cell height = collection view's height
extension NewCreateEventViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width * 0.8, height: collectionView.frame.size.height)
    }
    
}

extension NewCreateEventViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){

        // controls what happens when a card is clicked
        let vc = NewCreateEventCardViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.usernameLabel.text = username

     switch (indexPath.row)   {
         case 0:
            print("0")
            vc.backgroundGradientColors = [UIColor.cultureLIGHTPURPLE.cgColor, UIColor.cultureDARKPURPLE.cgColor ]
            print("OOOONNNNEEEE")
            self.present(vc, animated: true, completion: nil)
            print("TTTTWWWOOOOOO")
            
         case 1:
            print("1")
            vc.backgroundGradientColors = [ UIColor.educationLIGHTBLUE.cgColor, UIColor.educationDARKBLUE.cgColor ]
            self.present(vc, animated: true, completion: nil)
         case 2:
            print("2")
            vc.backgroundGradientColors = [ UIColor.foodLIGHTORANGE.cgColor, UIColor.foodDARKORANGE.cgColor ]
            self.present(vc, animated: true, completion: nil)
         case 3:
            print("3")
            vc.backgroundGradientColors = [ UIColor.socialLIGHTRED.cgColor, UIColor.socialDARKRED.cgColor ]
            self.present(vc, animated: true, completion: nil)
         case 4:
            print("4")
            vc.backgroundGradientColors = [ UIColor.sportsLIGHTGREEN.cgColor, UIColor.sportsDARKGREEN.cgColor ]
            self.present(vc, animated: true, completion: nil)
       default:
          break
        }

        vc.eventNameTextField.text = eventNameText
//              vc.startDateTextField.attributedPlaceholder = NSAttributedString(string: startDateText, attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-LightOblique", style: .title3), NSAttributedString.Key.foregroundColor : UIColor.white])
//              vc.endDateTextField.attributedPlaceholder = NSAttributedString(string: endDateText, attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-LightOblique", style: .title3), NSAttributedString.Key.foregroundColor : UIColor.white])
        vc.startDateTextField.text = startDateText
        vc.endDateTextField.text = endDateText
              vc.locationLabel.text = locationText
              vc.detailsButton.text = detailsText
              vc.hashtagTextView.text = hashtagsText
        
        if(locationText != "Location"){
            let allAnnotations = vc.mainMapView.annotations
            vc.mainMapView.removeAnnotations(allAnnotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates!
            
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            vc.location = coordinates
            vc.mainMapView.setRegion(region, animated: true)
            vc.mainMapView.addAnnotation(annotation)
            
            if(vc.eventNameTextField.text == "Add Title" || vc.hashtagTextView.text == "Add Hashtags" || vc.detailsButton.text == "Add details..." || vc.startDateTextField.text == "Start Date" || vc.endDateTextField.text == "End Date" || vc.locationLabel.text == "Location"){
                vc.createButton.isUserInteractionEnabled = false
                vc.createButton.alpha = 0.6
            }else{
                vc.createButton.isUserInteractionEnabled = true
                vc.createButton.alpha = 1.0
            }
        }
        
        categoryCollectionView.isHidden = true
        cancelButton.isHidden = true
        eventLabel.isHidden = true

    }
    
}

extension NewCreateEventViewController : UIScrollViewDelegate {
    
    // perform scaling whenever the collection view is being scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // center X of collection View
        let centerX = self.categoryCollectionView.center.x
    
        // only perform the scaling on cells that are visible on screen
        for cell in self.categoryCollectionView.visibleCells {
            
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterX = basePosition.x + self.categoryCollectionView.frame.size.height / 2.0
            
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
    
    // for custom snap-to paging, when user stop scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        var indexOfCellWithLargestWidth = 0
        var largestWidth : CGFloat = 1
        
        for cell in self.categoryCollectionView.visibleCells {
            if cell.frame.size.width > largestWidth {
                largestWidth = cell.frame.size.width
                if let indexPath = self.categoryCollectionView.indexPath(for: cell) {
                    indexOfCellWithLargestWidth = indexPath.item
                }
            }
        }

        categoryCollectionView.scrollToItem(at: IndexPath(item: indexOfCellWithLargestWidth, section: 0), at: .centeredHorizontally, animated: true)
        
        var bColor = UIColor()
        var secondColour = UIColor()
        switch (indexOfCellWithLargestWidth)   {
          case 0:
            bColor = .cultureLIGHTPURPLE
            secondColour = .cultureDARKPURPLE
          case 1:
            bColor = .educationLIGHTBLUE
            secondColour = .educationDARKBLUE
          case 2:
            bColor = .foodLIGHTORANGE
            secondColour = .foodDARKORANGE
          case 3:
            bColor = .socialLIGHTRED
            secondColour = .socialDARKRED
          case 4:
            bColor = .sportsLIGHTGREEN
            secondColour = .sportsDARKGREEN
        default:
           break
         }

        let newColors = [ secondColour.cgColor, secondColour.cgColor]
        
        // gradient color change animation
        let colorsAnimation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.colors))
        colorsAnimation.fromValue = gLayer.colors
        colorsAnimation.toValue = newColors
        colorsAnimation.duration = 4.0
        colorsAnimation.delegate = self
        colorsAnimation.fillMode = .forwards
        colorsAnimation.isRemovedOnCompletion = false
        //backgroundView.backgroundColor = bColor
        gLayer.add(colorsAnimation, forKey: "colors")
        gLayer.colors = newColors
        view.backgroundColor = secondColour
    }

}

class CollectionViewCell : UICollectionViewCell {
    
    lazy var pImage : UIImageView = {
        return UIImageView()
    }()
    
    lazy var popsicleLabel: UILabel = {
       let popsicleLabel = UILabel()
       popsicleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        popsicleLabel.textColor = .black
       popsicleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
       popsicleLabel.numberOfLines = 0
       popsicleLabel.textAlignment = .center
       return popsicleLabel
    }()
    
    lazy var descLabel: UILabel = {
       let descLabel = UILabel()
       descLabel.font = .dynamicFont(with: "Octarine-Light", style: .title2)
        descLabel.textColor = .black
       descLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
       descLabel.numberOfLines = 0
       descLabel.textAlignment = .center
       return descLabel
    }()
    
    lazy var pageOne: UIImageView = {
        let pageOne = UIImageView()
        pageOne.image = .culturePopsicleIcon256
        pageOne.contentMode = .scaleAspectFit
        return pageOne
    }()
    
    lazy var pageTwo: UIImageView = {
           let pageTwo = UIImageView()
           pageTwo.image = .defaultPopsicleIcon256
        pageTwo.contentMode = .scaleAspectFit
           return pageTwo
       }()
    
    lazy var pageThree: UIImageView = {
           let pageThree = UIImageView()
           pageThree.image = .defaultPopsicleIcon256
        pageThree.contentMode = .scaleAspectFit
           return pageThree
       }()
    
    lazy var pageFour: UIImageView = {
           let pageFour = UIImageView()
           pageFour.image = .defaultPopsicleIcon256
        pageFour.contentMode = .scaleAspectFit
           return pageFour
       }()
    
    lazy var pageFive: UIImageView = {
           let pageFour = UIImageView()
           pageFour.image = .defaultPopsicleIcon256
        pageFour.contentMode = .scaleAspectFit
           return pageFour
       }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        contentView.backgroundColor = .clear
//        contentView.layer.masksToBounds = false
//        contentView.layer.cornerRadius = 16
//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
//        contentView.layer.shadowOpacity = 0.3
//        contentView.layer.shadowRadius = 2
        
        pImage.contentMode = .scaleAspectFit
        
        contentView.addSubview(pImage)
        pImage.translatesAutoresizingMaskIntoConstraints = false
        pImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width * 0.5).isActive = true
        pImage.heightAnchor.constraint(equalToConstant: contentView.bounds.width * 0.5).isActive = true
        pImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 2)).isActive = true
        pImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        contentView.addSubview(popsicleLabel)
        popsicleLabel.translatesAutoresizingMaskIntoConstraints = false
        popsicleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        popsicleLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        popsicleLabel.topAnchor.constraint(equalTo: pImage.bottomAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        
        contentView.addSubview(descLabel)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        descLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        descLabel.topAnchor.constraint(equalTo: popsicleLabel.bottomAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        
        contentView.addSubview(pageThree)
        pageThree.translatesAutoresizingMaskIntoConstraints = false
        pageThree.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        pageThree.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: contentView.bounds.height * 0.05).isActive = true
        pageThree.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
         pageThree.widthAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        
        contentView.addSubview(pageFour)
        pageFour.translatesAutoresizingMaskIntoConstraints = false
        pageFour.centerXAnchor.constraint(equalTo: pageThree.leadingAnchor, constant: contentView.bounds.width * 0.15).isActive = true
        pageFour.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: contentView.bounds.height * 0.05).isActive = true
        pageFour.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
         pageFour.widthAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        
        contentView.addSubview(pageFive)
        pageFive.translatesAutoresizingMaskIntoConstraints = false
        pageFive.centerXAnchor.constraint(equalTo: pageFour.leadingAnchor, constant: contentView.bounds.width * 0.15).isActive = true
        pageFive.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: contentView.bounds.height * 0.05).isActive = true
        pageFive.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        pageFive.widthAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        
        contentView.addSubview(pageTwo)
        pageTwo.translatesAutoresizingMaskIntoConstraints = false
        pageTwo.centerXAnchor.constraint(equalTo: pageThree.trailingAnchor, constant: -contentView.bounds.width * 0.15).isActive = true
        pageTwo.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: contentView.bounds.height * 0.05).isActive = true
        pageTwo.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        pageTwo.widthAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        
        contentView.addSubview(pageOne)
        pageOne.translatesAutoresizingMaskIntoConstraints = false
        pageOne.centerXAnchor.constraint(equalTo: pageTwo.trailingAnchor, constant: -contentView.bounds.width * 0.15).isActive = true
        pageOne.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: contentView.bounds.height * 0.05).isActive = true
        pageOne.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        pageOne.widthAnchor.constraint(equalToConstant: contentView.bounds.height * 0.05).isActive = true
        

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewCreateEventViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            print("animation finished")
        }
    }
}

