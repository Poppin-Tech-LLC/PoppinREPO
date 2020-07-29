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
    
    init(with color: UIColor?) {
        
        super.init(frame: .zero)
        
        if let color = color { self.borderColor = color }
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = .clear
        
        addSubview(popsicleIconImageView)
        popsicleIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleIconImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        popsicleIconImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        popsicleIconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.06).isActive = true
        popsicleIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(popsicleBorderLeftView)
        popsicleBorderLeftView.translatesAutoresizingMaskIntoConstraints = false
        popsicleBorderLeftView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        popsicleBorderLeftView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.44).isActive = true
        popsicleBorderLeftView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        popsicleBorderLeftView.heightAnchor.constraint(equalTo: popsicleIconImageView.heightAnchor, multiplier: 0.13).isActive = true
        
        addSubview(popsicleBorderRightView)
        popsicleBorderRightView.translatesAutoresizingMaskIntoConstraints = false
        popsicleBorderRightView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        popsicleBorderRightView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.44).isActive = true
        popsicleBorderRightView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        popsicleBorderRightView.heightAnchor.constraint(equalTo: popsicleIconImageView.heightAnchor, multiplier: 0.13).isActive = true
        
    }
    
}
