//
//  TitleInputView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct PreviewTitleInputView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType(title: nil, category: nil)
        
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

final class TitleInputView: UIView {
    
    let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var title: String?
    private var category: EventCategory = .Culture
    
    lazy private var cardView: UIView = {
        
        let topFadeEdgeView = FadeEdgeView(color: category.getGradientColors()[0], top: true)
        let bottomFadeEdgeView = FadeEdgeView(color: category.getGradientColors()[0], top: false)
       
        var cardView = UIView()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        cardView.backgroundColor = category.getGradientColors()[0]
        
        cardView.addSubview(cardScrollView)
        cardScrollView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: -yInset, left: xInset, bottom: 0.0, right: xInset))
        
        cardView.addSubview(topFadeEdgeView)
        topFadeEdgeView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor)
        
        cardView.addSubview(bottomFadeEdgeView)
        bottomFadeEdgeView.anchor(leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, size: CGSize(width: 0.0, height: yInset))
        
        cardView.addSubview(cancelButton)
        cancelButton.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: 0.0, right: 0.0))
        topFadeEdgeView.anchor(height: cancelButton.heightAnchor, constants: CGSize(width: 0.0, height: yInset*2))
        
        cardView.addSubview(titleTitleLabel)
        titleTitleLabel.anchor(centerX: cardView.centerXAnchor, centerY: cancelButton.centerYAnchor)
        
        cardView.addSubview(saveButton)
        saveButton.anchor(top: cardView.topAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: yInset, left: 0.0, bottom: 0.0, right: xInset))
        
        return cardView
        
    }()
    
    lazy private(set) var cancelButton: BouncyButton = {
        
        var cancelButton = BouncyButton(bouncyButtonImage: nil)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        cancelButton.setTitleColor(.white, for: .normal)
        return cancelButton
        
    }()
    
    lazy private var titleTitleLabel: UILabel = {
        
        var titleTitleLabel = UILabel()
        titleTitleLabel.text = "Title"
        titleTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        titleTitleLabel.textColor = .white
        titleTitleLabel.textAlignment = .center
        titleTitleLabel.numberOfLines = 1
        return titleTitleLabel
        
    }()
    
    lazy private(set) var saveButton: BouncyButton = {
        
        var saveButton = BouncyButton(bouncyButtonImage: nil)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        saveButton.setTitleColor(.white, for: .normal)
        return saveButton
        
    }()
    
    lazy private(set) var cardScrollView: UIScrollView = {
        
        let topSpacingView = UIView()
        topSpacingView.backgroundColor = .clear
        topSpacingView.anchor(size: CGSize(width: 0.0, height: yInset))
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        containerView.addSubview(topSpacingView)
        topSpacingView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor)
        
        containerView.addSubview(titleTextView)
        titleTextView.anchor(top: topSpacingView.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor)
        
        var cardScrollView = UIScrollView()
        cardScrollView.alwaysBounceVertical = false
        cardScrollView.showsVerticalScrollIndicator = false
        cardScrollView.contentInset = UIEdgeInsets(top: saveButton.intrinsicContentSize.height + (yInset*2), left: 0.0, bottom: yInset, right: 0.0)
        
        cardScrollView.addSubview(containerView)
        containerView.anchor(top: cardScrollView.topAnchor, leading: cardScrollView.leadingAnchor, bottom: cardScrollView.bottomAnchor, trailing: cardScrollView.trailingAnchor, width: cardScrollView.widthAnchor)
        
        return cardScrollView
        
    }()

    lazy private(set) var titleTextView: UITextView = {
        
        var titleTextView = UITextView()
        titleTextView.backgroundColor = category.getGradientColors()[0]
        titleTextView.textColor = .white
        
        if let title = title {
            
            titleTextView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
            titleTextView.text = title
            
        } else {
            
            titleTextView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
            titleTextView.text = "Title"
            
        }
        
        titleTextView.inputAccessoryView = characterCountView
        titleTextView.returnKeyType = .done
        titleTextView.textContainerInset = UIEdgeInsets(top: yInset*0.16, left: xInset*0.16, bottom: yInset*0.16, right: xInset*0.16)
        titleTextView.isScrollEnabled = false
        titleTextView.textAlignment = .left
        titleTextView.setBottomBorder(color: .white, height: 1.0)
        return titleTextView
        
    }()
    
    lazy private(set) var characterCountView: UIView = {
        
        var characterCountView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: .getPercentageWidth(percentage: 100), height: characterCountLabel.intrinsicContentSize.height + (yInset*1.5)))
        characterCountView.backgroundColor = category.getGradientColors()[0]
        
        let borderView = UIView()
        borderView.backgroundColor = category.getGradientColors()[1]
        
        characterCountView.addSubview(borderView)
        borderView.anchor(top: characterCountView.topAnchor, leading: characterCountView.leadingAnchor, trailing: characterCountView.trailingAnchor, size: CGSize(width: 0.0, height: 2.0))
        
        characterCountView.addSubview(characterCountLabel)
        characterCountLabel.anchor(centerX: characterCountView.centerXAnchor, centerY: characterCountView.centerYAnchor)

        return characterCountView
        
    }()
    
    lazy private(set) var characterCountLabel: UILabel = {
        
        var characterCountLabel = UILabel()
        characterCountLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        characterCountLabel.text = "0 / 0"
        characterCountLabel.textColor = .white
        characterCountLabel.numberOfLines = 1
        characterCountLabel.textAlignment = .center
        return characterCountLabel
        
    }()
    
    init(title: String?, category: EventCategory?) {
        
        super.init(frame: .zero)
        
        self.title = title
        if let category = category { self.category = category }
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        backgroundColor = category.getGradientColors()[1]
        
        addSubview(cardView)
        cardView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset))
        
    }
    
}

