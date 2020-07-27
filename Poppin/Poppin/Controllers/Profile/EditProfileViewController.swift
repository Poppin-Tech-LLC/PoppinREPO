//
//  EditProfileViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 7/15/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import Geofirestore
import FirebaseStorage

class EditProfileViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

      let profileInsetY: CGFloat = .getPercentageWidth(percentage: 4.3)
        let profileInsetX: CGFloat = .getPercentageWidth(percentage: 4.3)
        
        let containerInsetY: CGFloat = .getPercentageWidth(percentage: 2.7)
        let containerInsetX: CGFloat = .getPercentageWidth(percentage: 2.7)
        
        private var storage: Storage = Storage.storage()
    
    private var newUser: Bool = false
        
        private var userData: UserData = UserData(username: "@username", uid: "", bio: "Bio", fullName: "Full Name")
        
        private var profilePictureURL: URL? {
            
            didSet {
                
                profilePictureButton.sd_setImage(with: profilePictureURL, for: .normal, placeholderImage: UIImage.defaultUserPicture256, options: .continueInBackground, completed: nil)
                
            }
            
        }

        lazy private var fullNameTextField: UITextField = {
            
            var fullNameTextField = UITextField()
            fullNameTextField.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
            fullNameTextField.textColor = UIColor.mainDARKPURPLE
            fullNameTextField.textAlignment = .center
            fullNameTextField.text = userData.fullName
            fullNameTextField.backgroundColor = .clear
            fullNameTextField.clearButtonMode = .whileEditing
            fullNameTextField.returnKeyType = .next
            fullNameTextField.autocapitalizationType = .none
            fullNameTextField.autocorrectionType = .no
            fullNameTextField.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
            fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
            fullNameTextField.heightAnchor.constraint(equalToConstant: fullNameTextField.intrinsicContentSize.height).isActive = true
            
            return fullNameTextField
            
        }()
        
        lazy private var usernameTextField: UITextField = {
            
            var usernameTextField = UITextField()
            usernameTextField.text = userData.username.lowercased()
            usernameTextField.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
            usernameTextField.textColor = .mainDARKPURPLE
            usernameTextField.backgroundColor = .clear
            usernameTextField.textAlignment = .center
            usernameTextField.clearButtonMode = .whileEditing
            usernameTextField.returnKeyType = .next
            usernameTextField.autocapitalizationType = .none
            usernameTextField.autocorrectionType = .no
            usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .footnote), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])

            usernameTextField.translatesAutoresizingMaskIntoConstraints = false
            usernameTextField.heightAnchor.constraint(equalToConstant: usernameTextField.intrinsicContentSize.height).isActive = true

            return usernameTextField
            
        }()

        lazy private var bioTextView: UITextView = {
            
            var bioTextView = UITextView()
            bioTextView.font = .dynamicFont(with: "Octarine-Light", style: .footnote)
            bioTextView.textColor = UIColor.mainDARKPURPLE
            bioTextView.isScrollEnabled = false
            bioTextView.sizeToFit()
            bioTextView.textAlignment = .center
            bioTextView.text = userData.bio
            bioTextView.delegate = self
            if(bioTextView.text == ""){
                bioTextView.text = "Insert Bio..."
            }
            bioTextView.returnKeyType = .next
            bioTextView.autocapitalizationType = .none
            bioTextView.autocorrectionType = .no
            return bioTextView
            
        }()
        
        lazy private var followersCountLabel: UILabel = {

            var followersCountLabel = UILabel()
            followersCountLabel.backgroundColor = .clear
            followersCountLabel.textColor = .mainDARKPURPLE
            followersCountLabel.font = UIFont.dynamicFont(with: "Octarine-Light", style: .footnote)
            followersCountLabel.textAlignment = .center
            return followersCountLabel
            
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
        
        lazy private var followingLabel: UILabel = {
            
            var followingLabel = UILabel()
            followingLabel.backgroundColor = .clear
            followingLabel.textColor = .mainDARKPURPLE
            followingLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)
            followingLabel.text = "Following"
            followingLabel.textAlignment = .center
            
            followingLabel.translatesAutoresizingMaskIntoConstraints = false
            followingLabel.heightAnchor.constraint(equalToConstant: followingLabel.intrinsicContentSize.height).isActive = true
            
            return followingLabel
            
        }()
        
        lazy private var followingCountLabel: UILabel = {
            
            var followingCountLabel = UILabel()
            followingCountLabel.backgroundColor = .clear
            followingCountLabel.textColor = .mainDARKPURPLE
            followingCountLabel.font = UIFont.dynamicFont(with: "Octarine-Light", style: .caption1)
            followingCountLabel.textAlignment = .center
            
            return followingCountLabel
            
        }()
        
        lazy private var profileContainerView: UIView = {
            
            let profileContainerStackView = UIStackView(arrangedSubviews: [fullNameTextField, bioTextView])
            profileContainerStackView.axis = .vertical
            profileContainerStackView.alignment = .fill
            profileContainerStackView.distribution = .fill
            profileContainerStackView.spacing = containerInsetY
            
            var profileContainerView = UIView()
            profileContainerView.backgroundColor = .white
            profileContainerView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
            
            profileContainerView.addSubview(usernameTextField)
            usernameTextField.translatesAutoresizingMaskIntoConstraints = false
            usernameTextField.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: profileInsetY).isActive = true
            usernameTextField.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
            
            profileContainerView.addSubview(profilePictureButton)
            profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
            profilePictureButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: containerInsetY).isActive = true
            profilePictureButton.widthAnchor.constraint(equalTo: profileContainerView.widthAnchor, multiplier: 0.23).isActive = true
            profilePictureButton.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
            
            profileContainerView.addSubview(followersLabel)
            followersLabel.translatesAutoresizingMaskIntoConstraints = false
            followersLabel.trailingAnchor.constraint(equalTo: profilePictureButton.leadingAnchor, constant: -containerInsetX).isActive = true
            followersLabel.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: profileInsetX).isActive = true
            followersLabel.topAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
            
            profileContainerView.addSubview(profileBackButton)
            profileBackButton.translatesAutoresizingMaskIntoConstraints = false
            profileBackButton.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
            profileBackButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor, multiplier: 0.8).isActive = true
            profileBackButton.leadingAnchor.constraint(equalTo: followersLabel.leadingAnchor).isActive = true
            
            profileContainerView.addSubview(followersCountLabel)
            followersCountLabel.translatesAutoresizingMaskIntoConstraints = false
            followersCountLabel.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
            followersCountLabel.bottomAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
            
            profileContainerView.addSubview(followingLabel)
            followingLabel.translatesAutoresizingMaskIntoConstraints = false
            followingLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -profileInsetX).isActive = true
            followingLabel.leadingAnchor.constraint(equalTo: profilePictureButton.trailingAnchor, constant: containerInsetX).isActive = true
            followingLabel.topAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
            
            profileContainerView.addSubview(profileSaveButton)
            profileSaveButton.translatesAutoresizingMaskIntoConstraints = false
            profileSaveButton.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
            profileSaveButton.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor, multiplier: 0.8).isActive = true
            profileSaveButton.trailingAnchor.constraint(equalTo: followingLabel.trailingAnchor).isActive = true
            
            profileContainerView.addSubview(followingCountLabel)
            followingCountLabel.translatesAutoresizingMaskIntoConstraints = false
            followingCountLabel.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor).isActive = true
            followingCountLabel.bottomAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
            
            profileContainerView.addSubview(profileContainerStackView)
            profileContainerStackView.translatesAutoresizingMaskIntoConstraints = false
            profileContainerStackView.topAnchor.constraint(equalTo: profilePictureButton.bottomAnchor, constant: containerInsetY).isActive = true
            profileContainerStackView.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: containerInsetX).isActive = true
            profileContainerStackView.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -containerInsetX).isActive = true
            
            profileContainerView.addSubview(deleteButton)
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.topAnchor.constraint(equalTo: profileContainerStackView.bottomAnchor, constant: containerInsetY).isActive = true
            deleteButton.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
            
            return profileContainerView
            
        }()
        
        lazy private var backgroundView: UIView = {
            
            let backgroundImageView = UIImageView(image: UIImage.appBackground)
            backgroundImageView.contentMode = .scaleAspectFill
            
            var backgroundView = UIView()
            backgroundView.backgroundColor = .clear
            
//            backgroundView.addSubview(backgroundImageView)
//            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
//            backgroundImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
//            backgroundImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
//            backgroundImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
//            backgroundImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
            
            return backgroundView
            
        }()
        
        lazy private var profilePictureButton: ImageBubbleButton = {
            
            var profilePictureButton = ImageBubbleButton(bouncyButtonImage: UIImage.defaultUserPicture256)
            profilePictureButton.imageView?.contentMode = .scaleToFill
            //profilePictureButton.addTarget(self, action: #selector(displayImageViewController), for: .touchUpInside)
            
            profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
            profilePictureButton.heightAnchor.constraint(equalTo: profilePictureButton.widthAnchor).isActive = true
            
            return profilePictureButton
            
        }()

        
        lazy private var profileBackButton: BouncyButton = {
            
            var profileBackButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .medium)).withTintColor(UIColor.mainDARKPURPLE))
           profileBackButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
           
           profileBackButton.translatesAutoresizingMaskIntoConstraints = false
           profileBackButton.widthAnchor.constraint(equalTo: profileBackButton.heightAnchor).isActive = true
           
           return profileBackButton
            
        }()
    
    lazy private var profileSaveButton: BouncyButton = {
        
        var profileSaveButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .checkmark, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .medium)).withTintColor(UIColor.mainDARKPURPLE))
       profileSaveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
       
       profileSaveButton.translatesAutoresizingMaskIntoConstraints = false
       profileSaveButton.widthAnchor.constraint(equalTo: profileSaveButton.heightAnchor).isActive = true
       
       return profileSaveButton
        
    }()
    
    lazy private var deleteButton: BouncyButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 1.8)
        
        var deleteButton = BouncyButton(bouncyButtonImage: nil)
        deleteButton.setTitle("Delete Account", for: .normal)
        deleteButton.titleLabel!.textAlignment = .center
        deleteButton.titleLabel!.font = .dynamicFont(with: "Octarine-Bold", style: .caption1)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .socialLIGHTRED
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: innerEdgeInset, left: innerEdgeInset*2, bottom: innerEdgeInset, right: innerEdgeInset*2)
        deleteButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        
        return deleteButton
        
    }()
        
    init(with data: UserData, newUser: Bool, followerCount: String, followingCount: String) {
            
            super.init(nibName: nil, bundle: nil)
        
        followersCountLabel.text = followerCount
        followingCountLabel.text = followingCount
            
            userData = data
        self.newUser = newUser
        if(userData.uid == Auth.auth().currentUser?.uid || newUser){
            print("HIDDENN")
            deleteButton.isHidden = true
        }else{
            print("NOOTT HIDDENN")
            deleteButton.isHidden = false
        }
            
        }
        
        required init?(coder: NSCoder) {
            
            super.init(coder: coder)
            
        }
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            let dismissKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            dismissKeyboardGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(dismissKeyboardGesture)
            
            view.addSubview(backgroundView)
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            
            view.addSubview(profileContainerView)
            profileContainerView.translatesAutoresizingMaskIntoConstraints = false
            profileContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: profileInsetY).isActive = true
            profileContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -profileInsetY).isActive = true
            profileContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: profileInsetX).isActive = true
            profileContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -profileInsetX).isActive = true
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            
            super.viewWillAppear(animated)
            
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            
            super.viewWillDisappear(animated)
            
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            
        }
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if(textView.text == "Insert Bio..."){
            bioTextView.text = ""
        }
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if(textView.text == ""){
            bioTextView.text = "Insert Bio..."
        }
    }
    
     func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    @objc func deleteAccount() {
        print("Delete")
        let ref = Firestore.firestore().collection("users")
        ref.document(userData.uid).getDocument{ (document, error) in
            let uid = Auth.auth().currentUser?.uid
        if let document = document, document.exists {
            let data = document.data()
             let admins = data?["admins"] as? [String: Any] ?? [:]
             let userIDs: [String] = Array(admins.keys)
             
            if(userIDs.count < 2){
                let button1 = AlertButton(alertTitle: "yes", alertButtonAction: {
                                        ref.document(self.userData.uid).delete()
                                        ref.document(uid!).updateData(["orgs.\(self.userData.uid)" : FieldValue.delete()
                                        ])

                    NotificationCenter.default.post(name: .deletedOrg, object: nil)
                    self.dismiss(animated: true, completion: nil)
                })
                let button2 = AlertButton(alertTitle: "no", alertButtonAction: nil)
                let alertVC = AlertViewController(alertTitle: "Are you sure?", alertMessage: "This will delete the org @\(self.userData.username), all data will be lost", alertButtons: [button1, button2])
                
                self.present(alertVC, animated: true, completion: nil)
            }else{
                let button1 = AlertButton(alertTitle: "yes", alertButtonAction: {ref.document(self.userData.uid).updateData(["admins.\(uid!)" : FieldValue.delete()
                ])
                    ref.document(uid!).updateData(["orgs.\(self.userData.uid)" : FieldValue.delete()
                    ])
                    NotificationCenter.default.post(name: .deletedOrg, object: nil)
                    self.dismiss(animated: true, completion: nil)
                })
                               let button2 = AlertButton(alertTitle: "no", alertButtonAction: nil)
                               let alertVC = AlertViewController(alertTitle: "Are you sure?", alertMessage: "This will remove admin priveliges for the org @\(self.userData.username) from your account", alertButtons: [button1, button2])
                               
                               self.present(alertVC, animated: true, completion: nil)
            }
            }
        }

        
    }

        @objc func saveChanges() {
            if(!newUser){
              var valid = 0
                let usernameFormat = "\\w{3,15}"
                let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameFormat)
                var bio = ""
                if(bioTextView.text == "Insert Bio..."){
                    bio = ""
                }else{
                    bio = bioTextView.text
                }
                
                if(fullNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
                    valid += 1
                }
                
                if(usernameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty || !(usernamePredicate.evaluate(with: usernameTextField.text))){
                    valid += 2
                }
                switch valid{
                case 1: let button1 = AlertButton(alertTitle: "ok", alertButtonAction: nil)
                let alertVC = AlertViewController(alertTitle: "error", alertMessage: "Full  name missing", alertButtons: [button1])
                
                self.present(alertVC, animated: true, completion: nil)
                    
                case 2: let button1 = AlertButton(alertTitle: "ok", alertButtonAction: nil)
                let alertVC = AlertViewController(alertTitle: "error", alertMessage: "Username must be 3-15 characters (alphanumeric or underscore)", alertButtons: [button1])
                
                self.present(alertVC, animated: true, completion: nil)
                    
                case 3: let button1 = AlertButton(alertTitle: "ok", alertButtonAction: nil)
                let alertVC = AlertViewController(alertTitle: "error", alertMessage: "Org name is missing and username must be 3-15 characters (alphanumeric or underscore)", alertButtons: [button1])
                
                self.present(alertVC, animated: true, completion: nil)
                    
                case 0:
                let ref = Firestore.firestore().collection("users").document(userData.uid)
                ref.setData(["bio": bio, "username": usernameTextField.text!, "fullName": fullNameTextField.text!], merge: true)
                DataController.eraseAll(forEntity: "User")
                DataController.addUser(bio: bio, username: usernameTextField.text!, fullName: fullNameTextField.text!, uid: userData.uid, radius: Double(MapViewController.defaultMapViewRegionRadius/1000.0), latitude: Double(MapViewController.defaultMapViewCenterLocation.latitude), longitude: Double(MapViewController.defaultMapViewCenterLocation.longitude), notificationName: .editedProfileMap)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: .editedProfile, object: nil)
                
                default:
                    let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
                    let alertVC = AlertViewController(alertTitle: "error", alertMessage: "An error occured", alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
                
            }else{
                var valid = 0
                let usernameFormat = "\\w{3,15}"
                let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameFormat)
                var bio = ""
                if(bioTextView.text == "Insert Bio..."){
                    bio = ""
                }else{
                    bio = bioTextView.text
                }
                
                if(fullNameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty){
                    valid += 1
                }
                
                if(usernameTextField.text!.trimmingCharacters(in: .whitespaces).isEmpty || !(usernamePredicate.evaluate(with: usernameTextField.text))){
                    valid += 2
                }
                
                switch valid{
                case 1: let button1 = AlertButton(alertTitle: "ok", alertButtonAction: nil)
                let alertVC = AlertViewController(alertTitle: "error", alertMessage: "Org name missing", alertButtons: [button1])
                
                self.present(alertVC, animated: true, completion: nil)
                    
                case 2: let button1 = AlertButton(alertTitle: "of", alertButtonAction: nil)
                let alertVC = AlertViewController(alertTitle: "error", alertMessage: "Username must be 3-15 characters (alphanumeric or underscore)", alertButtons: [button1])
                
                self.present(alertVC, animated: true, completion: nil)
                    
                case 3: let button1 = AlertButton(alertTitle: "ok", alertButtonAction: nil)
                let alertVC = AlertViewController(alertTitle: "error", alertMessage: "Org name is missing and username must be 3-15 characters (alphanumeric or underscore)", alertButtons: [button1])
                
                self.present(alertVC, animated: true, completion: nil)
                    
                case 0:
                    let uid = UUID().uuidString
                    let ref = Firestore.firestore().collection("users").document(uid)
                    ref.setData([
                        "bio": bio,
                        "username": usernameTextField.text!,
                        "fullName": fullNameTextField.text!,
                        "followers": [uid : false],
                        "following": [uid : false],
                        "admins": [Auth.auth().currentUser?.uid : true],
                        "latitude": Double(MapViewController.defaultMapViewCenterLocation.latitude),
                        "longitude": Double(MapViewController.defaultMapViewCenterLocation.longitude),
                        "radius": Double(MapViewController.defaultMapViewRegionRadius/1000.0)
                    ], merge: true)
                    
                    let userRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid)
                    userRef.updateData(["orgs.\(uid)": true])
                    
                    let user = DataController.getUser()
                    let userBio = user.value(forKey: "bio") as? String ?? ""
                    let userUsername = user.value(forKey: "username") as? String ?? ""
                    let userFullName = user.value(forKey: "fullName") as? String ?? ""
                    let userUid = user.value(forKey: "uid") as? String ?? ""
                    
                    DataController.addAccount(bio: userBio, username: userUsername, fullName: userFullName, uid: userUid)
                    DataController.eraseAll(forEntity: "User")
                    DataController.addUser(bio: bio, username: usernameTextField.text!, fullName: fullNameTextField.text!, uid: uid, radius: Double(MapViewController.defaultMapViewRegionRadius/1000.0), latitude: Double(MapViewController.defaultMapViewCenterLocation.latitude), longitude: Double(MapViewController.defaultMapViewCenterLocation.longitude), notificationName: .editedProfileMap)
                    
                    self.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: .editedProfile, object: nil)
                    
                default:
                    let button1 = AlertButton(alertTitle: "Try again", alertButtonAction: nil)
                    let alertVC = AlertViewController(alertTitle: "error", alertMessage: "An error occured", alertButtons: [button1])
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
                
                
            }
    }
    

        
        @objc func transitionToPreviousPage() {
            
            if(!newUser){
                if(usernameTextField.text == userData.username && fullNameTextField.text == userData.fullName && (bioTextView.text == "Insert Bio..." || bioTextView.text == userData.bio)){
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    let button1 = AlertButton(alertTitle: "Yes", alertButtonAction: { [weak self] in
                        
                        guard let self = self else { return }
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    let button2 = AlertButton(alertTitle: "No", alertButtonAction: nil)
                    
                    let alertVC = AlertViewController(alertTitle: "Discard changes", alertMessage: "Are you sure you wish to discard changes?", alertButtons: [button1, button2])
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
            }else{
                let button1 = AlertButton(alertTitle: "Yes", alertButtonAction: { [weak self] in
                    
                    guard let self = self else { return }
                    self.dismiss(animated: true, completion: nil)
                 })
                
                let button2 = AlertButton(alertTitle: "No", alertButtonAction: nil)
                
                let alertVC = AlertViewController(alertTitle: "Discard changes", alertMessage: "Are you sure you wish to discard changes?", alertButtons: [button1, button2])
                
                self.present(alertVC, animated: true, completion: nil)
            }
            
        }
     
        
}
    extension EditProfileViewController: UIGestureRecognizerDelegate {
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            
            return true
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


