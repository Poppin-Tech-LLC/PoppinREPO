//
//  CreatePopsicleSecondPageViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 6/6/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

class CreatePopsicleSecondPageViewController : UIViewController, UITextFieldDelegate {
    
    lazy private var cCard: UIView = {
        
        var v = UIView()
        v.backgroundColor = .white
        
        v.layer.masksToBounds = false
        v.layer.cornerRadius = 16
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        v.layer.shadowOpacity = 0.3
        v.layer.shadowRadius = 2
        
        var pImage = UIImageView()
        var label = UITextView()
        label.font = UIFont(name: "Octarine-Bold", size: 18)
        label.textColor = .mainDARKPURPLE
        label.textAlignment = .center
        
        switch (backgroundGradientColors[1])   {
        case UIColor.purple.cgColor:
            pImage.image = UIImage(named: "showsButton")
            label.text = "Shows"
        case UIColor.red.cgColor:
            pImage.image = UIImage(named: "educationButton")
            label.text = "Education"
        case UIColor.orange.cgColor:
            pImage.image = UIImage(named: "foodButton")
            label.text = "Food"
        case UIColor.yellow.cgColor:
            pImage.image = UIImage(named: "socialButton")
            label.text = "Social"
        case UIColor.green.cgColor:
            pImage.image = UIImage(named: "sportsButton")
            label.text = "Sports"
        default:
           break
         }
        
        v.addSubview(pImage)
        pImage.translatesAutoresizingMaskIntoConstraints = false
        pImage.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 14)).isActive = true
        pImage.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 6.5)).isActive = true
        pImage.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 1.5)).isActive = true
        pImage.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        v.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 28)).isActive = true
        label.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
        label.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 7.5)).isActive = true
        label.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        
        return v
        
    }()
    
    lazy private var nameCard: UITextField = {
        
        var t = UITextField()
        t.backgroundColor = .white
        let sideIcon = UIImageView(image: UIImage(systemSymbol: .squareAndPencil).withTintColor(.mainDARKPURPLE).imageWithInsets(insets: UIEdgeInsets(top: .getPercentageWidth(percentage: 1.5), left: .getPercentageWidth(percentage: 1.5), bottom: .getPercentageWidth(percentage: 1.5), right: .getPercentageWidth(percentage: 1.5))))
        sideIcon.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        sideIcon.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        t.leftView = sideIcon
        t.leftViewMode = .always
        
        t.layer.masksToBounds = false
        t.layer.cornerRadius = 16
        t.layer.shadowColor = UIColor.black.cgColor
        t.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        t.layer.shadowOpacity = 0.3
        t.layer.shadowRadius = 2
        
        t.font = UIFont(name: "Octarine", size: 20)
        t.textColor = .mainDARKPURPLE
        t.placeholder = "Name"
        
        t.autocorrectionType = .no
        t.keyboardType = .default
        t.returnKeyType = .done
        t.clearButtonMode = .whileEditing
        t.contentVerticalAlignment = .center
        t.delegate = self
        
        t.addTarget(self, action: #selector(nameChanged), for: .valueChanged)
        
        return t
        
    }()
    
    @objc func nameChanged() {
        self.name = nameCard.text!
        print(name)
    }
    
    lazy private var dateCard: UIView = {
        
        var t = UIView()
        t.backgroundColor = .white
        
        let sideIcon = UIImageView(image: UIImage(systemSymbol: .calendar))
        sideIcon.tintColor = .mainDARKPURPLE
        
        t.addSubview(sideIcon)
        sideIcon.translatesAutoresizingMaskIntoConstraints = false
        sideIcon.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 6.5)).isActive = true
        sideIcon.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 6.5)).isActive = true
        sideIcon.leadingAnchor.constraint(equalTo: t.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 1.75)).isActive = true
        sideIcon.centerYAnchor.constraint(equalTo: t.centerYAnchor).isActive = true

        t.layer.masksToBounds = false
        t.layer.cornerRadius = 16
        t.layer.shadowColor = UIColor.black.cgColor
        t.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        t.layer.shadowOpacity = 0.3
        t.layer.shadowRadius = 2
        
        return t
        
    }()
    
    lazy private var datePicker: UIDatePicker = {
        
        var d = UIDatePicker()
        
        d.minimumDate = Date()
        d.maximumDate = Date(timeInterval: 86340, since: d.minimumDate!)
        d.setValue(UIColor.mainDARKPURPLE, forKeyPath: "textColor")
        d.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        return d
        
    }()
    
    @objc func dateChanged() {
        self.date = datePicker.date
        print(date)
    }
    
    lazy private var durationCard: UIView = {
        
        var t = UIView()
        t.backgroundColor = .white
        
        let sideIcon = UIImageView(image: UIImage(systemSymbol: .timer))
        sideIcon.tintColor = .mainDARKPURPLE
        
        t.addSubview(sideIcon)
        sideIcon.translatesAutoresizingMaskIntoConstraints = false
        sideIcon.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 6.5)).isActive = true
        sideIcon.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 6.5)).isActive = true
        sideIcon.leadingAnchor.constraint(equalTo: t.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 1.75)).isActive = true
        sideIcon.centerYAnchor.constraint(equalTo: t.centerYAnchor).isActive = true
        
        t.layer.masksToBounds = false
        t.layer.cornerRadius = 16
        t.layer.shadowColor = UIColor.black.cgColor
        t.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        t.layer.shadowOpacity = 0.3
        t.layer.shadowRadius = 2
        
        return t
        
    }()
    
    lazy private var durPicker: UIDatePicker = {
        
        var d = UIDatePicker()
        d.datePickerMode = .countDownTimer
        d.minuteInterval = 5
        d.setValue(UIColor.mainDARKPURPLE, forKeyPath: "textColor")
        
        d.addTarget(self, action: #selector(durChanged), for: .valueChanged)
        
        return d
        
    }()
    
    @objc func durChanged() {
        
        if(durPicker.countDownDuration > 18000) {
            durPicker.countDownDuration = 18000
        }
        
        self.duration = durPicker.countDownDuration
        print(duration)
    }
    
    lazy private var infoCard: UITextField = {
        
        var t = UITextField()
        t.backgroundColor = .white
        
        let sideIcon = UIImageView(image: UIImage(systemSymbol: .textBubble).withTintColor(.mainDARKPURPLE).imageWithInsets(insets: UIEdgeInsets(top: .getPercentageWidth(percentage: 1.5), left: .getPercentageWidth(percentage: 1.5), bottom: .getPercentageWidth(percentage: 1.5), right: .getPercentageWidth(percentage: 1.5))))
        sideIcon.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        sideIcon.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        t.leftView = sideIcon
        t.leftViewMode = .always
        
        t.layer.masksToBounds = false
        t.layer.cornerRadius = 16
        t.layer.shadowColor = UIColor.black.cgColor
        t.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        t.layer.shadowOpacity = 0.3
        t.layer.shadowRadius = 2
        
        t.font = UIFont(name: "Octarine", size: 20)
        t.textColor = .mainDARKPURPLE
        t.placeholder = "More info"
        
        t.autocorrectionType = .no
        t.keyboardType = .default
        t.returnKeyType = .done
        t.clearButtonMode = .whileEditing
        t.contentVerticalAlignment = .center
        t.delegate = self
        
        t.addTarget(self, action: #selector(infoChanged), for: .valueChanged)
        
        return t
        
    }()
    
    @objc func infoChanged() {
        self.info = infoCard.text!
        print(info)
    }
    
    lazy private var cancelButton: BubbleButton = {
        
        var cb = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .multiply, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .medium)).withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal))

        cb.backgroundColor = .white
        cb.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 2), left: .getPercentageWidth(percentage: 2), bottom: .getPercentageWidth(percentage: 2), right: .getPercentageWidth(percentage: 2))
        
        cb.addTarget(self, action: #selector(dismissCreateCard), for: .touchUpInside)
        
        return cb
        
    }()
    
    @objc func dismissCreateCard() {
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy private var createButton: UIButton = {
        
        var cb = UIButton()
        cb.backgroundColor = .white
        cb.setTitle("Create", for: .normal)
        cb.setTitleColor(.mainDARKPURPLE, for: .normal)
        cb.titleLabel?.font = UIFont(name: "Octarine-Bold", size: 18)
        cb.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 2), left: .getPercentageWidth(percentage: 2), bottom: .getPercentageWidth(percentage: 2), right: .getPercentageWidth(percentage: 2))
        
        cb.addShadowAndRoundCorners(cornerRadius: 16)
        
        cb.addTarget(self, action: #selector(createCard), for: .touchUpInside)
        
        return cb
        
    }()
    
    @objc func createCard() {
        //
    }
    
    var backgroundGradientColors = [CGColor]()
    
    lazy var gLayer : CAGradientLayer = {
        let g = CAGradientLayer()
        g.type = .radial
        g.colors = backgroundGradientColors
        g.locations = [ 0 , 1 ]
        g.startPoint = CGPoint(x: 0.5, y: 0.5)
        g.endPoint = CGPoint(x: 1.4, y: 1.15)
        g.frame = view.layer.bounds
        return g
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        /* FOR TRIAL PURPOSES */
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
    
    private var category = -1
    private var name = ""
    private var date = Date()
    private var duration = -1.0
    private var info = ""

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .white

        // gradient
        view.layer.insertSublayer(gLayer, at: 0)
        
        // cancel button
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        cancelButton.heightAnchor.constraint(equalTo: cancelButton.widthAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 2)).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 5)).isActive = true
        
        view.addSubview(cCard)
        cCard.translatesAutoresizingMaskIntoConstraints = false
        cCard.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 80)).isActive = true
        cCard.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 12)).isActive = true
        cCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 15)).isActive = true
        cCard.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(nameCard)
        nameCard.translatesAutoresizingMaskIntoConstraints = false
        nameCard.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 80)).isActive = true
        nameCard.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 7)).isActive = true
        nameCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 30)).isActive = true
        nameCard.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(dateCard)
        dateCard.translatesAutoresizingMaskIntoConstraints = false
        dateCard.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 80)).isActive = true
        dateCard.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 7)).isActive = true
        dateCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 40)).isActive = true
        dateCard.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        dateCard.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 60)).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 6)).isActive = true
        datePicker.leadingAnchor.constraint(equalTo: dateCard.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 13)).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: dateCard.centerYAnchor).isActive = true
        
        view.addSubview(durationCard)
        durationCard.translatesAutoresizingMaskIntoConstraints = false
        durationCard.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 80)).isActive = true
        durationCard.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 7)).isActive = true
        durationCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 50)).isActive = true
        durationCard.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        durationCard.addSubview(durPicker)
        durPicker.translatesAutoresizingMaskIntoConstraints = false
        durPicker.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 60)).isActive = true
        durPicker.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 6)).isActive = true
        durPicker.leadingAnchor.constraint(equalTo: durationCard.safeAreaLayoutGuide.leadingAnchor, constant: .getPercentageWidth(percentage: 13)).isActive = true
        durPicker.centerYAnchor.constraint(equalTo: durationCard.centerYAnchor).isActive = true
        
        view.addSubview(infoCard)
        infoCard.translatesAutoresizingMaskIntoConstraints = false
        infoCard.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 80)).isActive = true
        infoCard.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 7)).isActive = true
        infoCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 60)).isActive = true
        infoCard.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 24)).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 4.5)).isActive = true
        createButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 80)).isActive = true
        createButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
    }
    
    //MARK: Textfield Delegate
    // When user press the return key in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }

    // It is called before text field become active
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.lightGray
        return true
    }

    // It is called when text field activated
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
    }

    // It is called when text field going to inactive
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.backgroundColor = UIColor.white
        return true
    }

    // It is called when text field is inactive
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }

    // It is called each time user type a character by keyboard
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under a specific number characters according to the appropriate text field
        if(textField == nameCard) {
            return updatedText.count <= 30
        } else {
            return updatedText.count <= 250
        }
    }
    
}

extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

