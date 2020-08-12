//
//  RefreshButton.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 1/30/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class ActivityButton: BubbleButton {
    
    private let edgeInset: CGFloat = .getPercentageWidth(percentage: 1.8)
    
    private let activityButtonIcon: UIImage = UIImage(systemSymbol: .flameFill).withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal)
    
    lazy var activityCounter : UILabel = {
        
        var v = UILabel()
        v.backgroundColor = .mainDARKPURPLE
        
        v.textColor = .white
        v.textAlignment = .center
        v.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 8, maxSize: 10))
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 4.5)).isActive = true
        v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
        
        v.layer.cornerRadius = .getPercentageWidth(percentage: 4.5)/2
        v.layer.masksToBounds = true
        
        return v
        
    }()
    
    private(set) var activityButtonCount: Int = 0 {
        
        willSet(newCount) {
            
            if newCount != activityButtonCount {
                
                if newCount == 0 { // Hide Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    //self.backgroundColor = .white
                                    self.setImage(self.activityButtonIcon, for: .normal)
                                    self.contentEdgeInsets = UIEdgeInsets(top: self.edgeInset, left: self.edgeInset, bottom: self.edgeInset, right: self.edgeInset)
                                    
                                    self.activityCounter.isHidden = true
                                    
                    }, completion: nil)
                    
                } else if activityButtonCount == 0 { // Show Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    //self.backgroundColor = .white
                                    self.setImage(self.activityButtonIcon, for: .normal)
                                    self.contentEdgeInsets = UIEdgeInsets(top: self.edgeInset, left: self.edgeInset, bottom: self.edgeInset, right: self.edgeInset)
                                    
                                    self.activityCounter.isHidden = false
                                    self.activityCounter.text = "\(self.activityButtonCount)"
                                    
                    }, completion: nil)
                    
                } else { // Increase Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    self.activityCounter.text = "\(self.activityButtonCount)"
                                    
                    }, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    init() {
        
        super.init(bouncyButtonImage: activityButtonIcon)
        
        configureButton()
        
//        self.addSubview(activityCounter)
//        activityCounter.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .getPercentageWidth(percentage: 1.15)).isActive = true
//        activityCounter.topAnchor.constraint(equalTo: self.topAnchor, constant: -(.getPercentageHeight(percentage: 0.25))).isActive = true
     
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureButton()
        
    }
    
    private func configureButton() {
        
        addTarget(self, action: #selector(resetCounter), for: .touchUpInside)
        backgroundColor = .white
        contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
    }
    
    @objc private func resetCounter() {
        
        activityButtonCount = 0
        
    }
    
    func increaseCounter(by step: Int?) {
        
        if let newStep = step {
            
            if activityButtonCount + newStep > 99 {
                
                activityButtonCount = 99
                print("ERROR: Refresh Counter has reached max. Setting it to 999.")
                
            } else {
                
                activityButtonCount += newStep
                
            }
            
        }
        
    }
    
    func decreaseCounter(by step: Int?) {
        
        if let newStep = step {
            
            if activityButtonCount - newStep < 0 {
                
                activityButtonCount = 0
                print("ERROR: Refresh Counter is negative. Setting it to 0.")
                
            } else {
                
                activityButtonCount -= newStep
                
            }
            
        }
        
    }
    
}

