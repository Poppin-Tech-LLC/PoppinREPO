//
//  PopsicleBorderView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/14/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Border with a Popsicle Icon in the Middle.
final class PopsicleBorderView: UIView {
    
    /// Characteristics of the border (color and style).
    var borderTraits: (UIColor, UIFont.TextStyle) {
        
        didSet {
            
            borderIcon.image = UIImage.filledPopsicleIcon128.scalePreservingAspectRatio(targetSize: CGSize(width: UIFont.dynamicFont(with: "Octarine-Bold", style: borderTraits.1).pointSize, height: UIFont.dynamicFont(with: "Octarine-Bold", style: borderTraits.1).pointSize)).withTintColor(borderTraits.0, renderingMode: .alwaysOriginal)
            borderLeft.backgroundColor = UIColor(cgColor: borderTraits.0.cgColor)
            borderRight.backgroundColor = UIColor(cgColor: borderTraits.0.cgColor)
            
        }
        
    }
    
    // Horizontal stack containing the three components of the border.
    lazy private var borderStack = StackView(subviews: [borderLeft, borderIcon, borderRight], axis: .horizontal, alignment: .center, distribution: .fill, spacing: .width(percent: 2.0), padding: .zero)
    
    // Popsicle icon.
    lazy private var borderIcon = UIImageView(image: UIImage.filledPopsicleIcon128.scalePreservingAspectRatio(targetSize: CGSize(width: UIFont.dynamicFont(with: "Octarine-Bold", style: borderTraits.1).pointSize, height: UIFont.dynamicFont(with: "Octarine-Bold", style: borderTraits.1).pointSize)).withTintColor(borderTraits.0, renderingMode: .alwaysOriginal))
    
    // Left line of the border.
    lazy private var borderLeft = CardView(bgColor: borderTraits.0, cornerRadius: 1.5)

    // Right line of the border.
    lazy private var borderRight = CardView(bgColor: borderTraits.0, cornerRadius: 1.5)
    
    /**
    Overrides superclass initializer to initialize the border traits to default values (color black and headline style).

    - Parameter frame: Ignored by AutoLayout (default it to .zero)
    */
    override init(frame: CGRect) {
        
        borderTraits = (.black, .headline)
        
        super.init(frame: .zero)
        
    }
    
    /**
    Custom class init that initializes a popsicle border with a color and a style (size).

    - Parameters:
        - color: The background color of the border (defaults to black).
        - style: Text style that sets the size of the border.
    */
    init(with color: UIColor = .black, _ style: UIFont.TextStyle = .headline) {
        
        borderTraits = (color, style)
        
        super.init(frame: .zero)
        
        configureView()
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder from storyboard.
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configures UI.
    private func configureView() {
        
        // 1. Clears the background.
        backgroundColor = .clear
        
        // 2. Add subviews to the root view.
        addSubview(borderStack)
        
        // 3. Apply constraints.
        borderStack.attatchEdgesToSuperview()
        
        borderLeft.anchor(height: borderIcon.heightAnchor, multiples: CGSize(width: 1.0, height: 0.15))

        borderRight.anchor(width: borderLeft.widthAnchor, height: borderIcon.heightAnchor, multiples: CGSize(width: 1.0, height: 0.15))
        
    }
    
}
