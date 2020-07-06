//
//  SelfSizedTableView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class SelfSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        
        didSet {
            
            invalidateIntrinsicContentSize()
            
        }
        
    }

    override var intrinsicContentSize: CGSize {
        
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        
    }

}
