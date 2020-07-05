//
//  writeDetailsViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/25/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit

class writeDetailsViewController: UIViewController, UITextViewDelegate {

    lazy var detailsTextField: UITextView = {
        let detailsTextField = UITextView()
        detailsTextField.backgroundColor = .clear
        detailsTextField.textColor = .white
        detailsTextField.font = .dynamicFont(with: "Octarine-Light", style: .title3)
        //detailsTextField.text = "Add Details..."

        //eventNameTextField.attributedPlaceholder = NSAttributedString(string: "Add Title", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Bold", style: .title1), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
        detailsTextField.delegate = self
        detailsTextField.textAlignment = .left
        //eventNameTextField.lineBreakMode = NSLineBreakMode.byWordWrapping
        //eventNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: eventNameTextField.intrinsicContentSize.height))
        //eventNameTextField.leftViewMode = .always
        //eventNameTextField.clearButtonMode = .whileEditing
        //eventNameTextField.returnKeyType = .next
        //eventNameTextField.autocapitalizationType = .none
        //eventNameTextField.autocorrectionType = .no
        //eventNameTextField.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
        //detailsTextField.addShadowAndRoundCorners(cornerRadius: 20, topRightMask: false, topLeftMask: false)
        return detailsTextField
    }()
    
    lazy var whiteView: UIView = {
          let whiteView = UIView()
           //purpleTab.backgroundColor = .newDarkGold
        //whiteView.backgroundColor = .white
            var maskedCorners = CACornerMask()
               whiteView.layer.cornerRadius = 30
                      
               maskedCorners.insert(.layerMaxXMaxYCorner)
               maskedCorners.insert(.layerMinXMaxYCorner)
               whiteView.layer.maskedCorners = maskedCorners
           return whiteView
       }()
    
    lazy var purpleTab: UIView = {
       let purpleTab = UIView()
        //purpleTab.backgroundColor = .newDarkGold
        var maskedCorners = CACornerMask()
        purpleTab.layer.cornerRadius = 30
               
        maskedCorners.insert(.layerMaxXMinYCorner)
        maskedCorners.insert(.layerMinXMinYCorner)
        purpleTab.layer.maskedCorners = maskedCorners
        return purpleTab
    }()
    
     lazy var backButton: ImageBubbleButton = {
        let purpleArrow = UIImage(systemName: "multiply.circle.fill")!.withTintColor(.white)
        let backButton = ImageBubbleButton(bouncyButtonImage: purpleArrow)
        backButton.contentMode = .scaleToFill
       // backButton.setTitle("Back", for: .normal)
        //backButton.setTitleColor(.newPurple, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
    lazy var checkButton: UIButton = {
        let checkButton = UIButton()
        checkButton.setTitleColor(.white, for: .normal)
        checkButton.setTitle("done", for: .normal)
        checkButton.backgroundColor = .clear
        checkButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
        checkButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)


       // backButton.setTitle("Back", for: .normal)
        //backButton.setTitleColor(.newPurple, for: .normal)
        //backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return checkButton
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.font = .dynamicFont(with: "Octarine-Light", style: .title3)
        countLabel.textColor = .white
        countLabel.backgroundColor = .clear
        return countLabel
    }()
    
    lazy var loadingView: UIView = {
       let loadingView = UIView()
        loadingView.backgroundColor = .white
        return loadingView
    }()
    
