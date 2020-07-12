//
//  RefreshButton.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 1/30/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class RefreshButton: BubbleButton {
    
    private let edgeInset: CGFloat = .getPercentageWidth(percentage: 1.8)
    
    private let refreshButtonIcon: UIImage = UIImage(systemSymbol: .flameFill).withTintColor(.mainDARKPURPLE, renderingMode: .alwaysOriginal)
    
    lazy var refreshCounter : UILabel = {
        
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
    
    private(set) var refreshButtonCount: Int = 0 {
        
        willSet(newCount) {
            
            if newCount != refreshButtonCount {
                
                if newCount == 0 { // Hide Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    self.backgroundColor = .white
                                    self.setImage(self.refreshButtonIcon, for: .normal)
                                    //self.setTitle(nil, for: .normal)
                                    self.contentEdgeInsets = UIEdgeInsets(top: self.edgeInset, left: self.edgeInset, bottom: self.edgeInset, right: self.edgeInset)
                                    
                                    self.refreshCounter.isHidden = true
                                    
                    }, completion: nil)
                    
                } else if refreshButtonCount == 0 { // Show Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    self.backgroundColor = .white
                                    self.setImage(self.refreshButtonIcon, for: .normal)
                                    //self.setTitleColor(.white, for: .normal)
                                    self.contentEdgeInsets = UIEdgeInsets(top: self.edgeInset, left: self.edgeInset, bottom: self.edgeInset, right: self.edgeInset)
                                    
                                    self.refreshCounter.isHidden = false
                                    self.refreshCounter.text = "\(self.refreshButtonCount)"
                                    
                    }, completion: nil)
                    
                } else { // Increase Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
//                                    self.setTitle(String(newCount), for: .normal)
                                    self.refreshCounter.text = "\(self.refreshButtonCount)"
                                    
                    }, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    init() {
        
        super.init(bouncyButtonImage: refreshButtonIcon)
        
        configureButton()
        
        self.addSubview(refreshCounter)
        refreshCounter.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .getPercentageWidth(percentage: 1.15)).isActive = true
        refreshCounter.topAnchor.constraint(equalTo: self.topAnchor, constant: -(.getPercentageHeight(percentage: 0.25))).isActive = true
        
        //refreshCounter.text = "\(refreshButtonCount)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureButton()
        
    }
    
    private func configureButton() {
        
        addTarget(self, action: #selector(resetCounter), for: .touchUpInside)
        backgroundColor = .poppinDARKGOLD
//        titleLabel!.textAlignment = .center
//        titleLabel!.textColor = .white
//        titleLabel!.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 12, maxSize: 14))
        contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
    }
    
    @objc private func resetCounter() {
        
        refreshButtonCount = 0
        
    }
    
    func increaseCounter(by step: Int?) {
        
        if let newStep = step {
            
            if refreshButtonCount + newStep > 99 {
                
                refreshButtonCount = 99
                print("ERROR: Refresh Counter has reached max. Setting it to 999.")
                
            } else {
                
                refreshButtonCount += newStep
                
            }
            
        }
        
    }
    
    func decreaseCounter(by step: Int?) {
        
        if let newStep = step {
            
            if refreshButtonCount - newStep < 0 {
                
                refreshButtonCount = 0
                print("ERROR: Refresh Counter is negative. Setting it to 0.")
                
            } else {
                
                refreshButtonCount -= newStep
                
            }
            
        }
        
    }
    
}

