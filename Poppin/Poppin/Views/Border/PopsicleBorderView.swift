//
//  PopsicleBorderView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/14/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class PopsicleBorderView: UIView {
    
    private var borderColor: UIColor = .black
    private(set) var lineHeight: CGFloat = .getPercentageWidth(percentage: 0.5)
    
    lazy private var popsicleIconImageView: UIImageView = {
        
        var popsicleIconImageView = UIImageView(image:  UIImage.filledPopsicleIcon64.withTintColor(borderColor, renderingMode: .alwaysOriginal))
        popsicleIconImageView.contentMode = .scaleAspectFit
        return popsicleIconImageView
        
    }()
    
    lazy private var popsicleBorderLeftView: UIView = {
        
        var popsicleBorderLeftView = UIView()
        popsicleBorderLeftView.backgroundColor = UIColor(cgColor: borderColor.cgColor)
        popsicleBorderLeftView.addShadowAndRoundCorners(cornerRadius: 2.0, shadowOpacity: 0.0)
        return popsicleBorderLeftView
        
    }()
    
    lazy var popsicleBorderRightView: UIView = {
        
        var popsicleBorderRightView = UIView()
        popsicleBorderRightView.backgroundColor = UIColor(cgColor: borderColor.cgColor)
        popsicleBorderRightView.addShadowAndRoundCorners(cornerRadius: 2.0, shadowOpacity: 0.0)
        return popsicleBorderRightView
        
    }()
    
    init(with color: UIColor?, lineHeight: CGFloat?) {
        
        super.init(frame: .zero)
        
        if let color = color { self.borderColor = color }
        if let lineHeight = lineHeight { self.lineHeight = lineHeight }
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = .clear
        
        addSubview(popsicleIconImageView)
        popsicleIconImageView.anchor(top: topAnchor, bottom: bottomAnchor, centerX: centerXAnchor, width: widthAnchor, size: CGSize(width: 0.0, height: lineHeight * 8.5), multiples: CGSize(width: 0.06, height: 1.0))
        
        addSubview(popsicleBorderLeftView)
        popsicleBorderLeftView.anchor(leading: leadingAnchor, centerY: centerYAnchor, width: widthAnchor, size: CGSize(width: 0.0, height: lineHeight), multiples: CGSize(width: 0.44, height: 1.0))
        
        addSubview(popsicleBorderRightView)
        popsicleBorderRightView.anchor(trailing: trailingAnchor, centerY: centerYAnchor, width: widthAnchor, size: CGSize(width: 0.0, height: lineHeight), multiples: CGSize(width: 0.44, height: 1.0))
        
    }
    
}
