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
    
    private let refreshButtonIcon: UIImage = UIImage.refreshPopsiclesIcon128.withTintColor(.mainDARKPURPLE)
    
    private(set) var refreshButtonCount: Int = 0 {
        
        willSet(newCount) {
            
            if newCount != refreshButtonCount {
                
                if newCount == 0 { // Hide Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    self.backgroundColor = .white
                                    self.setImage(self.refreshButtonIcon, for: .normal)
                                    self.setTitle(nil, for: .normal)
                                    self.contentEdgeInsets = UIEdgeInsets(top: self.edgeInset, left: self.edgeInset, bottom: self.edgeInset, right: self.edgeInset)
                                    
                    }, completion: nil)
                    
                } else if refreshButtonCount == 0 { // Show Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    self.backgroundColor = .mainDARKPURPLE
                                    self.setImage(nil, for: .normal)
                                    self.setTitle(String(newCount), for: .normal)
                                    self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                    
                    }, completion: nil)
                    
                } else { // Increase Counter
                    
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 3,
                                   options: .curveEaseOut, animations: {
                                    
                                    self.setTitle(String(newCount), for: .normal)
                                    
                    }, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    init() {
        
        super.init(bouncyButtonImage: refreshButtonIcon)
        
        configureButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureButton()
        
    }
    
    private func configureButton() {
        
        addTarget(self, action: #selector(resetCounter), for: .touchUpInside)
        backgroundColor = .white
        titleLabel!.textAlignment = .center
        titleLabel!.textColor = .white
        titleLabel!.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 12, maxSize: 14))
        contentEdgeInsets = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        
    }
    
    @objc private func resetCounter() {
        
        refreshButtonCount = 0
        
    }
    
    func increaseCounter(by step: Int?) {
        
        if let newStep = step {
            
            if refreshButtonCount + newStep > 999 {
                
                refreshButtonCount = 999
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

