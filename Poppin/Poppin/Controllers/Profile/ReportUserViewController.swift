//
//  ReportUserViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 8/4/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ReportUserViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    let reportInsetY: CGFloat = .getPercentageWidth(percentage: 5)
    let reportInsetX: CGFloat = .getPercentageWidth(percentage: 5)
    let reportInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    let containerInsetY: CGFloat = .getPercentageWidth(percentage: 9)
    let containerInsetX: CGFloat = .getPercentageWidth(percentage: 9)
    
    let reports: [String] = ["", "Abusive or hateful language", "False advertising of event", "Spam", "Account is hacked"]
    
    var uid: String = ""
      
    
    lazy var reportLabel: UILabel = {
       let reportLabel = UILabel()
        reportLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        reportLabel.text = "Report user"
        reportLabel.backgroundColor = .clear
        reportLabel.textColor = .mainDARKPURPLE
        reportLabel.textAlignment = .center
        reportLabel.sizeToFit()
        return reportLabel
    }()
    
    lazy private var backButton: ImageBubbleButton = {
        let backButton = ImageBubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft).withTintColor(.mainDARKPURPLE))
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return backButton
    }()
    
        lazy private var menuPopsicleBorderImageView: UIImageView = {
            
            var menuPopsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.mainDARKPURPLE))
            menuPopsicleBorderImageView.contentMode = .scaleAspectFit
            return menuPopsicleBorderImageView
            
        }()
        
        lazy private var reportType: UITextField = {
            
            var reportType = UITextField()
            reportType.backgroundColor = .clear
            reportType.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
            reportType.textColor = .mainDARKPURPLE
            reportType.attributedPlaceholder = NSAttributedString(string: "Report type", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.mainDARKPURPLE])
            reportType.delegate = self
            reportType.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: reportType.intrinsicContentSize.height))
            reportType.leftViewMode = .always
            reportType.clearButtonMode = .whileEditing
            reportType.returnKeyType = .done
            reportType.enablesReturnKeyAutomatically = true
            reportType.autocapitalizationType = .none
            reportType.autocorrectionType = .no
            
            reportType.setBottomBorder(color: UIColor.mainDARKPURPLE, height: 1.0)
            
            let uniToolbar = UIToolbar()
            
            uniToolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneStartActionDate))
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            uniToolbar.setItems([flexSpace,doneButton], animated: true)
            
            reportType.inputAccessoryView = uniToolbar
            
            reportType.inputView = reportPicker
            reportType.isUserInteractionEnabled = true
            
            reportType.translatesAutoresizingMaskIntoConstraints = false
            reportType.heightAnchor.constraint(equalToConstant: reportType.intrinsicContentSize.height+(reportInnerInset*0.4)).isActive = true
            
            return reportType
            
        }()
    
    lazy private var reportPicker: UIPickerView = {
         let reportPicker = UIPickerView()
         reportPicker.delegate = self
         reportPicker.dataSource = self
         reportPicker.setValue(UIColor.mainDARKPURPLE, forKeyPath: "textColor")
         return reportPicker
     }()
    
    @objc func doneStartActionDate() {
     
           view.endEditing(true)
           
       }
    
    lazy private var reportDetailsTextView: UITextView = {
       let reportDetailsTextView = UITextView()
        reportDetailsTextView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        reportDetailsTextView.backgroundColor = .clear
        reportDetailsTextView.textColor = .mainDARKPURPLE
        reportDetailsTextView.text = "Add details (optional)"
        reportDetailsTextView.textAlignment = .left
        reportDetailsTextView.delegate = self
        reportDetailsTextView.isHidden = true
        reportDetailsTextView.sizeToFit()
        reportDetailsTextView.layer.borderWidth = 2
        reportDetailsTextView.layer.borderColor = UIColor.mainDARKPURPLE.cgColor
        reportDetailsTextView.autocapitalizationType = .none
        reportDetailsTextView.autocorrectionType = .no
        reportDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        reportDetailsTextView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 20)).isActive = true

        return reportDetailsTextView
    }()
    
    lazy private var confirmButton: BubbleButton = {
        
        let innerEdgeInset: CGFloat = .getPercentageWidth(percentage: 1.5)

       let confirmButton = BubbleButton(bouncyButtonImage: nil)
        confirmButton.setTitle("Next", for: .normal)
        confirmButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        confirmButton.backgroundColor = .mainDARKPURPLE
        confirmButton.titleLabel?.textAlignment = .center
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.contentEdgeInsets = UIEdgeInsets(top: innerEdgeInset, left: innerEdgeInset*2, bottom: innerEdgeInset, right: innerEdgeInset*2)
        confirmButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return confirmButton
        
    }()
    
    lazy private var containerView: UIView = {
        let settingsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 6.5)
        
        let containerStackView = UIStackView(arrangedSubviews: [reportType, reportDetailsTextView])
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
    
    init(with uid: String) {
           
           super.init(nibName: nil, bundle: nil)
           self.uid = uid
           
       }
       
       required init?(coder: NSCoder) {
           
           super.init(coder: coder)
           
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissKeyboardGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        dismissKeyboardGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKeyboardGesture)
        
        view.backgroundColor = .white
        
        view.addSubview(reportLabel)
          reportLabel.translatesAutoresizingMaskIntoConstraints = false
          reportLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: reportInsetY).isActive = true
          reportLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
         view.addSubview(backButton)
          backButton.translatesAutoresizingMaskIntoConstraints = false
          backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: reportInsetX).isActive = true
          backButton.centerYAnchor.constraint(equalTo: reportLabel.centerYAnchor).isActive = true
          backButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
           backButton.widthAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
          
          view.addSubview(menuPopsicleBorderImageView)
          menuPopsicleBorderImageView.translatesAutoresizingMaskIntoConstraints = false
          menuPopsicleBorderImageView.topAnchor.constraint(equalTo: reportLabel.bottomAnchor, constant: -(.getPercentageHeight(percentage: 2))).isActive = true
          menuPopsicleBorderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
          menuPopsicleBorderImageView.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 10)).isActive = true
          menuPopsicleBorderImageView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 90)).isActive = true
        

        view.addSubview(containerView)
               containerView.translatesAutoresizingMaskIntoConstraints = false
               containerView.topAnchor.constraint(equalTo: menuPopsicleBorderImageView.bottomAnchor).isActive = true
               containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
               containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: containerInsetX).isActive = true
               containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -containerInsetX).isActive = true
        // Do any additional setup after loading the view.
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
    
    @objc private func dismissKeyboard() { view.endEditing(true) }
    
    @objc func goBack(){
           navigationController?.popViewController(animated: true)
    }

    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }

    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return reports.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return reports[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        reportType.text = reports[row]
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       // universityPicker.isHidden = false
        return true
    }

    func textField(_ textField: UITextField, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return false
    }
