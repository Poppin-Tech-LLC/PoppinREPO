//
//  CreateEventFirstSectionView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/26/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

final class CreateEventFirstSectionView: UIView {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    lazy private(set) var backgroundImageView: UIImageView = UIImageView(image: EventCategory.allCases[0].getGradientBackground().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 100), height: .height(percent: 100))))
    
    lazy private(set) var closeButton: BubbleButton = {
        
        let innerInset = yInset*0.5
        
        var closeButton = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .xmark, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .title3).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
        closeButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset, bottom: innerInset, right: innerInset)
        closeButton.backgroundColor = .clear
        return closeButton
        
    }()
    
    lazy private(set) var titleLabel: UILabel = {
        
        var titleLabel = UILabel()
        titleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        titleLabel.text = "Create Event"
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        return titleLabel
        
    }()
    
    lazy private(set) var categoryPickerCollectionView : UICollectionView = {
        
        let categoryPickerCollectionViewLayout = UICollectionViewFlowLayout()
        categoryPickerCollectionViewLayout.scrollDirection = .horizontal
        categoryPickerCollectionViewLayout.minimumLineSpacing = 0
        
        var categoryPickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryPickerCollectionViewLayout)
        categoryPickerCollectionView.backgroundColor = .clear
        /*categoryPickerCollectionView.dataSource = self
        categoryPickerCollectionView.delegate = self*/
        categoryPickerCollectionView.isPagingEnabled = true
        categoryPickerCollectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.defaultReuseIdentifier)
        categoryPickerCollectionView.showsHorizontalScrollIndicator = false
        return categoryPickerCollectionView
        
    }()
    
    lazy private(set) var pageMarkerStackView: UIStackView = {
        
        var pageMarkers: [UIImageView] = []
        
        for _ in EventCategory.allCases {
            
            let pageIconImageView = UIImageView(image: UIImage.nonFilledPopsicleIcon64.withTintColor(UIColor.white, renderingMode: .alwaysOriginal))
            pageIconImageView.contentMode = .scaleAspectFit
            pageMarkers.append(pageIconImageView)
            
        }
        
        pageMarkers[0].image = UIImage.filledPopsicleIcon64.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        
        var pageMarkerStackView = UIStackView(arrangedSubviews: pageMarkers)
        pageMarkerStackView.axis = .horizontal
        pageMarkerStackView.alignment = .center
        pageMarkerStackView.distribution = .fillEqually
        pageMarkerStackView.spacing = .getWidthFitSize(minSize: 0, maxSize: .getPercentageWidth(percentage: 5))
        pageMarkerStackView.anchor(size: CGSize(width: 0.0, height: titleLabel.intrinsicContentSize.height*0.8))
        return pageMarkerStackView
        
    }()
    
    lazy private var visibilityStackView: UIStackView = {
        
        var visibilityStackView = UIStackView(arrangedSubviews: [privateVisibilityStackView, visibilitySwitch, publicVisibilityStackView])
        visibilityStackView.axis = .horizontal
        visibilityStackView.alignment = .center
        visibilityStackView.distribution = .fill
        visibilityStackView.spacing = xInset
        
        return visibilityStackView
        
    }()
    
    lazy private(set) var privateVisibilityStackView: UIStackView = {
        
        let privateIcon: UIImageView = UIImageView(image: UIImage(systemSymbol: .lockFill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal))
        privateIcon.contentMode = .scaleAspectFit
        
        let privateLabel: UILabel = UILabel()
        privateLabel.text = "Private"
        privateLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption1)
        privateLabel.numberOfLines = 1
        privateLabel.textAlignment = .center
        privateLabel.textColor = .white
        privateIcon.anchor(size: CGSize(width: 0.0, height: privateLabel.intrinsicContentSize.height*1.2))
        
        var privateVisibilityStackView: UIStackView = UIStackView(arrangedSubviews: [privateIcon, privateLabel])
        privateVisibilityStackView.alignment = .fill
        privateVisibilityStackView.axis = .vertical
        privateVisibilityStackView.distribution = .fill
        privateVisibilityStackView.spacing = 0
        
        return privateVisibilityStackView
        
    }()
    
    lazy private(set) var publicVisibilityStackView: UIStackView = {
       
        let publicIcon: UIImageView = UIImageView(image: UIImage(systemSymbol: .globe).withTintColor(UIColor.white, renderingMode: .alwaysOriginal))
        publicIcon.contentMode = .scaleAspectFit
        
        let publicLabel: UILabel = UILabel()
        publicLabel.text = "Public"
        publicLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption1)
        publicLabel.numberOfLines = 1
        publicLabel.textAlignment = .center
        publicLabel.textColor = .white
        
        publicIcon.anchor(size: CGSize(width: 0.0, height: publicLabel.intrinsicContentSize.height*1.2))
        
        var publicVisibilityStackView: UIStackView = UIStackView(arrangedSubviews: [publicIcon, publicLabel])
        publicVisibilityStackView.alignment = .fill
        publicVisibilityStackView.axis = .vertical
        publicVisibilityStackView.distribution = .fill
        publicVisibilityStackView.spacing = 0
        publicVisibilityStackView.alpha = 0.7
        
        return publicVisibilityStackView
        
    }()
    
    lazy private(set) var visibilitySwitch: UISwitch = {
        
        var visibilitySwitch = UISwitch()
        visibilitySwitch.onTintColor = .poppinLIGHTGOLD
        visibilitySwitch.thumbTintColor = .white
        visibilitySwitch.isOn = false
        visibilitySwitch.addTarget(self, action: #selector(toggleVisibilityStackViews(sender:)), for: .valueChanged)
        return visibilitySwitch
        
    }()
    
    lazy private(set) var visibilityCountLabel: UILabel = {
        
        var visibilityCountLabel = UILabel()
        visibilityCountLabel.text = "Unlimited"
        visibilityCountLabel.textColor = .white
        visibilityCountLabel.textAlignment = .center
        visibilityCountLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        visibilityCountLabel.numberOfLines = 1
        return visibilityCountLabel
        
    }()
    
    lazy private(set) var nextButton: BouncyButton = {
        
        let innerInset: CGFloat = yInset*0.4
        
        var nextButton = BouncyButton(bouncyButtonImage: nil)
        nextButton.backgroundColor = .white
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.textAlignment = .center
        nextButton.setTitleColor(EventCategory.Culture.getGradientColors()[1], for: .normal)
        nextButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        nextButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset*2, bottom: innerInset, right: innerInset*2)
        nextButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 14.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        return nextButton
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        addSubview(backgroundImageView)
        backgroundImageView.attatchEdgesToSuperview()
        
        addSubview(closeButton)
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: 0.0, right: 0.0))
        
        addSubview(titleLabel)
        titleLabel.anchor(centerX: centerXAnchor, centerY: closeButton.centerYAnchor)
        
        addSubview(categoryPickerCollectionView)
        categoryPickerCollectionView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: yInset, left: 0.0, bottom: 0.0, right: 0.0))
        
        addSubview(pageMarkerStackView)
        pageMarkerStackView.anchor(top: categoryPickerCollectionView.bottomAnchor, centerX: centerXAnchor, padding: UIEdgeInsets(top: yInset + (titleLabel.intrinsicContentSize.height*0.5), left: 0.0, bottom: 0.0, right: 0.0))
        
        addSubview(visibilityStackView)
        visibilityStackView.anchor(top: pageMarkerStackView.bottomAnchor, centerX: centerXAnchor, padding: UIEdgeInsets(top: yInset + (titleLabel.intrinsicContentSize.height*0.5), left: 0.0, bottom: 0.0, right: 0.0))
        
        /*addSubview(visibilityCountLabel)
        visibilityCountLabel.anchor(top: visibilityStackView.bottomAnchor, centerX: centerXAnchor, padding: UIEdgeInsets(top: xInset*0.8, left: 0.0, bottom: 0.0, right: 0.0))*/
        
        addSubview(nextButton)
        nextButton.anchor(top: visibilityStackView.bottomAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, centerX: centerXAnchor, padding: UIEdgeInsets(top: yInset + (titleLabel.intrinsicContentSize.height*0.5), left: 0.0, bottom: yInset + (titleLabel.intrinsicContentSize.height*0.5), right: 0.0))
        
    }
    
    @objc private func toggleVisibilityStackViews(sender: UISwitch) {
        
        if sender.isOn {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                
                self.privateVisibilityStackView.alpha = 0.7
                self.publicVisibilityStackView.alpha = 1.0
                
            }, completion: nil)
            
        } else {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                
                self.privateVisibilityStackView.alpha = 1.0
                self.publicVisibilityStackView.alpha = 0.7
                
            }, completion: nil)
            
        }
        
    }
    
}

