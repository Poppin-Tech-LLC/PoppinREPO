//
//  ProfileViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/15/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import CoreLocation

protocol SwitchAccountDelegate: class {
    
    func closeSwitchAccount()
    func openSwitchAccount()
    
}

protocol ProfileActionsDelegate: class {
    
    func closeProfileActions()
    func openProfileActions()
    
}

final class ProfileViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var myEvents : [[PopsicleAnnotation]] = [[], [], []]
    
    
        
    func populateEvents() {
        
        let ref = Firestore.firestore().collection("users")
        let eref = Firestore.firestore().collection("privatePopsicles")

        ref.document(Auth.auth().currentUser!.uid).getDocument{ (document, error) in
        if let document = document, document.exists {

            let data = document.data()
            let myEvents = data?["myEvents"] as? [String] ?? []
             
            for event in myEvents {
                eref.document(event).getDocument{(document, error) in
                    if let document = document, document.exists {
                        
                        let data = document.data()
                        
                        let popUid = document.documentID
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        
                        let eventStartDate: Date = dateFormatter.date(from: data!["startDate"] as! String)!
                        let eventEndDate: Date = dateFormatter.date(from: data!["endDate"] as! String)!
                        let eventName = data!["eventName"] as! String
                        //let eventCategory = data!["category"] as! String
                        let createdById = data!["createdBy"] as! String
                        let hashtags = data!["hashtags"] as! String
                        let eventInfo = data!["eventDetails"] as! String
                        let latitude = data!["latitude"] as! CLLocationDegrees
                        let longitude = data!["longitude"] as! CLLocationDegrees
                        
                        /*let popsicleCategory: PopsicleCategory
                        
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
                        }*/
                        
                        let p = PopsicleAnnotation(eventTitle: eventName, eventDetails: eventInfo, eventStartDate: eventStartDate, eventEndDate: eventEndDate, eventCategory: EventCategory.Culture, eventHashtags: hashtags, eventLocation: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), eventAttendees: [], createdBy: createdById, isPublic: false, uid: popUid)
                        
                        if(Calendar.current.isDateInToday(eventStartDate)) {
                            self.myEvents[0].append(p)
                        } else if(eventStartDate < Date()) {
                            self.myEvents[2].append(p)
                        } else {
                            self.myEvents[1].append(p)
                        }
                        
                        print("t: \(self.myEvents[0].count) u: \(self.myEvents[1].count) p: \(self.myEvents[2].count)")
                        
                        self.myEventsFeed.reloadData()
                    }
                }
                
            }//for

            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        
        label.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        let sectionName: String
        switch section {
            case 0:
                sectionName = "Today"
            case 1:
                sectionName = "Upcoming week"
            case 2:
                sectionName = "Past"
            // ...
            default:
                sectionName = ""
        }
        label.text = sectionName
        label.textColor = .mainDARKPURPLE
        
        view.addSubview(label)
        view.backgroundColor = .white
    
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return myEvents[0].count
            case 1:
                return myEvents[1].count
            case 2:
                return myEvents[2].count
            // ...
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventsCell", for: indexPath) as! MyEventsCell
        
        let myTodayEvents = myEvents[0]
        let myUpcomingEvents = myEvents[1]
        let myPastEvents = myEvents[2]
        
        let rPG = Int.random(in: 1 ... 10000000)
        if(rPG < 10000) {
            cell.eventPG.text = "\(rPG)"
        } else if(rPG < 1000000) {
            cell.eventPG.text = "\(round(10.0*(Double(rPG)/1000.0))/10.0)K"
        } else {
            cell.eventPG.text = "\(round(10.0*(Double(rPG)/1000000.0))/10.0)M"
        }
        
        let pi = Bool.random()
        cell.privacyIcon.image =
            pi ?
            UIImage(systemSymbol: .lockFill).withTintColor(.mainDARKPURPLE).withRenderingMode(.alwaysOriginal) :
            UIImage(systemSymbol: .globe).withTintColor(.mainDARKPURPLE).withRenderingMode(.alwaysOriginal)
        
        if(indexPath.row < myTodayEvents.count) {
            
            let todayEvent = myTodayEvents[indexPath.row].popsicleAnnotationData
            
            cell.eventName.text = todayEvent.eventTitle
            
            /*switch(todayEvent.eventCategory) {
            case PopsicleCategory.Education :
                cell.eventPic.changeBouncyButtonImage(image: .educationPopsicleIcon256)
            case PopsicleCategory.Food :
                cell.eventPic.changeBouncyButtonImage(image: .foodPopsicleIcon256)
            case PopsicleCategory.Social :
                cell.eventPic.changeBouncyButtonImage(image: .socialPopsicleIcon256)
            case PopsicleCategory.Sports :
                cell.eventPic.changeBouncyButtonImage(image: .sportsPopsicleIcon256)
            case PopsicleCategory.Culture :
                cell.eventPic.changeBouncyButtonImage(image: .culturePopsicleIcon256)
            case PopsicleCategory.Poppin :
                cell.eventPic.changeBouncyButtonImage(image: .poppinEventPopsicleIcon256)
            default:
                cell.eventPic.changeBouncyButtonImage(image: .defaultPopsicleIcon256)
            }*/
            
            cell.eventPic.changeBouncyButtonImage(image: .culturePopsicleIcon256)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            cell.eventDate.text = "\(dateFormatter.string(from: todayEvent.eventStartDate))"
            
        } else if(indexPath.row < myTodayEvents.count + myUpcomingEvents.count) {
            
            let upcomingEvent = myUpcomingEvents[indexPath.row - myTodayEvents.count].popsicleAnnotationData
            
            cell.eventName.text = upcomingEvent.eventTitle
            /*switch(upcomingEvent.eventCategory) {
            case PopsicleCategory.Education :
                cell.eventPic.changeBouncyButtonImage(image: .educationPopsicleIcon256)
            case PopsicleCategory.Food :
                cell.eventPic.changeBouncyButtonImage(image: .foodPopsicleIcon256)
            case PopsicleCategory.Social :
                cell.eventPic.changeBouncyButtonImage(image: .socialPopsicleIcon256)
            case PopsicleCategory.Sports :
                cell.eventPic.changeBouncyButtonImage(image: .sportsPopsicleIcon256)
            case PopsicleCategory.Culture :
                cell.eventPic.changeBouncyButtonImage(image: .culturePopsicleIcon256)
            case PopsicleCategory.Poppin :
                cell.eventPic.changeBouncyButtonImage(image: .poppinEventPopsicleIcon256)
            default:
                cell.eventPic.changeBouncyButtonImage(image: .defaultPopsicleIcon256)
            }*/
            
            cell.eventPic.changeBouncyButtonImage(image: .culturePopsicleIcon256)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            cell.eventDate.text = "\(dateFormatter.string(from: upcomingEvent.eventStartDate))"
            
        } else {
            
            let pastEvent = myPastEvents[indexPath.row - (myTodayEvents.count + myUpcomingEvents.count)].popsicleAnnotationData
            
            cell.eventName.text = pastEvent.eventTitle
            /*switch(pastEvent.eventCategory) {
            case PopsicleCategory.Education :
                cell.eventPic.changeBouncyButtonImage(image: .educationPopsicleIcon256)
            case PopsicleCategory.Food :
                cell.eventPic.changeBouncyButtonImage(image: .foodPopsicleIcon256)
            case PopsicleCategory.Social :
                cell.eventPic.changeBouncyButtonImage(image: .socialPopsicleIcon256)
            case PopsicleCategory.Sports :
                cell.eventPic.changeBouncyButtonImage(image: .sportsPopsicleIcon256)
            case PopsicleCategory.Culture :
                cell.eventPic.changeBouncyButtonImage(image: .culturePopsicleIcon256)
            case PopsicleCategory.Poppin :
                cell.eventPic.changeBouncyButtonImage(image: .poppinEventPopsicleIcon256)
            default:
                cell.eventPic.changeBouncyButtonImage(image: .defaultPopsicleIcon256)
            }*/
            
            cell.eventPic.changeBouncyButtonImage(image: .culturePopsicleIcon256)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            cell.eventDate.text = "\(dateFormatter.string(from: pastEvent.eventStartDate))"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .getPercentageHeight(percentage: 7)
    }
    
    
    

    
    
    let profileInsetY: CGFloat = .getPercentageWidth(percentage: 4.3)
    let profileInsetX: CGFloat = .getPercentageWidth(percentage: 4.3)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 2.7)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 2.7)
    
    private var switchAccountHeight: CGFloat = .getPercentageHeight(percentage: 50)
    private var profileActionsHeight: CGFloat = .getPercentageHeight(percentage: 18)
    
    var switchAccountHeightAnchor:NSLayoutConstraint!
    
    private var switchAccountIsVisible: Bool = false
        
    private var profileActionsIsVisible: Bool = false
    
    private var isUser: Bool = false
    
    private var storage: Storage = Storage.storage()
    
    private var userData: UserData = UserData(username: "@username", uid: "", bio: "Bio", fullName: "Full Name")
    
    private var followers: String = "0" {
        
        didSet { followersButton.setTitle(followers, for: .normal) }
        
    }
    
    private var following: String = "0" {
        
        didSet { followingButton.setTitle(following, for: .normal) }
        
    }
    
    private var deleted: Bool = false
    private var deletedUid: String = ""
    
    private var profilePictureURL: URL? {
        
        didSet {
            
            profilePictureButton.sd_setImage(with: profilePictureURL, for: .normal, placeholderImage: UIImage.defaultUserPicture256, options: .continueInBackground, completed: nil)
            
        }
        
    }

    lazy private var fullNameLabel: UILabel = {
        
        var fullNameLabel = UILabel()
        fullNameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        fullNameLabel.textColor = UIColor.mainDARKPURPLE
        fullNameLabel.textAlignment = .center
        fullNameLabel.text = userData.fullName
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.heightAnchor.constraint(equalToConstant: fullNameLabel.intrinsicContentSize.height).isActive = true
        
        return fullNameLabel
        
    }()
    
    lazy private var usernameButton: BouncyButton = {
        
        var usernameButton = BouncyButton(bouncyButtonImage: nil)
        usernameButton.setTitle("@" + userData.username.lowercased(), for: .normal)
        usernameButton.titleLabel?.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        usernameButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        usernameButton.backgroundColor = .clear
        usernameButton.titleLabel?.textAlignment = .center
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.heightAnchor.constraint(equalToConstant: usernameButton.intrinsicContentSize.height).isActive = true
        return usernameButton
        
    }()
    
    lazy private var switchAccountViewController: SwitchAccountViewController = {
           
           var switchAccountViewController = SwitchAccountViewController()
           let accounts = DataController.getOtherAccounts()
           switchAccountViewController.delegate = self
           return switchAccountViewController
           
       }()
    
    private func fetchAccounts(){
        if(deleted){
            DataController.removeWithID(uid: deletedUid, entity: "OtherAccounts")
            DataController.save()
            deleted = false
        }
        let accounts = DataController.getOtherAccounts()
        let user  = DataController.getUser()
        
        let bio = user.value(forKey: "bio") as? String ?? ""
        let uid = user.value(forKey: "uid") as? String ?? ""
        let username = user.value(forKey: "username") as? String ?? ""
        let fullName = user.value(forKey: "fullName") as? String ?? ""
        
        let userToAdd = UserData(username: username, uid: uid, bio: bio, fullName: fullName)
        switchAccountViewController.accounts = [userToAdd]

        
        for account in accounts {
            let bio = account.value(forKey: "bio") as? String ?? ""
            let uid = account.value(forKey: "uid") as? String ?? ""
            let username = account.value(forKey: "username") as? String ?? ""
            let fullName = account.value(forKey: "fullName") as? String ?? ""
            print(username)
            
            let userToAdd = UserData(username: username, uid: uid, bio: bio, fullName: fullName)
            switchAccountViewController.accounts.append(userToAdd)

        }
        switchAccountHeight = .getPercentageHeight(percentage: CGFloat(((switchAccountViewController.accounts.count + 1) * 10) + 2))

        switchAccountViewController.accountsTable.reloadData()
    }
    
    lazy private var actionsButton: ImageBubbleButton = {
       let actionsButton = ImageBubbleButton(bouncyButtonImage: UIImage(systemSymbol: .gear, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .medium)).withTintColor(UIColor.mainDARKPURPLE))
        actionsButton.addTarget(self, action: #selector(openProfileActions(sender:)), for: .touchUpInside)
        
        actionsButton.translatesAutoresizingMaskIntoConstraints = false
        actionsButton.widthAnchor.constraint(equalTo: actionsButton.heightAnchor).isActive = true
        
        return actionsButton
    }()
    
    lazy private var profileActionsViewController: ProfileActionsViewController = {
            
        var profileActionsViewController = ProfileActionsViewController(with: userData.uid)
            //let accounts = DataController.getOtherAccounts()
            profileActionsViewController.delegate = self
            return profileActionsViewController
            
        }()
    
    lazy private var profileActionsTopConstraint: NSLayoutConstraint = {
        
        var profileActionsTopConstraint = NSLayoutConstraint(item: profileActionsViewController.view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: profileActionsHeight)
        return profileActionsTopConstraint
        
    }()
    
    lazy private var profileActionsSlidePanGestureRecognizer: UIPanGestureRecognizer = {
        
        var profileActionsSlidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleProfileActionsPan(sender:)))
        
        return profileActionsSlidePanGestureRecognizer
        
    }()
    
    lazy private var profileActionsCloseTapGestureRecognizer: UITapGestureRecognizer = {
        
        var profileActionsCloseTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeProfileActions(sender:)))
        return profileActionsCloseTapGestureRecognizer
        
    }()
    
    lazy private var switchAccountTopConstraint: NSLayoutConstraint = {
        
        var switchAccountTopConstraint = NSLayoutConstraint(item: switchAccountViewController.view!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: switchAccountHeight)
        return switchAccountTopConstraint
        
    }()
    
    lazy private var switchAccountSlidePanGestureRecognizer: UIPanGestureRecognizer = {
        
        var switchAccountSlidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleSwitchAccountPan(sender:)))
        
        return switchAccountSlidePanGestureRecognizer
        
    }()
    
    lazy private var switchAccountCloseTapGestureRecognizer: UITapGestureRecognizer = {
        
        var switchAccountCloseTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeSwitchAccount(sender:)))
        return switchAccountCloseTapGestureRecognizer
        
    }()
    
    lazy private var profileViewTopConstraint: NSLayoutConstraint = {
        
        var profileViewTopConstraint = NSLayoutConstraint(item: backgroundView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0)
        return profileViewTopConstraint
        
    }()

    
    lazy private var bioLabel: UILabel = {
        
        var bioLabel = UILabel()
        bioLabel.font = .dynamicFont(with: "Octarine-Light", style: .footnote)
        bioLabel.textColor = UIColor.mainDARKPURPLE
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.sizeToFit()
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        bioLabel.text = userData.bio
        
        if userData.bio == "" { bioLabel.isHidden = true }
        
        return bioLabel
        
    }()
    
    lazy private var followersButton: BouncyButton = {

        var followersButton = BouncyButton(bouncyButtonImage: nil)
        followersButton.backgroundColor = .clear
        followersButton.setTitleColor(UIColor.mainDARKPURPLE, for: .normal)
        followersButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Light", style: .footnote)
        followersButton.setTitle(followers, for: .normal)
        followersButton.titleLabel?.textAlignment = .center
        followersButton.addTarget(self, action: #selector(showFollowers), for: .touchUpInside)
        return followersButton
        
    }()
    
    lazy private var followersLabel: UILabel = {
        
        var followersLabel = UILabel()
        followersLabel.backgroundColor = .clear
        followersLabel.textColor = .mainDARKPURPLE
        followersLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1)
        followersLabel.text = "Followers"
        followersLabel.textAlignment = .center
        
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.heightAnchor.constraint(equalToConstant: followersLabel.intrinsicContentSize.height).isActive = true
        
        return followersLabel
        
    }()
    
    lazy private var followingButton: BouncyButton = {
        
        var followingButton = BouncyButton(bouncyButtonImage: nil)
        followingButton.backgroundColor = .clear
        followingButton.setTitleColor(UIColor.mainDARKPURPLE, for: .normal)
        followingButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Light", style: .footnote)
        followingButton.setTitle(following, for: .normal)
        followingButton.titleLabel?.textAlignment = .center
        followingButton.addTarget(self, action: #selector(showFollowing), for: .touchUpInside)
        return followingButton
        
    }()
    
    lazy private var followingLabel: UILabel = {
        
        var followingLabel = UILabel()
        followingLabel.backgroundColor = .clear
        followingLabel.textColor = .mainDARKPURPLE
        followingLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1)
        followingLabel.text = "Following"
        followingLabel.textAlignment = .center
        
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        followingLabel.heightAnchor.constraint(equalToConstant: followingLabel.intrinsicContentSize.height).isActive = true
        
        return followingLabel
        
    }()
    
    lazy private var myEventsFeed: UITableView = {
     
        var t = UITableView()
        t.backgroundColor = .clear
        t.isSpringLoaded = true
        t.allowsSelection = false
        t.showsHorizontalScrollIndicator = false
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        //t.separatorColor = .mainDARKPURPLE
        
        return t
        
    }()
    
    lazy private var profileContainerView: UIView = {
        
        let profileContainerStackView = UIStackView(arrangedSubviews: [fullNameLabel, bioLabel])
        profileContainerStackView.axis = .vertical
        profileContainerStackView.alignment = .fill
        profileContainerStackView.distribution = .fill
        profileContainerStackView.spacing = containerInsetY
        
        var profileContainerView = UIView()
        profileContainerView.backgroundColor = .white
        profileContainerView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
        profileContainerView.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: profileInsetY).isActive = true
        usernameButton.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
        
        profileContainerView.addSubview(profilePictureButton)
        profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
        profilePictureButton.topAnchor.constraint(equalTo: usernameButton.bottomAnchor, constant: containerInsetY).isActive = true
        profilePictureButton.widthAnchor.constraint(equalTo: profileContainerView.widthAnchor, multiplier: 0.23).isActive = true
        profilePictureButton.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
        
        profileContainerView.addSubview(followersLabel)
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.trailingAnchor.constraint(equalTo: profilePictureButton.leadingAnchor, constant: -containerInsetX).isActive = true
        followersLabel.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: profileInsetX).isActive = true
        followersLabel.topAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
        
        profileContainerView.addSubview(profileBackButton)
        profileBackButton.translatesAutoresizingMaskIntoConstraints = false
        profileBackButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor).isActive = true
        profileBackButton.heightAnchor.constraint(equalTo: usernameButton.heightAnchor, multiplier: 0.8).isActive = true
        profileBackButton.leadingAnchor.constraint(equalTo: followersLabel.leadingAnchor).isActive = true
        
        profileContainerView.addSubview(followersButton)
        followersButton.translatesAutoresizingMaskIntoConstraints = false
        followersButton.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
        followersButton.bottomAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
        
        profileContainerView.addSubview(followingLabel)
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        followingLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -profileInsetX).isActive = true
        followingLabel.leadingAnchor.constraint(equalTo: profilePictureButton.trailingAnchor, constant: containerInsetX).isActive = true
        followingLabel.topAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
        
        profileContainerView.addSubview(actionsButton)
        actionsButton.translatesAutoresizingMaskIntoConstraints = false
        actionsButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor).isActive = true
        actionsButton.heightAnchor.constraint(equalTo: usernameButton.heightAnchor, multiplier: 0.8).isActive = true
        actionsButton.trailingAnchor.constraint(equalTo: followingLabel.trailingAnchor).isActive = true
        
        
        profileContainerView.addSubview(followingButton)
        followingButton.translatesAutoresizingMaskIntoConstraints = false
        followingButton.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor).isActive = true
        followingButton.bottomAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
        
        profileContainerView.addSubview(profileContainerStackView)
        profileContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        profileContainerStackView.topAnchor.constraint(equalTo: profilePictureButton.bottomAnchor, constant: containerInsetY).isActive = true
        profileContainerStackView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: containerInsetX).isActive = true
        profileContainerStackView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -containerInsetX).isActive = true
        
        profileContainerView.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.topAnchor.constraint(equalTo: profileContainerStackView.bottomAnchor, constant: containerInsetY).isActive = true
        followButton.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
        
        profileContainerView.addSubview(myEventsFeed)
        myEventsFeed.translatesAutoresizingMaskIntoConstraints = false
        myEventsFeed.topAnchor.constraint(equalTo: followButton.bottomAnchor, constant: containerInsetY).isActive = true
        myEventsFeed.bottomAnchor.constraint(equalTo: profileContainerView.bottomAnchor, constant: -containerInsetY).isActive = true
        myEventsFeed.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: containerInsetX/2).isActive = true
        myEventsFeed.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -containerInsetX/2).isActive = true
        
        myEventsFeed.dataSource = self
        myEventsFeed.delegate = self
        myEventsFeed.register(MyEventsCell.self, forCellReuseIdentifier: "myEventsCell")
        
        return profileContainerView
        
    }()
    
    lazy private var backgroundView: UIView = {
        
        let backgroundImageView = UIImageView(image: UIImage.appBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        
        var backgroundView = UIView()
        backgroundView.backgroundColor = .poppinLIGHTGOLD
        
        backgroundView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        
        return backgroundView
        
    }()
    
    lazy private var profilePictureButton: ImageBubbleButton = {
        
        var profilePictureButton = ImageBubbleButton(bouncyButtonImage: UIImage.defaultUserPicture256)
        profilePictureButton.imageView?.contentMode = .scaleToFill
        profilePictureButton.addTarget(self, action: #selector(displayImageViewController), for: .touchUpInside)
        
        profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
        profilePictureButton.heightAnchor.constraint(equalTo: profilePictureButton.widthAnchor).isActive = true
        
        return profilePictureButton
        
    }()
    
    lazy private var followButton: BouncyButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 1.8)
        
        var followButton = BouncyButton(bouncyButtonImage: nil)
        followButton.titleLabel!.textAlignment = .center
        followButton.titleLabel!.font = .dynamicFont(with: "Octarine-Bold", style: .caption1)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = .mainDARKPURPLE
        followButton.contentEdgeInsets = UIEdgeInsets(top: innerEdgeInset, left: innerEdgeInset*2, bottom: innerEdgeInset, right: innerEdgeInset*2)
        followButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        
        return followButton
        
    }()
    
    lazy private var profileBackButton: BouncyButton = {
        
        var profileBackButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .medium)).withTintColor(UIColor.mainDARKPURPLE))
       profileBackButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
       
       profileBackButton.translatesAutoresizingMaskIntoConstraints = false
       profileBackButton.widthAnchor.constraint(equalTo: profileBackButton.heightAnchor).isActive = true
       
       return profileBackButton
        
    }()
    
    init(with data: UserData, isUser: Bool) {
        
        super.init(nibName: nil, bundle: nil)
        
        userData = data
        self.isUser = isUser
        if(isUser){
            followButton.setTitle("Edit Profile", for: .normal)
            followButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
            fetchAccounts()
            actionsButton.isHidden = true
            usernameButton.addTarget(self, action: #selector(openSwitchAccount(sender:)), for: .touchUpInside)
        }else{
            followButton.setTitle("Follow", for: .normal)
            followButton.removeTarget(self, action: #selector(editProfile), for: .touchUpInside)
            followButton.addTarget(self, action: #selector(performFollow), for: .touchUpInside)
            actionsButton.isHidden = false
        }
        fetchFollowersFollowingPicture()

    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    @objc func deletedOrg(_ notification: Notification) {
        let index = IndexPath(row: 1, section: 0)
         deletedUid = userData.uid
        deleted = true
        switchAccountViewController.accountsTable.delegate?.tableView!(switchAccountViewController.accountsTable, didSelectRowAt: index)
    }
    
    @objc func editedProfile(_ notification: Notification) {
        usernameButton.setTitle(MapViewController.username, for: .normal)
        fullNameLabel.text = MapViewController.fullName
        bioLabel.text = MapViewController.bio
        userData.bio = MapViewController.bio
        userData.username = MapViewController.username
        userData.fullName = MapViewController.fullName
        userData.uid = MapViewController.uid
        fetchFollowersFollowingPicture()
        fetchAccounts()
        switchAccountHeightAnchor.constant = switchAccountHeight
        switchAccountTopConstraint.constant = switchAccountHeight

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editedProfile(_:)), name: .editedProfile, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletedOrg(_:)), name: .deletedOrg, object: nil)
        
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileViewTopConstraint.isActive = true
        
        view.addSubview(profileContainerView)
        profileContainerView.translatesAutoresizingMaskIntoConstraints = false
        profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: profileInsetY).isActive = true
        profileContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -profileInsetY).isActive = true
        profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: profileInsetX).isActive = true
        profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -profileInsetX).isActive = true
        
        addChild(switchAccountViewController)
        
        view.addSubview(switchAccountViewController.view)
        switchAccountViewController.view.translatesAutoresizingMaskIntoConstraints = false
        switchAccountViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        switchAccountViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        switchAccountTopConstraint.isActive = true
        switchAccountHeightAnchor = switchAccountViewController.view.heightAnchor.constraint(equalToConstant: switchAccountHeight)
        switchAccountHeightAnchor.isActive = true
        
        switchAccountViewController.didMove(toParent: self)
        
        addChild(profileActionsViewController)
               
        view.addSubview(profileActionsViewController.view)
        profileActionsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        profileActionsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileActionsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileActionsTopConstraint.isActive = true
        profileActionsViewController.view.heightAnchor.constraint(equalToConstant: profileActionsHeight).isActive = true
        //sprofileAHeightAnchor.isActive = true
        
        profileActionsViewController.didMove(toParent: self)

        populateEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
                
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    @objc private func displayImageViewController() {
        
        let profileImageVC = ProfileImageViewController(profileImage: profilePictureButton.image(for: .normal))
        
        self.present(profileImageVC, animated: true, completion: nil)
        
    }
    
    @objc func transitionToPreviousPage() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func editProfile() {
        let vc = EditProfileViewController(with: userData, newUser: false, followerCount: followers, followingCount: following)
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func performFollow() {
        
        let userId = MapViewController.uid
                
        let followerRef = Firestore.firestore().collection("followers").document(userData.uid)
        let followingRef = Firestore.firestore().collection("following").document(userId)

        if followButton.titleLabel!.text == "Following" {
            
            let button1 = AlertButton(alertTitle: "Cancel", alertButtonAction: nil)
            
            let button2 = AlertButton(alertTitle: "Unfollow", alertButtonAction: {
                
                followerRef.updateData(["followers" : FieldValue.arrayRemove([userId])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
                followerRef.updateData(["followerCount" : FieldValue.increment(Int64(-1))]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
                followingRef.updateData(["followingCount" : FieldValue.increment(Int64(-1))]){ err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }

                followingRef.updateData(["following" : FieldValue.arrayRemove([self.userData.uid])
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        self.followButton.setTitle("Follow", for: .normal)
                        self.followButton.setTitleColor(.white, for: .normal)
                        self.followButton.backgroundColor = .mainDARKPURPLE
                        self.followers = String(Int(self.followers)! - 1)
                        let id = ["uid": self.userData.uid]

                        NotificationCenter.default.post(name: .unfollowedUser, object: self, userInfo: id)

                    }
                }

                
            })
            
            let alertVC = AlertViewController(alertTitle: "Unfollow " + userData.fullName, alertMessage: "Are you sure you wish to unfollow this user?", alertButtons: [button1, button2])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            
            followerRef.updateData(["followers" : FieldValue.arrayUnion([userId])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            followerRef.updateData(["followerCount" : FieldValue.increment(Int64(1))]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            
            followingRef.updateData(["followingCount" : FieldValue.increment(Int64(1))]){ err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }

            followingRef.updateData(["following" : FieldValue.arrayUnion([userData.uid])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    self.followers = String(Int(self.followers)! + 1)
                    
                    self.followButton.setTitle("Following", for: .normal)
                    self.followButton.setTitleColor(.mainDARKPURPLE, for: .normal)
                    self.followButton.backgroundColor = .white
                    let id = ["uid": self.userData.uid]

                    NotificationCenter.default.post(name: .followedUser, object: self, userInfo: id)

                    //self.mapDelegate?.getPopsicleFromUser(uid: self.userData.uid)

                }
            }

            // create activity for following someone
            Firestore.firestore().collection("users").document(userId).getDocument { (document, error) in
                
                if let document = document, document.exists {

                    let username = (document.data()!["username"] as? String)!
                    
                    Firestore.firestore().collection("users").document(self.userData.uid).collection("activities").addDocument(data: [
                        "inducedBy" : username,
                        "details" : " started following you.",
                        "dateInduced" : Date().toString(.custom("yyyy'-'MM'-'dd' 'HH':'mm'"))])
                    { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added.")
                        }
                    }
                    
                } else {
                        print("Document does not exist")
                }
            }
            
            
        }
        
    }
    
    
    @objc private func openProfileActions(sender: BouncyButton) {
          
          openProfileActions()
          
      }

    
    @objc private func closeProfileActions(sender: BouncyButton) {
           
           closeProfileActions()

       }

    
    @objc private func handleProfileActionsPan(sender: UIPanGestureRecognizer) {
           
           let translation = sender.translation(in: self.view)
           
           if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
               
               if profileActionsIsVisible, translation.y > 0 {
                   closeProfileActions()
               } else if !profileActionsIsVisible, translation.y < 0 {
                   openProfileActions()
               }
               
               return
               
           }
           
           if !profileActionsIsVisible, translation.y < 0.0, translation.y >= -profileActionsHeight {
               
               let alphaFactorContainerView = 1.2 - ((translation.y * 0.8) / profileActionsHeight)
               
              // backgroundView.alpha = alphaFactorContainerView
               profileContainerView.alpha = alphaFactorContainerView
               
               profileActionsTopConstraint.constant = translation.y - profileActionsHeight
               
           }
           
           if profileActionsIsVisible, translation.y <= profileActionsHeight, translation.y > 0.0{
               
               let alphaFactorContainerView = 0.2 + ((0.8 * translation.y) / profileActionsHeight)
               
               //backgroundView.alpha = alphaFactorContainerView
               profileContainerView.alpha = alphaFactorContainerView

               
               profileActionsTopConstraint.constant = translation.y
               
           }
           
       }
    
    @objc private func openSwitchAccount(sender: BouncyButton) {
          
          openSwitchAccount()
          
      }

    
    @objc private func closeSwitchAccount(sender: BouncyButton) {
           
           closeSwitchAccount()

       }

    
    @objc private func handleSwitchAccountPan(sender: UIPanGestureRecognizer) {
           
           let translation = sender.translation(in: self.view)
           
           if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
               
               if switchAccountIsVisible, translation.y > 0 {
                   closeSwitchAccount()
               } else if !switchAccountIsVisible, translation.y < 0 {
                   openSwitchAccount()
               }
               
               return
               
           }
           
           if !switchAccountIsVisible, translation.y < 0.0, translation.y >= -switchAccountHeight {
               
               let alphaFactorContainerView = 1.2 - ((translation.y * 0.8) / switchAccountHeight)
               
               backgroundView.alpha = alphaFactorContainerView
               profileContainerView.alpha = alphaFactorContainerView
               
               switchAccountTopConstraint.constant = translation.y - switchAccountHeight
               
           }
           
           if switchAccountIsVisible, translation.y <= switchAccountHeight, translation.y > 0.0{
               
               let alphaFactorContainerView = 0.2 + ((0.8 * translation.y) / switchAccountHeight)
               
               backgroundView.alpha = alphaFactorContainerView
               profileContainerView.alpha = alphaFactorContainerView

               
               switchAccountTopConstraint.constant = translation.y
               
           }
           
       }
    
    @objc private func showFollowers(){
        let searchVC = SearchViewController(searchTypes: [.Followers, .Following], startIndex: 0, userID: userData.uid, username: userData.username, shouldActivateSearchBar: false, alwaysShowsCancelButton: false)
        navigationController?.pushViewController(searchVC, animated: true)

    }
    
    @objc func showFollowing(){
        
        let searchVC = SearchViewController(searchTypes: [.Followers, .Following], startIndex: 1, userID: userData.uid, username: userData.username, shouldActivateSearchBar: false, alwaysShowsCancelButton: false)
         navigationController?.pushViewController(searchVC, animated: true)

     }
    
    private func fetchFollowersFollowingPicture() {
        
        var uid: String
        
        if(isUser){
            uid = MapViewController.uid
        }else{
            uid = userData.uid
        }
        
        let ref2 = storage.reference().child("images/\(uid)/profilepic.jpg")
        
        let followerRef = Firestore.firestore().collection("followers").document(uid)
        let followingRef = Firestore.firestore().collection("following").document(uid)

        
        followerRef.getDocument{ (document, error) in
        if let document = document, document.exists {
            let data = document.data()
            let followerCount = data?["followerCount"] as? Int ?? 0
            let followers = data?["followers"] as? [String] ?? []
            
            self.followers = String(followerCount)
            
            if(!self.isUser){
                if(followers.contains(MapViewController.uid)){
                    self.followButton.setTitle("Following", for: .normal)
                    self.followButton.setTitleColor(.mainDARKPURPLE, for: .normal)
                    self.followButton.backgroundColor = .white
                }else{
                    self.followButton.setTitle("Follow", for: .normal)
                    self.followButton.setTitleColor(.white, for: .normal)
                    self.followButton.backgroundColor = .mainDARKPURPLE
                }
            }

        } else {
            print("Document does not exist")
        }
        }
            
            followingRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    let followingCount = data?["followingCount"] as? Int ?? 0
                    
                    self.following = String(followingCount)
                    
                    
                } else {
                    print("Document does not exist")
                }
            }
        
        ref2.downloadURL { [weak self] url, error in
            
            guard let self = self else { return }
            
            if error != nil {
                
                print("Error: Unable to download profile image.")

            } else {

                self.profilePictureURL = url
                
            }
            
        }
        
    }
    
}

extension ProfileViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}