//
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {


        return true
       }

    func textViewDidBeginEditing (_ textView: UITextView) {
        if(textView.text == "Add details (optional)"){
            reportDetailsTextView.text = ""
        }
    }

    func textViewDidEndEditing (_ textView: UITextView) {
        if(textView.text.trimmingCharacters(in: .whitespaces).isEmpty){
                   reportDetailsTextView.text = "Add details (optional)"
        }
    }

    @objc func nextButtonTapped(){
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.confirmButton.setTitle("Confirm", for: .normal)
            self.reportDetailsTextView.isHidden = false
        })
        confirmButton.removeTarget(self, action: #selector(self.nextButtonTapped), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(self.confirmButtonTapped), for: .touchUpInside)
                      
    }
    
    @objc func confirmButtonTapped(){
        let db = Firestore.firestore()
        
        db.collection("users").document(uid).updateData(["reports" : FieldValue.increment(Int64(1)),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

       _ = db.collection("users").document(uid).collection("reports").addDocument(data: [
            "reportType": reportType.text!,
            "reportDetails": reportDetailsTextView.text!,
            "reportedBy": Auth.auth().currentUser!.uid
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: {
                    self.navigationController?.popViewController(animated: true)
                })
                let alertVC = AlertViewController(alertTitle: "Reported User", alertMessage: "User successfully reported", alertButtons: [button1])
                
                self.present(alertVC, animated: true, completion: nil)
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