    lazy var loadingBackView: UIView = {
       let loadingView = UIView()
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return loadingView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        detailsTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
     
        
        view.addSubview(whiteView)
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9).isActive = true
        //whiteView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.3).isActive = true
        whiteView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //whiteView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        whiteView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1).isActive = true
        whiteView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.05).isActive = true
        
        view.addSubview(detailsTextField)
             detailsTextField.translatesAutoresizingMaskIntoConstraints = false
             detailsTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.9).isActive = true
             detailsTextField.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.3 - 20).isActive = true
                    detailsTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailsTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height * 0.1).isActive = true
        detailsTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height * 0.4).isActive = true
             //detailsTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(purpleTab)
        purpleTab.translatesAutoresizingMaskIntoConstraints = false
        purpleTab.widthAnchor.constraint(equalTo: detailsTextField.widthAnchor).isActive = true
        purpleTab.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        purpleTab.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        purpleTab.bottomAnchor.constraint(equalTo: detailsTextField.topAnchor, constant: 1).isActive = true
        
        purpleTab.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        //backButton.topAnchor.constraint(equalTo: purpleTab.topAnchor, constant: view.bounds.height * 0.01).isActive = true
        backButton.centerYAnchor.constraint(equalTo: purpleTab.centerYAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: purpleTab.leadingAnchor, constant: view.bounds.width * 0.03).isActive = true
        
        purpleTab.addSubview(checkButton)
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        //checkButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        checkButton.centerYAnchor.constraint(equalTo: purpleTab.centerYAnchor).isActive = true
        //checkButton.topAnchor.constraint(equalTo: purpleTab.topAnchor, constant: view.bounds.height * 0.01).isActive = true
        checkButton.trailingAnchor.constraint(equalTo: purpleTab.trailingAnchor, constant: -view.bounds.width * 0.03).isActive = true
        
        purpleTab.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        //checkButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: purpleTab.centerYAnchor).isActive = true
        countLabel.centerXAnchor.constraint(equalTo: purpleTab.centerXAnchor).isActive = true


        

        //loadingBackView.leadingAnchor.constraint(equalTo: purplePopsicle.trailingAnchor, constant: backgroundView.bounds.width * 0.01).isActive = true
        //loadingBackView.topAnchor.constraint(equalTo: purplePopsicle.centerYAnchor).isActive = true
        
        //countLabel.topAnchor.constraint(equalTo: purpleTab.topAnchor, constant: view.bounds.height * 0.01).isActive = true
        //countLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -view.bounds.width * 0.01).isActive = true
        //view.bringSubviewToFront(loadingView)
        view.bringSubviewToFront(whiteView)
        view.bringSubviewToFront(detailsTextField)


        // Do any additional setup after loading the view.
    }
    
    @objc func goBack() {
        
        let button1 = AlertButton(alertTitle: "Yes", alertButtonAction: { [weak self] in
        
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            //let textInfo = [ "text" : "Add details..." ]
                    //NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: textInfo as [AnyHashable : Any])
        })
        
        let button2 = AlertButton(alertTitle: "no", alertButtonAction: nil)
        
        let alertVC = AlertViewController(alertTitle: nil, alertMessage: "Are you sure you wish to discard?", alertButtons: [button1, button2])
        
        self.present(alertVC, animated: true, completion: nil)
         
//         self.dismiss(animated: true, completion: nil)
//        if(detailsTextField.text == ""){
//            let textInfo = [ "text" : "Add details..." ]
//            NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: textInfo as [AnyHashable : Any])
//        }else{
//            let textInfo = [ "text" : detailsTextField.text ]
//            NotificationCenter.default.post(name: .myNotificationKey, object: nil, userInfo: textInfo as [AnyHashable : Any])
//        }
        

         
     }
    
    @objc func saveChanges() {
                 self.dismiss(animated: true, completion: nil)
                if(detailsTextField.text.trimmingCharacters(in: .whitespaces).isEmpty){
                    let textInfo = [ "text" : "Add details..." ]
                    NotificationCenter.default.post(name: .detailsWritten, object: nil, userInfo: textInfo as [AnyHashable : Any])
                }else{
                    let textInfo = [ "text" : detailsTextField.text ]
                    NotificationCenter.default.post(name: .detailsWritten, object: nil, userInfo: textInfo as [AnyHashable : Any])
                }
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if  detailsTextField.text == "Add details..." && detailsTextField.isFirstResponder {
            detailsTextField.text = nil
            //eventNameTextField.textColor = .white
        }
        let newPosition = detailsTextField.endOfDocument
        detailsTextField.selectedTextRange = detailsTextField.textRange(from: newPosition, to: newPosition)
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if detailsTextField.text.isEmpty || detailsTextField.text == "" {
            detailsTextField.textColor = .mainDARKPURPLE
            detailsTextField.text = "Add details..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        
        
        let newText = (detailsTextField.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        countLabel.text = String(numberOfChars) + "/250"
      
        
        return numberOfChars < 250
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
