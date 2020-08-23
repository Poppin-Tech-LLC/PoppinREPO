//
//  AlertView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/23/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// Alert Popover UI.
final class AlertView: UIView {
    
    // Card container.
    lazy private var cardView: CardView = {
        
        let cardView = CardView(bgColor: .white, cornerRadius: .width(percent: 3.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [topStack, bottomStack].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        topStack.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor)
        
        bottomStack.anchor(top: topStack.bottomAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor)
        
        return cardView
        
    }()
    
    // Top content stack (title and message labels).
    lazy private var topStack: StackView = {
        
        let topStack = StackView(subviews: [titleLabel, messageLabel], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 3.5), padding: NSDirectionalEdgeInsets(top: .width(percent: 3.5), leading: .width(percent: 3.5), bottom: .width(percent: 3.5), trailing: .width(percent: 3.5)))
        return topStack
        
    }()
    
    /// Alert title.
    lazy private(set) var titleLabel = OctarineLabel(color: .mainDARKPURPLE, bold: true, style: .headline, alignment: .center, lineLimit: 0)
    
    /// Alert message.
    lazy private(set) var messageLabel = OctarineLabel(color: .mainDARKPURPLE, bold: false, style: .subheadline, alignment: .center, lineLimit: 0)
    
    // Bottom content stack (buttons).
    lazy private var bottomStack: StackView = {
        
        let bottomStack = StackView(subviews: [leftButton, rightButton], axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 1.5)
        return bottomStack
        
    }()
    
    /// Left action of the alert ('no action' by default).
    lazy private(set) var leftButton: UIButton = {
        
        let leftButton = UIButton(type: .system)
        leftButton.backgroundColor = .mainDARKPURPLE
        leftButton.setTitleColor(.white, for: .normal)
        leftButton.titleLabel?.font = UIFont(name: "Octarine-Bold", size: .width(percent: 4.0))
        leftButton.titleLabel?.numberOfLines = 1
        leftButton.titleLabel?.textAlignment = .center
        leftButton.contentEdgeInsets = UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 2.0), bottom: .width(percent: 2.0), right: .width(percent: 2.0))
        return leftButton
        
    }()
    
    /// Right action of the alert.
    lazy private(set) var rightButton: UIButton = {
        
        let rightButton = UIButton(type: .system)
        rightButton.backgroundColor = .mainDARKPURPLE
        rightButton.setTitleColor(.white, for: .normal)
        rightButton.titleLabel?.font = UIFont(name: "Octarine-Bold", size: .width(percent: 4.0))
        rightButton.titleLabel?.numberOfLines = 1
        rightButton.titleLabel?.textAlignment = .center
        rightButton.contentEdgeInsets = UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 2.0), bottom: .width(percent: 2.0), right: .width(percent: 2.0))
        return rightButton
        
    }()
    
    /**
    Overrides superclass initializer to configure the UI.

    - Parameter frame: Ignored by AutoLayout (default it to .zero)
    */
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
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
        
        // 1. Dim the background.
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // 2. Add subviews to the root view (each one on top of the others).
        _ = [cardView].map { self.addSubview($0) }
        
        // 3. Apply constraints.
        cardView.anchor(centerX: centerXAnchor, centerY: centerYAnchor, size: CGSize(width: .width(percent: 70), height: 0.0))
        
    }
    
}

struct AlertViewPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = AlertView
    
}

struct AlertViewPreview_Test: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = AlertViewPreview
    
}
