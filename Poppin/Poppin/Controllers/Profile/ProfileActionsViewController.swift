//
//  ProfileActionsViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 8/4/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

class ProfileActionsViewController: UIViewController {

    weak var delegate: ProfileActionsDelegate?
    
    let actionsInsetY: CGFloat = .getPercentageWidth(percentage: 5)
      let actionsInsetX: CGFloat = .getPercentageWidth(percentage: 5)
      let actionsInnerInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    var uid: String = ""
        
    lazy private var blockButtonView: ActionsButtonView = {
           
        var blockButtonView = ActionsButtonView(actionsButtonImage: UIImage(systemSymbol: .nosign), actionsButtonText: "Block user")
           return blockButtonView
           
       }()
    
    lazy private var reportButtonView: ActionsButtonView = {
           
        var reportButtonView = ActionsButtonView(actionsButtonImage: UIImage(systemSymbol: .flag), actionsButtonText: "Report user")
        reportButtonView.addTarget(target: self, action: #selector(toReportUser), for: .touchUpInside)
           return reportButtonView
           
       }()
    
    lazy private var actionsContentView: UIView = {
           
           let menuButtonsStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 8.3)
           
           let menuButtonsStackView = UIStackView(arrangedSubviews: [blockButtonView, reportButtonView])
           menuButtonsStackView.axis = .vertical
           menuButtonsStackView.alignment = .leading
           menuButtonsStackView.distribution = .fill
           menuButtonsStackView.spacing = menuButtonsStackViewSpacing
           
           var actionsContentView = UIView()
           // view.layer.cornerRadius = 20
            actionsContentView.backgroundColor = .clear
            actionsContentView.sizeToFit()
        
           actionsContentView.addSubview(menuButtonsStackView)
           menuButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
           menuButtonsStackView.topAnchor.constraint(equalTo: actionsContentView.topAnchor).isActive = true
           menuButtonsStackView.bottomAnchor.constraint(equalTo: actionsContentView.bottomAnchor).isActive = true
           menuButtonsStackView.leadingAnchor.constraint(equalTo: actionsContentView.leadingAnchor).isActive = true
           menuButtonsStackView.trailingAnchor.constraint(equalTo: actionsContentView.trailingAnchor).isActive = true
         //  menuButtonsStackView.widthAnchor.constraint(equalTo: actionsContentView.widthAnchor).isActive = true
           
           return actionsContentView
           
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
        
        view.backgroundColor = .white
        view.addShadowAndRoundCorners(cornerRadius: 20, bottomRightMask: false, bottomLeftMask: false)
        
        view.addSubview(actionsContentView)
        actionsContentView.translatesAutoresizingMaskIntoConstraints = false
        actionsContentView.topAnchor.constraint(equalTo: view.topAnchor, constant: actionsInsetY).isActive = true
       // actionsContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        actionsContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        actionsContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        actionsContentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        

        // Do any additional setup after loading the view.
    }
    
    @objc func toReportUser(){
        let vc = ReportUserViewController(with: uid)
        delegate?.closeProfileActions()
        navigationController?.pushViewController(vc, animated: true)
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

final class ActionsButtonView: UIView {
    
    let actionsButtonInsetY: CGFloat = .getPercentageWidth(percentage: 1)
    let actionsButtonInsetX: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var actionsButtonText: String?
    private var actionsButtonImage: UIImage?
    
    lazy private var actionsButton: UIButton = {
        
        var actionsButton = UIButton()
        actionsButton.backgroundColor = .clear
        actionsButton.addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        actionsButton.addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
        return actionsButton
        
    }()
    
    lazy private var actionsButtonImageView: UIImageView = {
        
        var actionsButtonImageView = UIImageView(image: actionsButtonImage?.withTintColor(UIColor.mainDARKPURPLE, renderingMode: .alwaysOriginal))
        actionsButtonImageView.contentMode = .scaleAspectFill
        
        actionsButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        actionsButtonImageView.heightAnchor.constraint(equalToConstant: actionsButtonLabel.intrinsicContentSize.height+actionsButtonInsetY).isActive = true
        actionsButtonImageView.widthAnchor.constraint(equalTo: actionsButtonImageView.heightAnchor).isActive = true
        
        return actionsButtonImageView
        
    }()
    
    lazy private var actionsButtonLabel: UILabel = {
        
        var actionsButtonLabel = UILabel()
        actionsButtonLabel.text = actionsButtonText
        actionsButtonLabel.font = .dynamicFont(with: "Octarine-Bold", style: .body)
        actionsButtonLabel.textColor = .mainDARKPURPLE
        actionsButtonLabel.textAlignment = .left
        
        actionsButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        actionsButtonLabel.heightAnchor.constraint(equalToConstant: actionsButtonLabel.intrinsicContentSize.height).isActive = true
        actionsButtonLabel.widthAnchor.constraint(equalToConstant: actionsButtonLabel.intrinsicContentSize.width).isActive = true
        
        return actionsButtonLabel
        
    }()
    
    init(actionsButtonImage: UIImage?, actionsButtonText: String?) {
        
        super.init(frame: .zero)
        
        self.actionsButtonImage = actionsButtonImage
        self.actionsButtonText = actionsButtonText
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = .white
        
        addSubview(actionsButtonImageView)
        actionsButtonImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        actionsButtonImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        actionsButtonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: actionsButtonInsetX).isActive = true
        
        addSubview(actionsButtonLabel)
        actionsButtonLabel.centerYAnchor.constraint(equalTo: actionsButtonImageView.centerYAnchor).isActive = true
        actionsButtonLabel.leadingAnchor.constraint(equalTo: actionsButtonImageView.trailingAnchor, constant: actionsButtonInsetX).isActive = true
        actionsButtonLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -actionsButtonInsetX).isActive = true
        
        addSubview(actionsButton)
        actionsButton.translatesAutoresizingMaskIntoConstraints = false
        actionsButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        actionsButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        actionsButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        actionsButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    @objc private func animateDown(sender: UIButton) {
        
        animate(transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95), alpha: 0.9)
        
    }
    
    @objc private func animateUp(sender: UIButton) {
        
        animate(transform: .identity, alpha: 1.0)
        
    }
    
    private func animate(transform: CGAffineTransform, alpha: CGFloat) {
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.alpha = alpha
                        self.transform = transform
                        
            }, completion: nil)
        
    }
    
    func addTarget(target: Any?, action: Selector, for event: UIControl.Event) {
        
        actionsButton.addTarget(target, action: action, for: event)
        
    }
}

