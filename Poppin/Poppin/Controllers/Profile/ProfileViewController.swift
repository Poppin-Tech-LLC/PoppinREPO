//
//  ProfileViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/15/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseUI
import FirebaseAuth

final class ProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    let profileInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let profileInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 3.5)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 3.5)
    
    private var storage: Storage = Storage.storage()
    
    private var userData: UserData = UserData(username: "@username", uid: "", bio: "Bio", fullName: "Full Name")
    
    private var followers: String = "0" {
        
        didSet { followersButton.setTitle(followers, for: .normal) }
        
    }
    
    private var following: String = "0" {
        
        didSet { followingButton.setTitle(following, for: .normal) }
        
    }
    
    private var profilePictureURL: URL? {
        
        didSet {
            
            profilePictureButton.sd_setImage(with: profilePictureURL, for: .normal, placeholderImage: UIImage.defaultUserPicture256, options: .continueInBackground, completed: nil)
            
        }
        
    }

    lazy private var fullNameLabel: UILabel = {
        
        var fullNameLabel = UILabel()
        fullNameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        fullNameLabel.textColor = UIColor.mainDARKPURPLE
        fullNameLabel.textAlignment = .center
        fullNameLabel.text = userData.fullName
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.heightAnchor.constraint(equalToConstant: fullNameLabel.intrinsicContentSize.height).isActive = true
        
        return fullNameLabel
        
    }()
    
    lazy private var usernameLabel: UILabel = {
        
        var usernameLabel = UILabel()
        usernameLabel.font = .dynamicFont(with: "Octarine-Light", style: .callout)
        usernameLabel.textColor = UIColor.mainDARKPURPLE
        usernameLabel.textAlignment = .center
        usernameLabel.text = "@" + userData.username.lowercased()
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.heightAnchor.constraint(equalToConstant: usernameLabel.intrinsicContentSize.height).isActive = true
        
        return usernameLabel
        
    }()
    
    lazy private var bioLabel: UILabel = {
        
        var bioLabel = UILabel()
        bioLabel.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
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
        followersButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)
        followersButton.setTitle(followers, for: .normal)
        followersButton.titleLabel?.textAlignment = .center
        return followersButton
        
    }()
    
    lazy private var followersLabel: UILabel = {
        
        var followersLabel = UILabel()
        followersLabel.backgroundColor = .clear
        followersLabel.textColor = .mainDARKPURPLE
        followersLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote)
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
        followingButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)
        followingButton.setTitle(following, for: .normal)
        followingButton.titleLabel?.textAlignment = .center
        return followingButton
        
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
    
    lazy private var profileContainerView: UIView = {
        
        let profileContainerStackView = UIStackView(arrangedSubviews: [fullNameLabel, bioLabel])
        profileContainerStackView.axis = .vertical
        profileContainerStackView.alignment = .fill
        profileContainerStackView.distribution = .fill
        profileContainerStackView.spacing = containerInsetY
        
        var profileContainerView = UIView()
        profileContainerView.backgroundColor = .white
        profileContainerView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        
        profileContainerView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileContainerView.topAnchor, constant: profileInsetY).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
        
        profileContainerView.addSubview(profileBackButton)
        profileBackButton.translatesAutoresizingMaskIntoConstraints = false
        profileBackButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor).isActive = true
        profileBackButton.heightAnchor.constraint(equalTo: usernameLabel.heightAnchor).isActive = true
        profileBackButton.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: profileInsetX).isActive = true
        
        profileContainerView.addSubview(profilePictureButton)
        profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
        profilePictureButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: containerInsetY).isActive = true
        profilePictureButton.widthAnchor.constraint(equalTo: profileContainerView.widthAnchor, multiplier: 0.25).isActive = true
        profilePictureButton.centerXAnchor.constraint(equalTo: profileContainerView.centerXAnchor).isActive = true
        
        profileContainerView.addSubview(followersLabel)
        followersLabel.translatesAutoresizingMaskIntoConstraints = false
        followersLabel.trailingAnchor.constraint(equalTo: profilePictureButton.leadingAnchor, constant: -containerInsetX).isActive = true
        followersLabel.leadingAnchor.constraint(equalTo: profileContainerView.leadingAnchor, constant: profileInsetX).isActive = true
        followersLabel.topAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
        
        profileContainerView.addSubview(followersButton)
        followersButton.translatesAutoresizingMaskIntoConstraints = false
        followersButton.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
        followersButton.bottomAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
        
        profileContainerView.addSubview(followingLabel)
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        followingLabel.trailingAnchor.constraint(equalTo: profileContainerView.trailingAnchor, constant: -profileInsetX).isActive = true
        followingLabel.leadingAnchor.constraint(equalTo: profilePictureButton.trailingAnchor, constant: containerInsetX).isActive = true
        followingLabel.topAnchor.constraint(equalTo: profilePictureButton.centerYAnchor).isActive = true
        
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
    
    /*lazy private var userImage: UIImageView = {
        var userImage = UIImageView()
        userImage.layer.borderColor = UIColor.white.cgColor
        //userImage.image = .defaultUserPicture128
        userImage.contentMode = .scaleToFill
        
        userImage.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.09).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.09).isActive = true
        userImage.frame = CGRect(x: 0, y: 0, width: view.bounds.height * 0.09, height: view.bounds.height * 0.09)
        userImage.layer.masksToBounds = true
        
       // userImage.addShadowAndRoundCorners(cornerRadius: userImage.bounds.height/2)
        userImage.layer.cornerRadius = userImage.bounds.height/2
        userImage.layer.cornerCurve = .continuous
        userImage.layer.shadowColor = UIColor.black.cgColor
        userImage.layer.shadowOffset = CGSize(width: 0.0, height: 3.0) // Shifts shadow
        userImage.layer.shadowOpacity = 0.3 // Higher value means more opaque
        userImage.layer.shadowRadius = 3 // Higher value means more blurry
        var maskedCorners = CACornerMask()

        maskedCorners.insert(.layerMaxXMinYCorner)
        maskedCorners.insert(.layerMinXMinYCorner)
        maskedCorners.insert(.layerMaxXMaxYCorner)
        maskedCorners.insert(.layerMinXMaxYCorner)
        if !maskedCorners.isEmpty { userImage.layer.maskedCorners = maskedCorners }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
        //userImage.frame.size = CGSize(width: 40.0, height: 20.0)
        //userImage.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //userImage.getPercentage
        //userImage.clipsToBounds = true
        return userImage
    }()*/
    
    lazy private var followButton: BouncyButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        var followButton = BouncyButton(bouncyButtonImage: nil)
        followButton.titleLabel!.textAlignment = .center
        followButton.titleLabel!.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        followButton.setTitle("Follow", for: .normal)
        followButton.setTitleColor(.white, for: .normal)
        followButton.backgroundColor = .mainDARKPURPLE
        followButton.addTarget(self, action: #selector(performFollow), for: .touchUpInside)
        followButton.contentEdgeInsets = UIEdgeInsets(top: innerEdgeInset, left: innerEdgeInset*2, bottom: innerEdgeInset, right: innerEdgeInset*2)
        followButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 10.0, maxSize: 12.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        
        return followButton
        
    }()
    
    lazy private var profileBackButton: BouncyButton = {
        
        var profileBackButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .arrowLeft).withTintColor(UIColor.mainDARKPURPLE))
       profileBackButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
       
       profileBackButton.translatesAutoresizingMaskIntoConstraints = false
       profileBackButton.widthAnchor.constraint(equalTo: profileBackButton.heightAnchor).isActive = true
       
       return profileBackButton
        
    }()
    
    init(with data: UserData) {
        
        super.init(nibName: nil, bundle: nil)
        
        userData = data
        fetchFollowersFollowingPicture()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        // Load the image using SDWebImage
        //cell.userImageHolder.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        // view.backgroundColor = .white
        //view.backgroundColor = UIColor(patternImage: .newAppBackground)
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        //        swipeRight.direction = .right
        //        self.view.addGestureRecognizer(swipeRight)
        //view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
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
    
    @objc private func displayImageViewController() {
        
        print("IMAGE TAPPED")
        let vc = ProfileImageViewController()
        vc.uid = userData.uid
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func transitionToPreviousPage() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func performFollow() {
        
        let userId = Auth.auth().currentUser!.uid
        
        let ref = Database.database().reference(withPath:"users")
        
        if followButton.titleLabel!.text == "Following" {
            
            let button1 = AlertButton(alertTitle: "Cancel", alertButtonAction: nil)
            
            let button2 = AlertButton(alertTitle: "Unfollow", alertButtonAction: {
            
                ref.child(self.userData.uid).child("followers").child(userId).removeValue { [weak self] (error, reference) in
                    
                    guard let self = self else { return }
                    
                    ref.child(self.userData.uid).child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        self.followers = String(snapshot.childrenCount - 1)
                        
                    })
                    
                }
                
                ref.child(userId).child("following").child(self.userData.uid).removeValue()
            
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.setTitleColor(.white, for: .normal)
                self.followButton.backgroundColor = .mainDARKPURPLE
                
            })
            
            let alertVC = AlertViewController(alertTitle: "Unfollow " + userData.fullName, alertMessage: "Are you sure you wish to unfollow this user?", alertButtons: [button1, button2])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            
            ref.child(self.userData.uid).child("followers").child(userId).setValue(true) { [weak self] (error, reference) in
                
                guard let self = self else { return }
                
                ref.child(self.userData.uid).child("followers").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                    
                    guard let self = self else { return }
                    
                    self.followers = String(snapshot.childrenCount - 1)
                    
                })
                
            }
            
            ref.child(userId).child("following").child(self.userData.uid).setValue(true)
            
            followButton.setTitle("Following", for: .normal)
            followButton.setTitleColor(.mainDARKPURPLE, for: .normal)
            followButton.backgroundColor = .white
            
        }
        
    }
    
    /*@objc func viewFollowers(){
        
        let vc = SearchViewController()
        vc.uid = uid
        vc.searchType = "showFollowers"
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
    
    @objc func viewFollowing(){
        
         let vc = SearchViewController()
         vc.uid = uid
         vc.searchType = "showFollowing"
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)

     }*/
    
    private func fetchFollowersFollowingPicture() {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference(withPath:"users")
        let ref2 = storage.reference().child("images/\(userData.uid)/profilepic.jpg")
        let ref3 = Database.database().reference()
        
        ref3.child("users/\(uid)/following").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            if snapshot.hasChild(self.userData.uid){
                
                self.followButton.setTitle("Following", for: .normal)
                self.followButton.setTitleColor(.mainDARKPURPLE, for: .normal)
                self.followButton.backgroundColor = .white
                
            } else {
                
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.setTitleColor(.white, for: .normal)
                self.followButton.backgroundColor = .mainDARKPURPLE
                
            }
            
        })
        
        ref.child(userData.uid).child("followers").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            self.followers = String(snapshot.childrenCount - 1)

        })
        
        ref.child(userData.uid).child("following").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            self.following = String(snapshot.childrenCount - 1)
            
        })
        
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

    var uid: String?
    var storage: Storage?
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 0.8, height: view.bounds.width * 0.8)
        // userImage.addShadowAndRoundCorners(cornerRadius: userImage.bounds.height/2)
         imageView.layer.cornerRadius = imageView.bounds.height/2
        return imageView
        
    }()
    
    lazy var backButton: ImageBubbleButton = {
        
         let purpleArrow = UIImage(systemName: "arrow.left.circle.fill")!.withTintColor(.mainDARKPURPLE)
         let backButton = ImageBubbleButton(bouncyButtonImage: purpleArrow)
         backButton.contentMode = .scaleToFill
        // backButton.setTitle("Back", for: .normal)
         //backButton.setTitleColor(.newPurple, for: .normal)
         backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
         return backButton
        
     }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        storage = Storage.storage()
        
        let reference = (self.storage?.reference().child("images/\(uid!)/profilepic.jpg"))!

        // Placeholder image
        let placeholderImage = UIImage.defaultUserPicture256

        // Load the image using SDWebImage
        //cell.userImageHolder.sd_setImage(with: reference, placeholderImage: placeholderImage)
        imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        view.backgroundColor = UIColor(white: 0, alpha: 0.9)
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))

        view.addSubview(imageView)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.width * 0.04).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true

    }
    
    @objc func goBack() {
        
        self.dismiss(animated: true, completion: nil)
        
    }

    var viewTranslation = CGPoint(x: 0, y: 0)

    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
          case .changed:
              viewTranslation = sender.translation(in: view)
              UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                  self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
              })
          case .ended:
              if viewTranslation.y < 200 {
                  UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                      self.view.transform = .identity
                  })
              } else {
                  dismiss(animated: true, completion: nil)
              }
          default:
              break
          }
        
    }

}

