//
//  AlertViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/18/20.
//  Copyright © 2020 PoppinREPO. All rights reserved.
//

import UIKit

final class AlertViewController: UIViewController {
    
    public static let defaultAlertTitle = "Alert Title"
    public static let defaultAlertMessage = "Alert Message"
    
    lazy private var alertTitle: String = AlertViewController.defaultAlertTitle
    lazy private var alertMessage: String = AlertViewController.defaultAlertMessage
    lazy private var alertButtons: [AlertButton] = [AlertButton(alertTitle: nil, alertButtonAction: nil)]
    private let horizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    private let verticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    lazy private var alertContainerView: UIView = {
        
        var alertContainerView = UIView()
        alertContainerView.backgroundColor = .white
        alertContainerView.addShadowAndRoundCorners()
        alertContainerView.clipsToBounds = true
        
        alertContainerView.addSubview(alertButtonsStackView)
        alertButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        alertButtonsStackView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor).isActive = true
        alertButtonsStackView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor).isActive = true
        alertButtonsStackView.bottomAnchor.constraint(equalTo: alertContainerView.bottomAnchor).isActive = true
        
        alertContainerView.addSubview(alertLabelsStackView)
        alertLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        alertLabelsStackView.topAnchor.constraint(equalTo: alertContainerView.topAnchor, constant: verticalEdgeInset).isActive = true
        alertLabelsStackView.leadingAnchor.constraint(equalTo: alertContainerView.leadingAnchor, constant: horizontalEdgeInset).isActive = true
        alertLabelsStackView.trailingAnchor.constraint(equalTo: alertContainerView.trailingAnchor, constant: -horizontalEdgeInset).isActive = true
        alertLabelsStackView.bottomAnchor.constraint(equalTo: alertButtonsStackView.topAnchor, constant: -verticalEdgeInset).isActive = true
        
        return alertContainerView
        
    }()
    
    lazy private var alertLabelsStackView: UIStackView = {
        
        let edgeInset: CGFloat = .getPercentageWidth(percentage: 3)
        
        var alertLabelsStackView = UIStackView(arrangedSubviews: [alertTitleLabel, alertMessageLabel])
        alertLabelsStackView.axis = .vertical
        alertLabelsStackView.alignment = .fill
        alertLabelsStackView.distribution = .fill
        alertLabelsStackView.spacing = edgeInset
        alertLabelsStackView.backgroundColor = .white
        return alertLabelsStackView
        
    }()
    
    lazy private var alertTitleLabel: UILabel = {
        
        var alertTitleLabel = UILabel()
        alertTitleLabel.textAlignment = .center
        alertTitleLabel.numberOfLines = 0
        alertTitleLabel.sizeToFit()
        alertTitleLabel.text = alertTitle
        alertTitleLabel.textColor = .mainDARKPURPLE
        alertTitleLabel.backgroundColor = .clear
        alertTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        return alertTitleLabel
        
    }()
    
    lazy private var alertMessageLabel: UILabel = {
        
        var alertMessageLabel = UILabel()
        alertMessageLabel.textAlignment = .center
        alertMessageLabel.numberOfLines = 0
        alertMessageLabel.sizeToFit()
        alertMessageLabel.text = alertMessage
        alertMessageLabel.textColor = .mainDARKPURPLE
        alertMessageLabel.backgroundColor = .clear
        alertMessageLabel.font = .dynamicFont(with: "Octarine-Light", style: .footnote)
        return alertMessageLabel
        
    }()
    
    lazy private var alertButtonsStackView: UIStackView = {
        
        var alertButtonsStackView = UIStackView()
        alertButtonsStackView.axis = .horizontal
        alertButtonsStackView.alignment = .fill
        alertButtonsStackView.distribution = .fillEqually
        alertButtonsStackView.spacing = 2.0
        alertButtonsStackView.backgroundColor = .mainDARKPURPLE
        return alertButtonsStackView
        
    }()
    
    convenience init() {
        
        self.init(alertTitle: nil, alertMessage: nil, alertButtons: nil)
        
    }
    
    init(alertTitle: String?, alertMessage: String?, alertButtons: [AlertButton]?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let newAlertTitle = alertTitle { self.alertTitle = newAlertTitle }
        if let newAlertMessage = alertMessage { self.alertMessage = newAlertMessage }
        if let newAlertButtons = alertButtons { self.alertButtons = newAlertButtons }
        
        configureAlert()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureAlert()
        
    }
    
    private func configureAlert() {
        
        for alertButton in alertButtons {
            
            alertButton.addTarget(self, action: #selector(executeAlertAction), for: .touchUpInside)
            alertButtonsStackView.addArrangedSubview(alertButton)
            
        }
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        view.addSubview(alertContainerView)
        alertContainerView.translatesAutoresizingMaskIntoConstraints = false
        alertContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertContainerView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 70)).isActive = true
        
    }
    
    @objc func executeAlertAction(sender: AlertButton) {
        
        self.dismiss(animated: true, completion: sender.alertButtonAction)
        
    }
    
}

final class AlertButton: UIButton {
    
    public static let defaultTitle = "Ok"
        
    lazy var alertButtonAction: (() -> Void) = {}
    
    private let edgeInset: CGFloat = .getPercentageWidth(percentage: 1.5)
    
    convenience init() {
        
        self.init(alertTitle: nil, alertButtonAction: nil)
        
    }
    
    init(alertTitle: String?, alertButtonAction: (() -> Void)?) {
        
        super.init(frame: .zero)
        
        setTitle(alertTitle ?? AlertButton.defaultTitle, for: .normal)
        if let newAlertButtonAction = alertButtonAction { self.alertButtonAction = newAlertButtonAction }
        configureButton()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        setTitle(AlertButton.defaultTitle, for: .normal)
        configureButton()
        
    }
    
    private func configureButton() {
        
        backgroundColor = .mainDARKPURPLE
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: intrinsicContentSize.height+edgeInset).isActive = true
        
    }
    
}
