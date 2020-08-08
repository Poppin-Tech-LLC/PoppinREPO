//
//  ActivityView.swift
//  Poppin
//
//  Created by Josiah Aklilu on 8/6/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct PreviewActivityView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = ActivityView
    
}

struct TestPreviewActivityView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewDateInputView
    
}

final class ActivityView: UIView {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    weak var delegate: ActivityDelegate?
    
    lazy private var cardView: UIView = {
       
        var cardView = UIView()
       
        cardView.backgroundColor = .mainDARKPURPLE
        
        cardView.addSubview(avBorderView)
        avBorderView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor)
        
        cardView.addSubview(activityLabel)
        activityLabel.anchor(top: cardView.topAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: yInset*2, left: 0, bottom: 0, right: 0))
        
        cardView.addSubview(popsicleBorderImageView)
        
        cardView.addSubview(avFeed)
        
        return cardView
        
    }()
    
    lazy private var activityLabel: UILabel = {
        
        var activityLabel = UILabel()
        activityLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title2)
        activityLabel.textColor = .white
        activityLabel.text = "Activity"
        activityLabel.textAlignment = .center
        
        return activityLabel
        
    }()
    
    lazy private var popsicleBorderImageView: UIImageView = {
        
        var popsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.white))
        popsicleBorderImageView.contentMode = .scaleAspectFit
        return popsicleBorderImageView
        
    }()
    
    lazy private var avBorderView: UIView = {
        
        var avBorderView = UIView()
        avBorderView.backgroundColor = .white
        avBorderView.alpha = 1.0
        
        avBorderView.translatesAutoresizingMaskIntoConstraints = false
        avBorderView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return avBorderView
        
    }()
    
    lazy private var avFeed: UITableView = {
        
        var t = UITableView()
        t.backgroundColor = .mainDARKPURPLE
        t.isSpringLoaded = true
        t.allowsSelection = false
        t.showsHorizontalScrollIndicator = false
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        return t
        
    }()
    
}