final class ProfileImageViewController: UIViewController {
    
    private var profileImage: UIImage = UIImage.defaultUserPicture256
    
    lazy var profileImageView: BubbleImageView = {
        
        var profileImageView = BubbleImageView(image: profileImage)
        profileImageView.contentMode = .scaleAspectFill
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true
        
        return profileImageView
        
    }()
    
    lazy var tapToHideLabel: UILabel = {
        
        var tapToHideLabel = UILabel()
        tapToHideLabel.text = "Tap anywhere to hide"
        tapToHideLabel.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        tapToHideLabel.textColor = .white
        tapToHideLabel.textAlignment = .center
        
        tapToHideLabel.translatesAutoresizingMaskIntoConstraints = false
        tapToHideLabel.heightAnchor.constraint(equalToConstant: tapToHideLabel.intrinsicContentSize.height).isActive = true
        tapToHideLabel.widthAnchor.constraint(equalToConstant: tapToHideLabel.intrinsicContentSize.width).isActive = true
        
        return tapToHideLabel
        
    }()
    
    init(profileImage: UIImage?) {
        
        super.init(nibName: nil, bundle: nil)

        if let profileImage = profileImage { self.profileImage = profileImage }
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(transitionToPreviousPage)))
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)

        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        
        view.addSubview(tapToHideLabel)
        tapToHideLabel.translatesAutoresizingMaskIntoConstraints = false
        tapToHideLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: .getPercentageWidth(percentage: 5)).isActive = true
        tapToHideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        

    }
    
    @objc private func transitionToPreviousPage() {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

extension ProfileViewController: SwitchAccountDelegate {

    
    func closeSwitchAccount() {
        
        if switchAccountIsVisible {
         
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.switchAccountTopConstraint.constant = self.switchAccountHeight
                self.backgroundView.alpha = 1.0
                self.profileContainerView.alpha = 1.0
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
                
                self.backgroundView.removeGestureRecognizer(self.switchAccountSlidePanGestureRecognizer)
                
                self.switchAccountIsVisible = false
                self.backgroundView.removeGestureRecognizer(self.switchAccountCloseTapGestureRecognizer)
                self.profileContainerView.isUserInteractionEnabled = true
                
            })
            
        }
        
    }
    
    
    func openSwitchAccount() {
     
        if(!switchAccountIsVisible) {
        
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.switchAccountTopConstraint.constant = 0
                self.backgroundView.alpha = 0.2
                self.profileContainerView.alpha = 0.2
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
            
                self.view.addGestureRecognizer(self.switchAccountSlidePanGestureRecognizer)
                
                self.switchAccountIsVisible = true
                self.backgroundView.addGestureRecognizer(self.switchAccountCloseTapGestureRecognizer)
                self.profileContainerView.isUserInteractionEnabled = false
            

            })
            
        }
    }
}

