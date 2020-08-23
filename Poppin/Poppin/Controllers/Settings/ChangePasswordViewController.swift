//
//  ChangePasswordViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChangePasswordViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    let settingsInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let settingsInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    
    lazy var settingsLabel: UILabel = {
       let settingsLabel = UILabel()
        settingsLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        settingsLabel.text = "Change password"
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
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Current Password", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
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
       // passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
//        passwordTextField.borderStyle = .none
//        passwordTextField.layer.backgroundColor = UIColor.clear.cgColor
//        sepasswordTextFieldlf.layer.masksToBounds = false
//          passwordTextField.layer.shadowColor = color.cgColor
//        passwordTextField.layer.shadowOffset = CGSize(width: 0.0, height: height)
//        passwordTextField.layer.shadowOpacity = 1.0
//        passwordTextField.layer.shadowRadius = 0.0
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: passwordTextField.intrinsicContentSize.height+(settingsInnerInset*0.4)).isActive = true
        
        return passwordTextField
        
    }()
    
    lazy private var newPasswordTextField: UITextField = {
        
        var newPasswordTextField = UITextField()
        newPasswordTextField.backgroundColor = .clear
        newPasswordTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        newPasswordTextField.textColor = .white
        newPasswordTextField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
        newPasswordTextField.delegate = self
        newPasswordTextField.isSecureTextEntry = true
        newPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: newPasswordTextField.intrinsicContentSize.height))
        newPasswordTextField.leftViewMode = .always
        newPasswordTextField.clearButtonMode = .whileEditing
        newPasswordTextField.returnKeyType = .done
        newPasswordTextField.enablesReturnKeyAutomatically = true
        newPasswordTextField.autocapitalizationType = .none
        newPasswordTextField.autocorrectionType = .no
        newPasswordTextField.setBottomBorder(color: UIColor.white, height: 1.0)
        newPasswordTextField.layer.backgroundColor = UIColor.mainDARKPURPLE.cgColor
       // passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.heightAnchor.constraint(equalToConstant: passwordTextField.intrinsicContentSize.height+(settingsInnerInset*0.4)).isActive = true
        
        newPasswordTextField.isHidden = true
        
        return newPasswordTextField
        
    }()
    
    lazy private var confirmNewPasswordTextField: UITextField = {
        
        var confirmNewPasswordTextField = UITextField()
        confirmNewPasswordTextField.backgroundColor = .clear
        confirmNewPasswordTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        confirmNewPasswordTextField.textColor = .white
        confirmNewPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
        confirmNewPasswordTextField.delegate = self
        confirmNewPasswordTextField.isSecureTextEntry = true
        confirmNewPasswordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: confirmNewPasswordTextField.intrinsicContentSize.height))
        confirmNewPasswordTextField.leftViewMode = .always
        confirmNewPasswordTextField.clearButtonMode = .whileEditing
        confirmNewPasswordTextField.returnKeyType = .done
        confirmNewPasswordTextField.enablesReturnKeyAutomatically = true
        confirmNewPasswordTextField.autocapitalizationType = .none
        confirmNewPasswordTextField.autocorrectionType = .no
        confirmNewPasswordTextField.setBottomBorder(color: UIColor.white, height: 1.0)
        confirmNewPasswordTextField.layer.backgroundColor = UIColor.mainDARKPURPLE.cgColor

       // passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        confirmNewPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmNewPasswordTextField.heightAnchor.constraint(equalToConstant: confirmNewPasswordTextField.intrinsicContentSize.height+(settingsInnerInset*0.4)).isActive = true
        
        confirmNewPasswordTextField.isHidden = true
        
        return confirmNewPasswordTextField
        
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
        confirmButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return confirmButton
        
    }()
    
    lazy private var containerView: UIView = {
        let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let containerStackView = UIStackView(arrangedSubviews: [passwordTextField, newPasswordTextField, confirmNewPasswordTextField])
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
    
    @objc func nextButtonTapped(){
        let user = Auth.auth().currentUser
      //  var credential: AuthCredential
        
        let email = (user?.email!)!
        let password = passwordTextField.text

        let credential = EmailAuthProvider.credential(withEmail: email, password: password!)
        
        user?.reauthenticate(with: credential, completion: { (result, err) in
            if err == nil{
                UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                    self.confirmNewPasswordTextField.isHidden = false
                    self.newPasswordTextField.isHidden = false
                    self.confirmButton.setTitle("Confirm", for: .normal)
                })
                self.passwordTextField.isUserInteractionEnabled = false
                self.passwordTextField.alpha = 0.6
                self.confirmButton.removeTarget(self, action: #selector(self.nextButtonTapped), for: .touchUpInside)
                self.confirmButton.addTarget(self, action: #selector(self.confirmButtonTapped), for: .touchUpInside)
                
            }else{
                               
                let alertVC = AlertViewController(alertTitle: "Incorrect Password", alertMessage: "The password you entered is incorrect")
                               
                self.present(alertVC, animated: true, completion: nil)
                
            }
        })
            

    }
    
    @objc func confirmButtonTapped(){
        let user = Auth.auth().currentUser
        
        let passwordFormat = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordFormat)
        
        if(newPasswordTextField.text != confirmNewPasswordTextField.text){
            
            let alertVC = AlertViewController(alertTitle: "Confirm Password", alertMessage: "Your confirmed password does not match your new password")
                           
            self.present(alertVC, animated: true, completion: nil)
        }
        else if(newPasswordTextField.text == passwordTextField.text){
            
            let alertVC = AlertViewController(alertTitle: "Change Password", alertMessage: "Your new password cannot be the same as your current password")
                           
            self.present(alertVC, animated: true, completion: nil)
        }
        else if !(passwordPredicate.evaluate(with: newPasswordTextField.text)) {
                           
            let alertVC = AlertViewController(alertTitle: "Invalid Password", alertMessage: "Password must be at least 8 characters, 1 upper case, and 1 digit.")
                           
            self.present(alertVC, animated: true, completion: nil)
            
        }else{
            user?.updatePassword(to: newPasswordTextField.text!) { (error) in
                if error == nil {
                    
                    let alertVC = AlertViewController(alertTitle: "Success", alertMessage: "Password successfully changed!", leftAction: { [weak self] in
                        
                        guard let self = self else { return }
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                                              
                    self.present(alertVC, animated: true, completion: nil)
                }
                else{
                    
                    let alertVC = AlertViewController(alertTitle: "Error", alertMessage: "An error occured", leftAction: { [weak self] in
                        
                        guard let self = self else { return }
                        
                        self.navigationController?.popViewController(animated: true)
                    })
                    
                    self.present(alertVC, animated: true, completion: nil)
                }
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
