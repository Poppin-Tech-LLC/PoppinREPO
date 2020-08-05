//
//  CreateEventSecondSectionView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/30/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit

struct PreviewCreateEventSecondSectionView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType(eventModel: EventModel())
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = CreateEventSecondSectionView
    
}

struct TestPreviewCreateEventSecondSectionView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewCreateEventSecondSectionView
    
}

final class CreateEventSecondSectionView: UIView {
    
    let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var eventModel = EventModel()
    
    lazy private var cardView: UIView = {
        
        let topFadeEdgeView = FadeEdgeView(color: (eventModel.category ?? EventCategory.Culture).getGradientColors()[0], top: true)
        let bottomFadeEdgeView = FadeEdgeView(color: (eventModel.category ?? EventCategory.Culture).getGradientColors()[0], top: false)
        
        var cardView = UIView()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        cardView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
        
        cardView.addSubview(cardScrollView)
        cardScrollView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: -yInset*1.5, left: xInset, bottom: 0.0, right: xInset))
        
        cardView.addSubview(topFadeEdgeView)
        topFadeEdgeView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor)
        
        cardView.addSubview(bottomFadeEdgeView)
        bottomFadeEdgeView.anchor(leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor)
        
        cardView.addSubview(topTagView)
        topTagView.anchor(top: cardView.topAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: yInset, left: 0.0, bottom: 0.0, right: 0.0))
        topFadeEdgeView.anchor(height: topTagView.heightAnchor, constants: CGSize(width: 0.0, height: yInset*2))
        
        cardView.addSubview(backButton)
        backButton.anchor(leading: cardView.leadingAnchor, centerY: topTagView.centerYAnchor, padding: UIEdgeInsets(top: 0.0, left: xInset-(yInset*0.5), bottom: 0.0, right: 0.0))
        
        cardView.addSubview(createButton)
        createButton.anchor(bottom: cardView.bottomAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: yInset, right: 0.0))
        bottomFadeEdgeView.anchor(height: createButton.heightAnchor, constants: CGSize(width: 0.0, height: yInset*2))
        
        return cardView
        
    }()
    
    lazy private var topTagView: UIView = {
        
        let xInnerInset = xInset*0.6
        let yInnerInset = yInset*0.5
        
        let visibilityStackView: UIStackView = UIStackView(arrangedSubviews: [visibilityIconImageView, visibilityLabel])
        visibilityStackView.alignment = .center
        visibilityStackView.axis = .horizontal
        visibilityStackView.distribution = .fill
        visibilityStackView.spacing = xInnerInset*0.5
        
        let separatorView = UIView()
        separatorView.backgroundColor = .white
        separatorView.anchor(size: CGSize(width: 2.0, height: 0.0))
        
        let formatStackView: UIStackView = UIStackView(arrangedSubviews: [formatIconImageView, formatLabel])
        formatStackView.alignment = .fill
        formatStackView.axis = .horizontal
        formatStackView.distribution = .fill
        formatStackView.spacing = xInnerInset*0.5
        
        let visibilityAndFormatStackView = UIStackView(arrangedSubviews: [visibilityStackView, separatorView, formatStackView])
        visibilityAndFormatStackView.axis = .horizontal
        visibilityAndFormatStackView.alignment = .fill
        visibilityAndFormatStackView.distribution = .fill
        visibilityAndFormatStackView.spacing = xInnerInset
        
        var topTagView = UIView()
        topTagView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        topTagView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 14.0), shadowOpacity: 0.0, topRightMask: true, topLeftMask: true, bottomRightMask: true, bottomLeftMask: true)
        
        topTagView.addSubview(visibilityAndFormatStackView)
        visibilityAndFormatStackView.anchor(top: topTagView.topAnchor, leading: topTagView.leadingAnchor, bottom: topTagView.bottomAnchor, trailing: topTagView.trailingAnchor, padding: UIEdgeInsets(top: yInnerInset, left: xInnerInset, bottom: yInnerInset, right: xInnerInset*1.1))
        
        return topTagView
        
    }()
    
    lazy private(set) var visibilityIconImageView: UIImageView = {
        
        let visibilityIcon: UIImage
        
        if eventModel.isPublic {
            
            visibilityIcon = UIImage(systemSymbol: .globe).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            
        } else {
            
            visibilityIcon = UIImage(systemSymbol: .lockFill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            
        }
        
        var visibilityIconImageView: UIImageView = UIImageView(image: visibilityIcon)
        visibilityIconImageView.contentMode = .scaleAspectFit
        visibilityIconImageView.anchor(size: CGSize(width: 0.0, height: visibilityLabel.intrinsicContentSize.height))
        return visibilityIconImageView
        
    }()
    
    lazy private(set) var visibilityLabel: UILabel = {
        
        var visibilityLabel: UILabel = UILabel()
        
        if eventModel.isPublic {
            
            visibilityLabel.text = "Public"
            
        } else {
            
            visibilityLabel.text = "Private"
            
        }
        
        visibilityLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption1)
        visibilityLabel.numberOfLines = 1
        visibilityLabel.textAlignment = .center
        visibilityLabel.textColor = .white
        return visibilityLabel
        
    }()
    
    lazy private(set) var formatIconImageView: UIImageView = {
        
        let formatIcon: UIImage
        
        if eventModel.onlineURL == nil {
            
            formatIcon = UIImage(systemSymbol: .person3Fill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            
        } else {
            
            formatIcon = UIImage(systemSymbol: .personCropRectangle).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            
        }
        
        var formatIconImageView: UIImageView = UIImageView(image: formatIcon)
        formatIconImageView.contentMode = .scaleAspectFit
        formatIconImageView.anchor(size: CGSize(width: 0.0, height: formatLabel.intrinsicContentSize.height))
        return formatIconImageView
        
    }()
    
    lazy private(set) var formatLabel: UILabel = {
        
        let formatLabel: UILabel = UILabel()
        
        if eventModel.onlineURL == nil {
            
            formatLabel.text = "Live"
            
        } else {
            
            formatLabel.text = "Online"
            
        }
        
        formatLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption1)
        formatLabel.numberOfLines = 1
        formatLabel.textAlignment = .center
        formatLabel.textColor = .white
        return formatLabel
        
    }()
    
    lazy private(set) var cardScrollView: UIScrollView = {
        
        let topSpacingView = UIView()
        topSpacingView.backgroundColor = .clear
        topSpacingView.anchor(size: CGSize(width: 0.0, height: yInset))
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        containerView.addSubview(topSpacingView)
        topSpacingView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor)
        
        containerView.addSubview(containerStackView)
        containerStackView.anchor(top: topSpacingView.bottomAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor)
        
        var cardScrollView = UIScrollView()
        cardScrollView.alwaysBounceVertical = false
        cardScrollView.showsVerticalScrollIndicator = false
        cardScrollView.contentInset = UIEdgeInsets(top: visibilityLabel.intrinsicContentSize.height + (yInset*3.0), left: 0.0, bottom: createButton.intrinsicContentSize.height + (yInset*2), right: 0.0)
        
        cardScrollView.addSubview(containerView)
        containerView.anchor(top: cardScrollView.topAnchor, leading: cardScrollView.leadingAnchor, bottom: cardScrollView.bottomAnchor, trailing: cardScrollView.trailingAnchor, width: cardScrollView.widthAnchor)
        
        return cardScrollView
        
    }()
    
    lazy private var containerStackView: UIStackView = {
        
        let editLocationButtonContainerView = UIView()
        editLocationButtonContainerView.backgroundColor = .clear
        editLocationButtonContainerView.addSubview(editLocationButton)
        editLocationButton.anchor(top: editLocationButtonContainerView.topAnchor, bottom: editLocationButtonContainerView.bottomAnchor, centerX: editLocationButtonContainerView.centerXAnchor)
        
        var containerStackView = UIStackView(arrangedSubviews: [titleTextView, popsicleBorderView, dateTextView, locationContainerView, editLocationButtonContainerView, detailsTextView, onlineURLTextView, onlineEventHelpTextView])
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = yInset*0.5
        containerStackView.setCustomSpacing(0.0, after: locationContainerView)
        containerStackView.setCustomSpacing(0.0, after: titleTextView)
        containerStackView.setCustomSpacing(0.0, after: popsicleBorderView)
        containerStackView.setCustomSpacing(yInset*0.6, after: onlineURLTextView)
        return containerStackView
        
    }()
    
    lazy private var popsicleBorderView: PopsicleBorderView = PopsicleBorderView(with: (eventModel.category ?? EventCategory.Culture).getGradientColors()[1], lineHeight: nil)
    
    lazy private(set) var characterCountView: UIView = {
        
        var characterCountView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: .getPercentageWidth(percentage: 100), height: characterCountLabel.intrinsicContentSize.height + (yInset*1.5)))
        characterCountView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
        
        let borderView = UIView()
        borderView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        characterCountView.addSubview(borderView)
        borderView.anchor(top: characterCountView.topAnchor, leading: characterCountView.leadingAnchor, trailing: characterCountView.trailingAnchor, size: CGSize(width: 0.0, height: 2.0))
        
        characterCountView.addSubview(characterCountLabel)
        characterCountLabel.anchor(leading: characterCountView.leadingAnchor, centerY: characterCountView.centerYAnchor, padding: UIEdgeInsets(top: 0.0, left: xInset*1.1, bottom: 0.0, right: 0.0))
        
        characterCountView.addSubview(doneButton)
        doneButton.anchor(trailing: characterCountView.trailingAnchor, centerY: characterCountView.centerYAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: xInset*1.1))
        
        characterCountView.addSubview(inputTypeLabel)
        inputTypeLabel.anchor(centerX: characterCountView.centerXAnchor, centerY: characterCountView.centerYAnchor)

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
    
    lazy private(set) var inputTypeLabel: UILabel = {
        
        var inputTypeLabel = UILabel()
        inputTypeLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        inputTypeLabel.text = "Title"
        inputTypeLabel.textColor = .white
        inputTypeLabel.numberOfLines = 1
        inputTypeLabel.textAlignment = .center
        return inputTypeLabel
        
    }()
    
    lazy private(set) var doneButton: BouncyButton = {
        
        var doneButton = BouncyButton(bouncyButtonImage: nil)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        doneButton.setTitleColor(.white, for: .normal)
        return doneButton
        
    }()
    
    lazy private(set) var titleTextView: UITextView = {
        
        let yInnerInset = yInset*0.5
        let xInnerInset = xInset*0.5
        
        var titleTextView = UITextView()
        titleTextView.backgroundColor = .clear
        titleTextView.textColor = .white
        titleTextView.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        
        if let title = eventModel.title {
            
            titleTextView.text = title
            
        } else {
            
            titleTextView.text = "Add Title"
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let fullString = NSMutableAttributedString(string: titleTextView.text + " ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline), .foregroundColor: UIColor.white])
            fullString.append(NSAttributedString(attachment: imageAttachment))
            
            titleTextView.attributedText = fullString
            
        }
        
        titleTextView.inputAccessoryView = characterCountView
        titleTextView.returnKeyType = .done
        titleTextView.textContainerInset = UIEdgeInsets(top: yInnerInset, left: xInnerInset, bottom: yInnerInset, right: xInnerInset)
        titleTextView.isScrollEnabled = false
        titleTextView.textAlignment = .center
        titleTextView.autocapitalizationType = .none
        titleTextView.autocorrectionType = .no
        
        return titleTextView
        
    }()
    
    lazy private(set) var dateTextView: UITextView = {
        
        let yInnerInset = yInset*0.5
        let xInnerInset = xInset*0.5
        
        var dateTextView = UITextView()
        dateTextView.font = UIFont.dynamicFont(with: "Octarine-Light", style: .callout)
        dateTextView.backgroundColor = .clear
        dateTextView.textColor = .white
        dateTextView.textAlignment = .center
        
        if let startDate = eventModel.startDate, let endDate = eventModel.endDate, let formattedDate = Date.getFormattedDateInterval(start: startDate, end: endDate) {
            
            dateTextView.text = formattedDate
            
        } else {
            
            dateTextView.text = "Add Date"
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Light", style: .callout).pointSize, weight: .regular)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let fullString = NSMutableAttributedString(string: dateTextView.text + " ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Light", style: .callout), .foregroundColor: UIColor.white])
            fullString.append(NSAttributedString(attachment: imageAttachment))
            
            dateTextView.attributedText = fullString
            
        }
        
        dateTextView.textContainerInset = UIEdgeInsets(top: yInnerInset, left: xInnerInset, bottom: yInnerInset, right: xInnerInset)
        dateTextView.isScrollEnabled = false
        dateTextView.textAlignment = .center
        dateTextView.autocapitalizationType = .none
        dateTextView.autocorrectionType = .no
        return dateTextView
        
    }()
    
    lazy private var locationContainerView: UIView = {
        
        let innerInset: CGFloat = yInset*0.33
        
        var locationContainerView = UIView()
        locationContainerView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        locationContainerView.clipsToBounds = true
        locationContainerView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        
        locationContainerView.addSubview(locationLabel)
        locationLabel.anchor(top: locationContainerView.topAnchor, leading: locationContainerView.leadingAnchor, trailing: locationContainerView.trailingAnchor, padding: UIEdgeInsets(top: innerInset, left: innerInset, bottom: 0.0, right: innerInset))
        
        locationContainerView.addSubview(locationMapView)
        locationMapView.anchor(top: locationLabel.bottomAnchor, leading: locationLabel.leadingAnchor, bottom: locationContainerView.bottomAnchor, trailing: locationLabel.trailingAnchor, padding: UIEdgeInsets(top: innerInset, left: 0.0, bottom: innerInset, right: 0.0))
        
        return locationContainerView
        
    }()
    
    lazy private(set) var locationLabel: UILabel = {
        
        var locationLabel = UILabel()
        locationLabel.textAlignment = .center
        locationLabel.backgroundColor = .clear
        locationLabel.numberOfLines = 1
        locationLabel.textColor = .white
        locationLabel.text = "Location"
        
        if let location = eventModel.location {
            
            location.lookUpLocationAddress { (address) in
                
                if let address = address {
                    
                    locationLabel.text = address
                    
                } else {
                    
                    locationLabel.text = "Address Unavailable"
                    
                }
                
            }
            
        }
        
        locationLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        return locationLabel
        
    }()
    
    lazy private(set) var locationMapView: MKMapView = {
        
        var locationMapView = MKMapView()
        locationMapView.isPitchEnabled = false
        locationMapView.isRotateEnabled = false
        locationMapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 0, maxCenterCoordinateDistance: MapViewController.defaultMapViewRegionRadius)
        locationMapView.showsUserLocation = false
        locationMapView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        locationMapView.layer.masksToBounds = true
        return locationMapView
        
    }()
    
    lazy private(set) var editLocationButton: UIButton = {
        
        let innerInset: CGFloat = yInset*0.33
        
        var editLocationButton = UIButton(type: .system)
        
        if let location = eventModel.location {
            
            editLocationButton.setTitle("Edit", for: .normal)
            
        } else {
            
            editLocationButton.setTitle("Add", for: .normal)
            
        }
        
        editLocationButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        editLocationButton.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        editLocationButton.setTitleColor(.white, for: .normal)
        editLocationButton.titleLabel?.textAlignment = .center
        editLocationButton.contentEdgeInsets = UIEdgeInsets(top: innerInset*0.5, left: innerInset*2.5, bottom: innerInset, right: innerInset*2.5)
        editLocationButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        return editLocationButton
        
    }()
    
    lazy private(set) var detailsTextView: UITextView = {
        
        let yInnerInset = yInset*0.5
        let xInnerInset = xInset*0.5
        
        var detailsTextView = UITextView()
        detailsTextView.backgroundColor = .clear
        detailsTextView.textColor = .white
        detailsTextView.font = .dynamicFont(with: "Octarine-Light", style: .headline)
        
        if let details = eventModel.details {
            
            detailsTextView.text = details
            
        } else {
            
            detailsTextView.text = "Add Details"
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Light", style: .headline).pointSize, weight: .regular)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let fullString = NSMutableAttributedString(string: detailsTextView.text + " ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Light", style: .headline), .foregroundColor: UIColor.white])
            fullString.append(NSAttributedString(attachment: imageAttachment))
            
            detailsTextView.attributedText = fullString
            
        }
    
        detailsTextView.inputAccessoryView = characterCountView
        detailsTextView.textContainerInset = UIEdgeInsets(top: yInnerInset, left: xInnerInset, bottom: yInnerInset, right: xInnerInset)
        detailsTextView.isScrollEnabled = false
        detailsTextView.textAlignment = .center
        detailsTextView.autocapitalizationType = .none
        detailsTextView.autocorrectionType = .no
        return detailsTextView
        
    }()
    
    lazy private(set) var onlineURLTextView : UITextView = {
        
        var onlineURLTextView = UITextView()
        onlineURLTextView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        onlineURLTextView.textColor = .white
        onlineURLTextView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        
        if let onlineURL = eventModel.onlineURL {
            
            onlineURLTextView.text = "Online Event Link: \n" + onlineURL.absoluteString
            
        } else {
            
            onlineURLTextView.text = "Add Online Event Link *"
            
        }
        
        onlineURLTextView.textAlignment = .center
        onlineURLTextView.layer.cornerRadius = .getWidthFitSize(minSize: 12.0, maxSize: 14.0)
        onlineURLTextView.isScrollEnabled = false
        onlineURLTextView.autocapitalizationType = .none
        onlineURLTextView.autocorrectionType = .no
        return onlineURLTextView
        
    }()
    
    lazy private var onlineEventHelpTextView : UITextView = {
        
        var onlineEventHelpTextView = UITextView()
        onlineEventHelpTextView.backgroundColor = .clear
        onlineEventHelpTextView.textColor = .white
        onlineEventHelpTextView.font = .dynamicFont(with: "Octarine-Light", style: .footnote)
        onlineEventHelpTextView.text = "* Your event can take place online by adding a link. The physical location you enter will only be informative and help people find your event."
        onlineEventHelpTextView.isScrollEnabled = false
        onlineEventHelpTextView.isUserInteractionEnabled = false
        onlineEventHelpTextView.autocapitalizationType = .none
        onlineEventHelpTextView.autocorrectionType = .no
        onlineEventHelpTextView.textContainerInset = UIEdgeInsets(top: 0.0, left: xInset*0.1, bottom: 0.0, right: xInset*0.1)
        return onlineEventHelpTextView
        
    }()
    
    lazy private(set) var createButton: LoadingButton = {
        
        let innerInset: CGFloat = yInset*0.4
        
        var createButton = LoadingButton(loadingIndicatorColor: (eventModel.category ?? EventCategory.Culture).getGradientColors()[1])
        createButton.backgroundColor = .white
        createButton.setTitle("Create", for: .normal)
        createButton.titleLabel?.textAlignment = .center
        createButton.setTitleColor((eventModel.category ?? EventCategory.Culture).getGradientColors()[1], for: .normal)
        createButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        createButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset*2, bottom: innerInset, right: innerInset*2)
        createButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 14.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        
        if eventModel.title != nil && eventModel.startDate != nil && eventModel.endDate != nil && eventModel.location != nil {
            
            createButton.isUserInteractionEnabled = true
            createButton.alpha = 1.0
            
        } else {
            
            createButton.isUserInteractionEnabled = false
            createButton.alpha = 0.6
            
        }
        
        return createButton
        
    }()
    
    lazy private(set) var backButton: BubbleButton = {
        
        let innerInset: CGFloat = yInset*0.5
        
        var backButton = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .title3).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
        backButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset, bottom: innerInset, right: innerInset)
        backButton.backgroundColor = .clear
        return backButton
        
    }()
    
    init(eventModel: EventModel) {
        
        super.init(frame: .zero)
        
        self.eventModel = eventModel
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
     
        backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        addSubview(cardView)
        cardView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset))
        
        locationMapView.anchor(height: heightAnchor, multiples: CGSize(width: 1.0, height: 0.15))
        
    }
    
}

final class FadeEdgeView: UIView {
    
    private var color: UIColor = .white
    private var top: Bool = true
    
    init(color: UIColor, top: Bool) {
        
        super.init(frame: .zero)
        
        self.color = color
        self.top = top
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        
        let l = CAGradientLayer()
        
        if top {
            
            l.startPoint = CGPoint(x: 0.5, y: 0.6)
            l.endPoint = CGPoint(x: 0.5, y: 1)
            l.colors = [
                color.withAlphaComponent(1),
                color.withAlphaComponent(0),
            ].map{$0.cgColor}
            
        } else {
            
            l.startPoint = CGPoint(x: 0.5, y: 0.0)
            l.endPoint = CGPoint(x: 0.5, y: 0.4)
            l.colors = [
                color.withAlphaComponent(0),
                color.withAlphaComponent(1),
            ].map{$0.cgColor}
            
        }
        
        layer.addSublayer(l)
        return l
        
    }()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
    }
    
}