class MyEventsCell : UITableViewCell {
    
    lazy var eventPic : ImageBubbleButton = {
        
        var i = ImageBubbleButton(bouncyButtonImage: .defaultPopsicleIcon128)
        i.backgroundColor = UIColor.mainDARKPURPLE.withAlphaComponent(0.25)
        i.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 1), left: .getPercentageWidth(percentage: 1), bottom: .getPercentageWidth(percentage: 1), right: .getPercentageWidth(percentage: 1))
        
        i.translatesAutoresizingMaskIntoConstraints = false
        i.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 9)).isActive = true
        i.heightAnchor.constraint(equalTo: i.widthAnchor).isActive = true
        
        return i
        
    }()
    
    lazy var eventName : UILabel = {
        
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .mainDARKPURPLE
        l.numberOfLines = 1
        l.textAlignment = .left
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 50)).isActive = true
        
        return l
        
    }()
    
    lazy var privacyIcon : UIImageView = {
        
        let g = UIImageView(image: UIImage(systemSymbol: .lockFill).withTintColor(.mainDARKPURPLE).withRenderingMode(.alwaysOriginal))
        g.contentMode = .scaleAspectFit
        
        g.translatesAutoresizingMaskIntoConstraints = false
        g.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 4)).isActive = true
        
        return g
        
    }()
    
    lazy var PGIcon : UIImageView = {
        
        let g = UIImageView(image: UIImage(systemSymbol: .person3Fill).withTintColor(.mainDARKPURPLE).withRenderingMode(.alwaysOriginal))
        g.contentMode = .scaleAspectFit
        
        g.translatesAutoresizingMaskIntoConstraints = false
        g.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 7)).isActive = true
        
        return g
        
    }()
    
    lazy var eventPG : UILabel = {
        
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .caption1)
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .mainDARKPURPLE
        l.numberOfLines = 1
        l.textAlignment = .left
               
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 12)).isActive = true
               
        return l
        
    }()
    
    lazy var eventShare : BouncyButton = {
        var g = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .arrowUpRightSquareFill).withTintColor(.mainDARKPURPLE))
        return g
    }()
    
    lazy var eventDate : UILabel = {
        
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .gray
        l.numberOfLines = 1
        l.textAlignment = .center
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 13)).isActive = true
        
        return l
        
    }()
    
    lazy var eventActionStackView : UIStackView = {
        
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .fill
        
        s.addArrangedSubview(privacyIcon)
        s.addArrangedSubview(PGIcon)
        s.addArrangedSubview(eventPG)
        s.addArrangedSubview(eventShare)

        s.setCustomSpacing(.getPercentageWidth(percentage: 10), after: privacyIcon)
        s.setCustomSpacing(.getPercentageWidth(percentage: 1.25), after: PGIcon)
        s.setCustomSpacing(.getPercentageWidth(percentage: 7), after: eventPG)
        
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
        
    }()
    
    lazy var eventInfoStackView : UIStackView = {
        
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .leading
        s.distribution = .equalCentering
        
        s.addArrangedSubview(eventName)
        s.addArrangedSubview(eventActionStackView)
        
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
        
    }()
    
    lazy var eventStackView : UIStackView = {
        
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .equalCentering
        
        s.addArrangedSubview(eventPic)
        s.addArrangedSubview(eventInfoStackView)
        s.addArrangedSubview(eventDate)
        
        s.setCustomSpacing(.getPercentageWidth(percentage: 3), after: eventPic)
        s.setCustomSpacing(.getPercentageWidth(percentage: 2), after: eventInfoStackView)
        
        s.translatesAutoresizingMaskIntoConstraints = false
        
        return s
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear

        self.contentView.backgroundColor = .white
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.cornerCurve = .continuous
        
        self.contentView.addSubview(eventStackView)
        
        eventName.text = "Edu & Sofie's bday bash"
        eventPG.text = "256"
        eventDate.text = "7:00 pm"
        
        eventStackView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        eventStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .getPercentageWidth(percentage: 5)).isActive = true
        eventStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -.getPercentageWidth(percentage: 5)).isActive = true
        eventStackView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        
     }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: .getPercentageHeight(percentage: 0.5), left: 0, bottom: .getPercentageHeight(percentage: 0.5), right: 0))
    }
                }
    