final class CategoryViewCell : UICollectionViewCell {
    
    static let defaultReuseIdentifier: String = "categoryCell"
    
    private let cellVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 2)
    private let cellHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    lazy private(set) var containerStackView: UIStackView = {
        
        var containerStackView = UIStackView(arrangedSubviews: [popsicleIconImageView, categoryLabel, /*flavorLabel,*/ borderView, descriptionLabel])
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.distribution = .fill
        containerStackView.spacing = cellVerticalEdgeInset
        containerStackView.setCustomSpacing(cellVerticalEdgeInset*1.5, after: popsicleIconImageView)
        return containerStackView
        
    }()
    
    lazy private var borderView: PopsicleBorderView = {
        
        var borderView = PopsicleBorderView(with: .white, lineHeight: nil)
        return borderView
        
    }()
    
    lazy private(set) var popsicleIconImageView : UIImageView = {
        
        var popsicleIconImageView = UIImageView()
        popsicleIconImageView.contentMode = .scaleAspectFit
        return popsicleIconImageView
        
    }()
    
    lazy private(set) var categoryLabel: UILabel = {
        
        var categoryLabel = UILabel()
        categoryLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        categoryLabel.textColor = .white
        categoryLabel.text = "Event Category"
        categoryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        categoryLabel.numberOfLines = 0
        categoryLabel.textAlignment = .center
        return categoryLabel
        
    }()
    
    /*lazy private(set) var flavorLabel: UILabel = {
        
        var flavorLabel = UILabel()
        flavorLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        flavorLabel.textColor = .white
        flavorLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        flavorLabel.numberOfLines = 0
        flavorLabel.textAlignment = .center
        return flavorLabel
        
    }()*/
    
    lazy private(set) var descriptionLabel: UILabel = {
        
        var descriptionLabel = UILabel()
        descriptionLabel.font = .dynamicFont(with: "Octarine-Light", style: .callout)
        descriptionLabel.textColor = .white
        descriptionLabel.text = "Category Description"
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        return descriptionLabel
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureView()
        
    }
    
    private func configureView() {
    
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerStackView)
        popsicleIconImageView.anchor(bottom: contentView.centerYAnchor, width: contentView.widthAnchor, height: popsicleIconImageView.widthAnchor, multiples: CGSize(width: 0.33, height: 1.0))
        borderView.anchor(width: contentView.widthAnchor, multiples: CGSize(width: 0.33, height: 1.0))
    
    }
    
}

struct PreviewCreateEventFirstSectionView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = CreateEventFirstSectionView
    
}

struct TestPreviewCreateEventFirstSectionView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewCreateEventFirstSectionView
    
}
