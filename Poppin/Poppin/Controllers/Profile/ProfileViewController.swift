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
    
    var storage: Storage?

    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 14.0, maxSize: 17.0))
        nameLabel.textColor = UIColor.mainDARKPURPLE
        return nameLabel
    }()
    
    lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 14.0, maxSize: 17.0))
        usernameLabel.textColor = UIColor.mainDARKPURPLE
        return usernameLabel
    }()
    
    lazy var bioLabel: UILabel = {
        let bioLabel = UILabel()
        bioLabel.font = UIFont(name: "Octarine-Light", size: .getWidthFitSize(minSize: 10.0, maxSize: 14.0))
        bioLabel.textColor = UIColor.mainDARKPURPLE
        bioLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        //bioLabel.numberOfLines = 10
        return bioLabel
    }()
    
    lazy var followerLabel: UILabel = {
        let followerLabel = UILabel()
        followerLabel.text = "followers"
        followerLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 14.0, maxSize: 17.0))
        followerLabel.textColor = UIColor.mainDARKPURPLE
        return followerLabel
    }()
    
    lazy var followerCountButton: UIButton = {
        let followerCountButton = UIButton()
        followerCountButton.titleLabel!.font = UIFont(name: "Octarine-Light", size: .getWidthFitSize(minSize: 14.0, maxSize: 17.0))
        followerCountButton.titleLabel!.textAlignment = .center
        followerCountButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        //followerCountButton.addTarget(self, action: #selector(viewFollowers), for: .touchUpInside)

        return followerCountButton
    }()
    
    lazy var followingLabel: UILabel = {
        let followingLabel = UILabel()
        followingLabel.text = "following"
        followingLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 14.0, maxSize: 17.0))
        followingLabel.textColor = UIColor.mainDARKPURPLE
        return followingLabel
    }()
    
    lazy var followingCountButton: UIButton = {
        let followingCountButton = UIButton()
        followingCountButton.titleLabel!.font = UIFont(name: "Octarine-Light", size: .getWidthFitSize(minSize: 14.0, maxSize: 17.0))
        followingCountButton.titleLabel!.textAlignment = .center
        followingCountButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        //followingCountButton.addTarget(self, action: #selector(viewFollowing), for: .touchUpInside)
        return followingCountButton
    }()
    
    lazy var purpleView: UIView = {
        let purpleView = UIView()
        purpleView.backgroundColor = .white
        purpleView.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return purpleView
    }()
    
    lazy var backgroundView: UIImageView = {
        let backgroundView = UIImageView(image: UIImage.appBackground)
        backgroundView.contentMode = UIView.ContentMode.scaleAspectFill
        return backgroundView
    }()
    
    lazy var userImage: UIImageView = {
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
    }()
    
    lazy var followButton: BubbleButton = {
        var followButton = BubbleButton(bouncyButtonImage: nil)
        followButton.titleLabel!.textAlignment = .center
        followButton.titleLabel!.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 14.0, maxSize: 17.0))
        followButton.addTarget(self, action: #selector(follow), for: .touchUpInside)
        return followButton
    }()
    
    var uid: String?
    
    lazy var backButton: ImageBubbleButton = {
        let purpleArrow = UIImage(systemName: "arrow.left.circle.fill")!.withTintColor(.mainDARKPURPLE)
        let backButton = ImageBubbleButton(bouncyButtonImage: purpleArrow)
        backButton.contentMode = .scaleToFill
       // backButton.setTitle("Back", for: .normal)
        //backButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFollowerCount()
        storage = Storage.storage()

        
        let reference = (self.storage?.reference().child("images/\(uid!)/profilepic.jpg"))!


        // Placeholder image
        let placeholderImage = UIImage.defaultUserPicture256

        // Load the image using SDWebImage
        //cell.userImageHolder.sd_setImage(with: reference, placeholderImage: placeholderImage)
        userImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        // view.backgroundColor = .white
        //view.backgroundColor = UIColor(patternImage: .newAppBackground)
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(goBack))
        //        swipeRight.direction = .right
        //        self.view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
        
        view.addSubview(backgroundView)
        backgroundView.isUserInteractionEnabled = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        backgroundView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        backgroundView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        backgroundView.addSubview(purpleView)
        purpleView.isUserInteractionEnabled = true
        purpleView.translatesAutoresizingMaskIntoConstraints = false
        purpleView.topAnchor.constraint(equalTo: backgroundView.safeAreaLayoutGuide.topAnchor).isActive = true
        purpleView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -backgroundView.bounds.height * 0.025).isActive = true
        purpleView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        //purpleView.heightAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.4).isActive = true
        purpleView.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.9).isActive = true
        //purpleView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        
        purpleView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20 ).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        
        purpleView.addSubview(userImage)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: backgroundView.bounds.height * 0.025).isActive = true
        userImage.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true

        
        purpleView.addSubview(followerLabel)
        followerLabel.translatesAutoresizingMaskIntoConstraints = false
        followerLabel.trailingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: -25).isActive = true
        followerLabel.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 25).isActive = true
        
        purpleView.addSubview(followerCountButton)
        followerCountButton.translatesAutoresizingMaskIntoConstraints = false
        followerCountButton.trailingAnchor.constraint(equalTo: followerLabel.trailingAnchor).isActive = true
        followerCountButton.leadingAnchor.constraint(equalTo: followerLabel.leadingAnchor).isActive = true
        followerCountButton.topAnchor.constraint(equalTo: followerLabel.bottomAnchor, constant: 5).isActive = true
        
        purpleView.addSubview(followingLabel)
        followingLabel.translatesAutoresizingMaskIntoConstraints = false
        followingLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 25).isActive = true
        followingLabel.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 25).isActive = true
        
        purpleView.addSubview(followingCountButton)
        followingCountButton.translatesAutoresizingMaskIntoConstraints = false
        followingCountButton.trailingAnchor.constraint(equalTo: followingLabel.trailingAnchor).isActive = true
        followingCountButton.leadingAnchor.constraint(equalTo: followingLabel.leadingAnchor).isActive = true
        followingCountButton.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: 5).isActive = true
        
        purpleView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: backgroundView.bounds.height * 0.025).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        
        purpleView.addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: backgroundView.bounds.height * 0.01).isActive = true
        bioLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        bioLabel.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.75).isActive = true
        
        purpleView.addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        if(bioLabel.text == ""){
            followButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: backgroundView.bounds.height * 0.01).isActive = true
        }else{
            followButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: backgroundView.bounds.height * 0.01).isActive = true
        }
        followButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.04).isActive = true
        followButton.widthAnchor.constraint(equalToConstant: backgroundView.bounds.width * 0.3).isActive = true
        
        purpleView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: purpleView.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: purpleView.leadingAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.04).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: backgroundView.bounds.height * 0.04).isActive = true

    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("IMAGE TAPPED")
        let vc = ProfileImageViewController()
        vc.uid = uid
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
        //let tappedImage = tapGestureRecognizer.view as! UIImageView

        // Your action
    }
    
    var viewTranslation = CGPoint(x: 0, y: 0)

    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
          case .changed:
              viewTranslation = sender.translation(in: view)
              UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: self.viewTranslation.x, y: 0)
              })
          case .ended:
              if viewTranslation.x < 200 {
                  UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                      self.view.transform = .identity
                  })
              } else {
                self.dismiss(animated: true, completion: nil)
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: nil)
              }
          default:
              break
          }
        
    }
    
    
    @objc func goBack() {
        
        self.dismiss(animated: true, completion: nil)
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNotification"), object: nil)
        
    }
    
    @objc func follow(){
        
        let userId = Auth.auth().currentUser!.uid
        
        let ref = Database.database().reference(withPath:"users")
        
        if(followButton.titleLabel!.text == "following"){
            
            let button1 = AlertButton(alertTitle: "Cancel", alertButtonAction: nil)
            
            let button2 = AlertButton(alertTitle: "Continue", alertButtonAction: {
            
                ref.child(self.uid!).child("followers").child(userId).removeValue()
                ref.child(userId).child("following").child(self.uid!).removeValue()
            
            
            
                ref.child(self.uid!).child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
                self.followerCountButton.setTitle(String(snapshot.childrenCount - 1), for: .normal)
            })
            
                self.followButton.setTitle("follow", for: .normal)
                self.followButton.setTitleColor(.white, for: .normal)
                self.followButton.backgroundColor = .mainDARKPURPLE
            })
            
            let alertVC = AlertViewController(alertTitle: "Are you sure you wish to unfollow this user?", alertMessage: "You wish", alertButtons: [button1, button2])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }else{
            
            ref.child(uid!).child("followers").child(userId).setValue(true)
            ref.child(userId).child("following").child(uid!).setValue(true)
            
            
            
            ref.child(uid!).child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
                self.followerCountButton.setTitle(String(snapshot.childrenCount - 1), for: .normal)
            })
            
            followButton.setTitle("following", for: .normal)
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
    
    func getFollowerCount(){
        
        let ref = Database.database().reference(withPath:"users")
        
        
        ref.child(uid!).child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
            self.followerCountButton.setTitle(String(snapshot.childrenCount - 1), for: .normal)
        })
        
        ref.child(uid!).child("following").observeSingleEvent(of: .value, with: { (snapshot) in
            self.followingCountButton.setTitle(String(snapshot.childrenCount - 1), for: .normal)
        })
        
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