extension ProfileViewController: ProfileActionsDelegate {

    
    func closeProfileActions() {
        
        if profileActionsIsVisible {
         
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.profileActionsTopConstraint.constant = self.profileActionsHeight
                //self.backgroundView.alpha = 1.0
                self.profileContainerView.alpha = 1.0
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
                
                self.backgroundView.removeGestureRecognizer(self.profileActionsSlidePanGestureRecognizer)
                
                self.profileActionsIsVisible = false
                self.backgroundView.removeGestureRecognizer(self.profileActionsCloseTapGestureRecognizer)
                self.profileContainerView.isUserInteractionEnabled = true
                
            })
            
        }
        
    }
    
    
    func openProfileActions() {
     
        if(!profileActionsIsVisible) {
        
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.profileActionsTopConstraint.constant = 0
              //  self.backgroundView.alpha = 0.2
                self.profileContainerView.alpha = 0.2
                self.view.layoutIfNeeded()
                
            }, completion: { finished in
            
                self.view.addGestureRecognizer(self.profileActionsSlidePanGestureRecognizer)
                
                self.profileActionsIsVisible = true
                self.backgroundView.addGestureRecognizer(self.profileActionsCloseTapGestureRecognizer)
                self.profileContainerView.isUserInteractionEnabled = false
            
            })
            
        }
        
    }
    
}

