//
//  TitleInputView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// Event Title Input Page UI
final class TitleInputView: UIView {

    /// Event title character limit (50).
    let maxCharacterCount: Int = EventModel.maxTitleLength
    
    // Card container.
    lazy private var cardView: CardView = {
        
        let cardView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0], padding: UIEdgeInsets(top: 0.0, left: .width(percent: 8.0), bottom: .width(percent: 3.0), right: .width(percent: 9.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [contentStack, navigationBar].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        navigationBar.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor)
        
        contentStack.anchor(top: navigationBar.bottomAnchor, leading: cardView.layoutMarginsGuide.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.layoutMarginsGuide.trailingAnchor)
        
        return cardView
        
    }()
    
    // Top bar containing the cancel button, the input title label, and the save button.
    lazy private var navigationBar: CardView = {
        
        let navigationBar = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0], padding: .zero, cornerRadius: 0.0, shadow: Shadow(color: EventCategory.allCases[0].getGradientColors()[1].withAlphaComponent(0.6), radius: 4.0, x: 0.0, y: 1.0))
        navigationBar.layer.shadowOpacity = 0.0
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [cancelButton, titleLabel, saveButton].map { navigationBar.addSubview($0) }
        
        // 2. Apply constraints.
        cancelButton.anchor(top: navigationBar.topAnchor, leading: navigationBar.leadingAnchor, bottom: navigationBar.bottomAnchor)
        
        titleLabel.anchor(top: navigationBar.topAnchor, bottom: navigationBar.bottomAnchor, centerX: navigationBar.centerXAnchor, padding: UIEdgeInsets(top: cancelButton.padding.top, left: 0.0, bottom: cancelButton.padding.bottom, right: 0.0))
        
        saveButton.anchor(top: navigationBar.topAnchor, bottom: navigationBar.bottomAnchor, trailing: navigationBar.trailingAnchor)
        
        return navigationBar
        
    }()
    
    /// Closes the input field and ignores any changes.
    lazy private(set) var cancelButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[0], label: OctarineLabel(text: "Cancel", color: .white, bold: false, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 4.0), left: .width(percent: 4.0), bottom: .width(percent: 4.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 4.0))
    
    // Input title label.
    lazy private var titleLabel = OctarineLabel(text: "Event Title", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1)
    
    /// Closes the input field and updates the event title.
    lazy private(set) var saveButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[0], label: OctarineLabel(text: "Save", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 4.0), left: .width(percent: 4.0), bottom: .width(percent: 4.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 4.0))
    
    /// Content scrollable stack.
    lazy private(set) var contentStack: ScrollableStackView = {
        
        let contentStack = ScrollableStackView(stackView: StackView(subviews: [titleTextView], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 4.0), padding: .zero), padding: UIEdgeInsets(top: .width(percent: 1.0), left: 0.0, bottom: .width(percent: 1.0), right: 0.0))
        contentStack.delegate = self
        return contentStack
        
    }()

    /// Event title input field.
    lazy private(set) var titleTextView: UITextView = {
        
        let titleTextView = UITextView()
        titleTextView.backgroundColor = EventCategory.allCases[0].getGradientColors()[0]
        titleTextView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        titleTextView.textColor = .white
        titleTextView.inputAccessoryView = characterCountView
        titleTextView.returnKeyType = .done
        titleTextView.isScrollEnabled = false
        titleTextView.textAlignment = .left
        titleTextView.setBottomBorder(color: .white, height: 1.0)
        return titleTextView
        
    }()
    
    // Accessory view on top of the keyboard.
    lazy private var characterCountView: CardView = {
        
        let characterCountView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0])
        characterCountView.frame = CGRect(x: 0.0, y: 0.0, width: .width(percent: 100), height: characterCountLabel.intrinsicContentSize.height + 2.0 + .width(percent: 4.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [borderView, characterCountLabel].map { characterCountView.addSubview($0) }
        
        // 2. Apply constraints.
        borderView.anchor(top: characterCountView.topAnchor, leading: characterCountView.leadingAnchor, trailing: characterCountView.trailingAnchor)
        
        characterCountLabel.anchor(centerX: characterCountView.centerXAnchor, centerY: characterCountView.centerYAnchor)

        return characterCountView
        
    }()
    
    // Border of the accessory view.
    lazy private var borderView: CardView = {
        
        let borderView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[1])
        borderView.anchor(size: CGSize(width: 0.0, height: 2.0))
        return borderView
        
    }()
    
    /// Length (in number of characters) of the current event title.
    lazy private(set) var characterCountLabel = OctarineLabel(text: "0 / " + String(maxCharacterCount), color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1)
    
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
        
        // 1. Sets the color of the background to the current event category (defaults to culture purple).
        backgroundColor = EventCategory.allCases[0].getGradientColors()[1]
        
        // 2. Add subviews to the root view.
        addSubview(cardView)
        
        // 3. Apply constraints.
        cardView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 3.0), right: .width(percent: 4.0)))
        
    }
    
    /// Updates the UI according to the current input entered for the event being created. If any values are nil, default ones are used.
    func updateUI(eventInput: EventModel?) {
        
        let lightColor = eventInput?.category?.getGradientColors()[0] ?? EventCategory.allCases[0].getGradientColors()[0]
        let highlightedColor = lightColor.darkerColor(percent: 0.1)
        let darkColor = eventInput?.category?.getGradientColors()[1] ?? EventCategory.allCases[0].getGradientColors()[1]
     
        // 1. Change background and card color.
        backgroundColor = darkColor
        cardView.backgroundColor = lightColor
        
        // 2. Change navigation bar color.
        navigationBar.backgroundColor = lightColor
        navigationBar.layer.shadowColor = darkColor.withAlphaComponent(0.6).cgColor
        
        // 3. Change cancel button color.
        cancelButton.backgroundColor = lightColor
        cancelButton.highlightedColor = highlightedColor
        cancelButton.nonHighlightedColor = lightColor
        
        // 4. Change save button color.
        saveButton.backgroundColor = lightColor
        saveButton.highlightedColor = highlightedColor
        saveButton.nonHighlightedColor = lightColor
        
        // 5. Update title text view.
        titleTextView.backgroundColor = lightColor
        titleTextView.text = eventInput?.title
        
        // 6. Change character count view and border view color.
        characterCountView.backgroundColor = lightColor
        borderView.backgroundColor = darkColor
        
        // 7. Update character count label.
        characterCountLabel.text = String(eventInput?.title != nil && eventInput?.title?.count != nil ? eventInput!.title!.count : 0) + " / " + String(maxCharacterCount)
        
    }
    
}

extension TitleInputView: UIScrollViewDelegate {
    
    /**
    Delegate function triggered when the scroll view scrolls. Depending on the position of the scrollable content, the navigation bar drops a shadow.

    - Parameters:
        - scrollView: Scroll view that scrolled.
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= 0.0, scrollView.contentOffset.y <= scrollView.contentInset.top {
         
            navigationBar.layer.shadowOpacity = Float(scrollView.contentOffset.y / scrollView.contentInset.top)
            
        } else if scrollView.contentOffset.y < 0.0 {
            
            navigationBar.layer.shadowOpacity = 0.0
            
        } else {
            
            navigationBar.layer.shadowOpacity = 1.0
            
        }
        
    }
    
}

struct PreviewTitleInputView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = TitleInputView
    
}

struct TestPreviewTitleInputView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewTitleInputView
    
}

