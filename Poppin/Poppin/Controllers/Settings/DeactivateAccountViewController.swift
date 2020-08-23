//
//  DeactivateAccountViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class DeactivateAccountViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {
    
    var followersArray: [String] = []
    var followingArray: [String] = []
    
    let settingsInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    
    lazy var settingsLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        settingsLabel.text = "Deactivate Account"
        settingsLabel.backgroundColor = .clear
        settingsLabel.textColor = .white
        settingsLabel.textAlignment = .center
        settingsLabel.sizeToFit()
        return settingsLabel
    }()
    
    lazy private var backButton: ImageBubbleButton = {
        let backButton = ImageBubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft).withTintColor(.white))
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
    lazy private var menuPopsicleBorderImageView: UIImageView = {
        
        var menuPopsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.white))
        menuPopsicleBorderImageView.contentMode = .scaleAspectFit
        return menuPopsicleBorderImageView
        
    }()
    
    lazy private var passwordTextField: UITextField = {
        
        var passwordTextField = UITextField()
        passwordTextField.backgroundColor = .clear
        passwordTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: passwordTextField.intrinsicContentSize.height))
        passwordTextField.leftViewMode = .always
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.returnKeyType = .done
        passwordTextField.enablesReturnKeyAutomatically = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.setBottomBorder(color: UIColor.white, height: 1.0)
        passwordTextField.layer.backgroundColor = UIColor.mainDARKPURPLE.cgColor
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: passwordTextField.intrinsicContentSize.height+(settingsInnerInset*0.4)).isActive = true
        
        return passwordTextField
        
    }()
    
    lazy private var confirmButton: BubbleButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 1.5)
        
        let confirmButton = BubbleButton(bouncyButtonImage: nil)
        confirmButton.setTitle("Next", for: .normal)
        confirmButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        confirmButton.backgroundColor = .white
        confirmButton.titleLabel?.textAlignment = .center
        confirmButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        confirmButton.contentEdgeInsets = UIEdgeInsets(top: innerEdgeInset, left: innerEdgeInset*2, bottom: innerEdgeInset, right: innerEdgeInset*2)
        confirmButton.addTarget(self, action: #selector(deactivateAccount), for: .touchUpInside)
        return confirmButton
        
    }()
    
    lazy private var containerView: UIView = {
        let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let containerStackView = UIStackView(arrangedSubviews: [passwordTextField])
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = settingsStackViewSpacing
        
        var containerView = UIView(frame: .zero)
        
        containerView.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: containerStackView.bottomAnchor, constant: settingsStackViewSpacing).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .mainDARKPURPLE
        
        view.addSubview(settingsLabel)
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: settingsInsetY).isActive = true
        settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: settingsInsetX).isActive = true
        backButton.centerYAnchor.constraint(equalTo: settingsLabel.centerYAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
        
        view.addSubview(menuPopsicleBorderImageView)
        menuPopsicleBorderImageView.translatesAutoresizingMaskIntoConstraints = false
        menuPopsicleBorderImageView.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: -(.getPercentageHeight(percentage: 2))).isActive = true
        menuPopsicleBorderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuPopsicleBorderImageView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 10)).isActive = true
        menuPopsicleBorderImageView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: menuPopsicleBorderImageView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: containerInsetX).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -containerInsetX).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        getFollowers()
        getFollowing()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
    @objc func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deactivateAccount(){
        let user = Auth.auth().currentUser
        let ref = Firestore.firestore().collection("users")

        let email = (user?.email!)!
        let password = passwordTextField.text
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password!)
        
        user?.reauthenticate(with: credential, completion: { (result, err) in
            if err == nil{
                
                ref.document(user!.uid).getDocument{ (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        let orgs = data?["orgs"] as? [String: Any] ?? [:]
                        
                        if(orgs.count > 0){
                            
                            let alertVC = AlertViewController(alertTitle: "Org Accounts", alertMessage: "Your account has org accounts attached to it, please remove these accounts before removing your account")
                            
                            self.present(alertVC, animated: true, completion: nil)
                        }else{
                            
                            let alertVC = AlertViewController(alertTitle: "Are you sure?", alertMessage: "This will delete all of your data including all accounts linked to your user", leftActionTitle: "Yes", leftAction: { [weak self] in
                                
                                guard let self = self else { return }
                                self.deleteUser()
                                
                            }, rightActionTitle: "No")
                            
                            self.present(alertVC, animated: true, completion: nil)
                        }
                    }
                }
               
                
            }else{
                
                let alertVC = AlertViewController(alertTitle: "Incorrect Password", alertMessage: "The password you entered is incorrect")
                
                self.present(alertVC, animated: true, completion: nil)
                
            }
        })
    }
    
    private func deleteUser(){
        let userId = Auth.auth().currentUser!.uid
        let user = Auth.auth().currentUser
        
        let ref = Firestore.firestore().collection("users")
        let ref2 = Firestore.firestore().collection("userLocs")
        ref.document(userId).delete()
        ref2.document(userId).delete()

        user?.delete { error in
            if error != nil {
                
                let alertVC = AlertViewController(alertTitle: "Error", alertMessage: "An error occured")
                
                self.present(alertVC, animated: true, completion: nil)
                
            } else {
                self.deleteFollowers(uid: userId)
                self.deleteFollowing(uid: userId)
                
                let alertVC = AlertViewController(alertTitle: "Success", alertMessage: "Account successfully deleted", leftAction: { [weak self] in
                    
                    guard let self = self else { return }
                    
                    let loginNavigationController = UINavigationController(rootViewController: StartViewController())
                    loginNavigationController.modalPresentationStyle = .overFullScreen
                    loginNavigationController.modalTransitionStyle = .coverVertical
                    loginNavigationController.setNavigationBarHidden(true, animated: false)
                    
                    self.present(loginNavigationController, animated: true, completion: nil)
                    
                })
                
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    private func deleteFollowers(uid: String){
        let ref = Firestore.firestore().collection("users")
        
        for follower in followersArray {
            ref.document(follower).updateData(["following.\(uid)" : FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("DELETED \(follower) ")
                    print("Document successfully updated")
                }
            }
        }
        
    }
    
    private func deleteFollowing(uid: String){
        let ref = Firestore.firestore().collection("users")
        
        for following in followingArray {
            print("ABOUT TO DELETE \(following)")
            ref.document(following).updateData(["followers.\(uid)" : FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("DELETED \(following) ")
                    print("Document successfully updated")
                }
            }
        }
        
    }
    
    private func getFollowers(){
        let user = Auth.auth().currentUser
        let ref = Firestore.firestore().collection("users")
        ref.document(user!.uid).getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let followers = data?["followers"] as? [String: Any] ?? [:]
                self.followersArray = Array(followers.keys)
            }
        }
    }
    
    private func getFollowing(){
        let user = Auth.auth().currentUser
        let ref = Firestore.firestore().collection("users")
        ref.document(user!.uid).getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let following = data?["following"] as? [String: Any] ?? [:]
                self.followingArray = Array(following.keys)
            }
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
    
}
