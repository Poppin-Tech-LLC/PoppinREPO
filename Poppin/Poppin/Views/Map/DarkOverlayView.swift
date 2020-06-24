//
//  DarkOverlayView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 5/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class DarkOverlayView: UIView {
    
    lazy private var darkAlpha: CGFloat = 0.3
    
    private(set) var isVisible: Bool = true {
        
        willSet (newVisibility) {
            
            if isVisible != newVisibility {
                
                if newVisibility {
                    
                    UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseIn, animations: {
                        
                        self.alpha = 1.0
                                    
                    }, completion: nil)
                    
                } else {
                    
                    UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: .curveEaseOut, animations: {
                        
                        self.alpha = 0.0
                                    
                    }, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    convenience init () {
        
        self.init(darkAlpha: nil)
        
    }
    
    init(darkAlpha: CGFloat?) {
        
        super.init(frame: .zero)
        
        if let newDarkAlpha = darkAlpha { self.darkAlpha = newDarkAlpha }
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = UIColor.darkGray.withAlphaComponent(darkAlpha)
        
    }
    
    func toggleDarkOverlayView() {
        
        isVisible = !isVisible
        
    }
    
}

