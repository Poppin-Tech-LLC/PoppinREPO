//
//  BubbleImageView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/30/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class BubbleImageView: UIImageView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}
