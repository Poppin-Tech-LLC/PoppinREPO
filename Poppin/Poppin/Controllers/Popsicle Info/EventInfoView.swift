//
//  EventInfoView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/10/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit

struct PreviewEventInfoView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType(eventModel: EventModel(), isModallyPresented: true)
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = EventInfoView
    
}

struct TestPreviewEventInfoView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewEventInfoView
    
}

final class EventInfoView: UIView {
    
    let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var eventModel = EventModel()
    private var isModallyPresented: Bool = true
    private var firstTime: Bool = true
    
    lazy private var scrollIndicatorIconView: UIView = {
        
        var scrollIndicatorIconView = UIView()
        scrollIndicatorIconView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
        scrollIndicatorIconView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 4.0, maxSize: 6.0), shadowOpacity: 0.0, topRightMask: true, topLeftMask: true, bottomRightMask: true, bottomLeftMask: true)
        return scrollIndicatorIconView
        
    }()
    
    lazy private var cardView: UIView = {
        
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
        
        if !isModallyPresented {
            
            cardView.addSubview(backButton)
            backButton.anchor(leading: cardView.leadingAnchor, centerY: topTagView.centerYAnchor, padding: UIEdgeInsets(top: 0.0, left: xInset-(yInset*0.5), bottom: 0.0, right: 0.0))
            
        }
        
        if MapViewController.uid == eventModel.authorId {
            
            cardView.addSubview(editButton)
            editButton.anchor(bottom: cardView.bottomAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: yInset, right: 0.0))
            bottomFadeEdgeView.anchor(height: editButton.heightAnchor, constants: CGSize(width: 0.0, height: yInset*2))
            
        } else {
            
            cardView.addSubview(rsvpButton)
            rsvpButton.anchor(bottom: cardView.bottomAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: yInset, right: 0.0))
            bottomFadeEdgeView.anchor(height: rsvpButton.heightAnchor, constants: CGSize(width: 0.0, height: yInset*2))
            
        }
        
        return cardView
        
    }()
    
    lazy private(set) var topFadeEdgeView: FadeEdgeView = {
        
        var topFadeEdgeView = FadeEdgeView(color: (eventModel.category ?? EventCategory.Culture).getGradientColors()[0], top: true)
        return topFadeEdgeView
        
    }()
    
    lazy private(set) var bottomFadeEdgeView: FadeEdgeView = {
        
        var bottomFadeEdgeView = FadeEdgeView(color: (eventModel.category ?? EventCategory.Culture).getGradientColors()[0], top: false)
        return bottomFadeEdgeView
        
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
        cardScrollView.contentInsetAdjustmentBehavior = .never
        cardScrollView.alwaysBounceVertical = false
        cardScrollView.showsVerticalScrollIndicator = false
        
        if MapViewController.uid == eventModel.authorId {
            
            cardScrollView.contentInset = UIEdgeInsets(top: visibilityLabel.intrinsicContentSize.height + (yInset*3.0), left: 0.0, bottom: editButton.intrinsicContentSize.height + (yInset*2), right: 0.0)
            
        } else {
            
            cardScrollView.contentInset = UIEdgeInsets(top: visibilityLabel.intrinsicContentSize.height + (yInset*3.0), left: 0.0, bottom: rsvpButton.intrinsicContentSize.height + (yInset*2), right: 0.0)
            
        }
        
        cardScrollView.addSubview(containerView)
        containerView.anchor(top: cardScrollView.topAnchor, leading: cardScrollView.leadingAnchor, bottom: cardScrollView.bottomAnchor, trailing: cardScrollView.trailingAnchor, width: cardScrollView.widthAnchor)
        
        return cardScrollView
        
    }()
    
    lazy private var containerStackView: UIStackView = {
        
        var containerStackView: UIStackView
        containerStackView = UIStackView(arrangedSubviews: [titleTextView, popsicleBorderView, dateTextView, createdByView, locationContainerView, onlineURLContainerView, detailsTextView])
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = yInset*0.5
        containerStackView.setCustomSpacing(0.0, after: titleTextView)
        containerStackView.setCustomSpacing(0.0, after: popsicleBorderView)
        containerStackView.setCustomSpacing(yInset, after: createdByView)
        containerStackView.setCustomSpacing(yInset, after: locationContainerView)
        return containerStackView
        
    }()
    
    lazy private var popsicleBorderView: PopsicleBorderView = PopsicleBorderView(with: (eventModel.category ?? EventCategory.Culture).getGradientColors()[1], lineHeight: nil)
    
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
            
            titleTextView.text = "Title Unavailable"
            
        }
        
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
            
            dateTextView.text = "Date Unavailable"
            
        }
        
        dateTextView.textContainerInset = UIEdgeInsets(top: yInnerInset, left: xInnerInset, bottom: yInnerInset, right: xInnerInset)
        dateTextView.isScrollEnabled = false
        dateTextView.textAlignment = .center
        dateTextView.autocapitalizationType = .none
        dateTextView.autocorrectionType = .no
        return dateTextView
        
    }()
    
    lazy private(set) var createdByView: UIView = {
        
        var createdByView = UIView()
        createdByView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        createdByView.clipsToBounds = true
        createdByView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        
        createdByView.addSubview(createdByTextStackView)
        createdByTextStackView.anchor(top: createdByView.topAnchor, leading: createdByView.leadingAnchor, bottom: createdByView.bottomAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: 0.0))
        
        createdByView.addSubview(userImageView)
        userImageView.anchor(top: createdByView.topAnchor, bottom: createdByView.bottomAnchor, trailing: createdByView.trailingAnchor, width: userImageView.heightAnchor, padding: UIEdgeInsets(top: yInset, left: 0.0, bottom: yInset, right: xInset))
        
        return createdByView
        
    }()
    
    lazy private var createdByTextStackView: UIStackView = {
        
        var createdByStackView = UIStackView(arrangedSubviews: [createdByLabel, usernameLabel])
        createdByStackView.axis = .vertical
        createdByStackView.alignment = .fill
        createdByStackView.distribution = .fill
        createdByStackView.spacing = yInset*0.5
        return createdByStackView
        
    }()
    
    lazy private var createdByLabel: UILabel = {
        
        var createdByLabel = UILabel()
        createdByLabel.lineBreakMode = .byTruncatingTail
        createdByLabel.numberOfLines = 1
        createdByLabel.textAlignment = .left
        createdByLabel.text = "Created By:"
        createdByLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        createdByLabel.textColor = UIColor.white
        return createdByLabel
        
    }()
    
    lazy private(set) var usernameLabel: UILabel = {
        
        var usernameLabel = UILabel()
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.numberOfLines = 1
        usernameLabel.textAlignment = .left
        usernameLabel.text = "@username"
        usernameLabel.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        usernameLabel.textColor = UIColor.white
        return usernameLabel
        
    }()
    
    lazy private(set) var userImageView: BubbleImageView = {
        
        var userImageView = BubbleImageView(image: UIImage.defaultUserPicture64)
        return userImageView
        
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
        locationLabel.text = "Address Unavailable"
        
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
            
            detailsTextView.isHidden = true
            
        }
    
        detailsTextView.textContainerInset = UIEdgeInsets(top: yInnerInset, left: xInnerInset, bottom: yInnerInset, right: xInnerInset)
        detailsTextView.isScrollEnabled = false
        detailsTextView.textAlignment = .center
        detailsTextView.autocapitalizationType = .none
        detailsTextView.autocorrectionType = .no
        return detailsTextView
        
    }()
    
    lazy private var onlineURLContainerView: UIView = {
        
        let innerInset: CGFloat = yInset*0.33
        
        var onlineURLContainerView = UIView()
        onlineURLContainerView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        onlineURLContainerView.clipsToBounds = true
        onlineURLContainerView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        
        onlineURLContainerView.addSubview(onlineURLLabel)
        onlineURLLabel.anchor(top: onlineURLContainerView.topAnchor, leading: onlineURLContainerView.leadingAnchor, trailing: onlineURLContainerView.trailingAnchor, padding: UIEdgeInsets(top: innerInset, left: innerInset, bottom: 0.0, right: innerInset))
        
        onlineURLContainerView.addSubview(onlineURLTextView)
        onlineURLTextView.anchor(top: onlineURLLabel.bottomAnchor, leading: onlineURLLabel.leadingAnchor, bottom: onlineURLContainerView.bottomAnchor, trailing: onlineURLLabel.trailingAnchor, padding: UIEdgeInsets(top: innerInset, left: 0.0, bottom: innerInset, right: 0.0))
        
        if eventModel.onlineURL == nil { onlineURLContainerView.isHidden = true }
        
        return onlineURLContainerView
        
    }()
    
    lazy private(set) var onlineURLLabel: UILabel = {
        
        var onlineURLLabel = UILabel()
        onlineURLLabel.textAlignment = .center
        onlineURLLabel.backgroundColor = .clear
        onlineURLLabel.numberOfLines = 1
        onlineURLLabel.textColor = .white
        onlineURLLabel.text = "Online Event Link"
        onlineURLLabel.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        return onlineURLLabel
        
    }()
    
    lazy private(set) var onlineURLTextView : UITextView = {
        
        var onlineURLTextView = UITextView()
        onlineURLTextView.textColor = .white
        onlineURLTextView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
        onlineURLTextView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        
        if let onlineURL = eventModel.onlineURL {
            
            onlineURLTextView.text = onlineURL.absoluteString
            
        }
        
        onlineURLTextView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        onlineURLTextView.linkTextAttributes = [.foregroundColor: UIColor.white, .underlineStyle : NSUnderlineStyle.single.rawValue]
        onlineURLTextView.textAlignment = .center
        onlineURLTextView.isScrollEnabled = false
        onlineURLTextView.dataDetectorTypes = .link
        onlineURLTextView.isSelectable = true
        onlineURLTextView.isEditable = false
        onlineURLTextView.autocapitalizationType = .none
        onlineURLTextView.autocorrectionType = .no
        return onlineURLTextView
        
    }()
    
    lazy private(set) var rsvpButton: LoadingButton = {
        
        let innerInset: CGFloat = yInset*0.4
        
        var rsvpButton = LoadingButton(bgColor: nil, label: nil)
        rsvpButton.backgroundColor = .white
        rsvpButton.setTitle("RSVP", for: .normal)
        rsvpButton.titleLabel?.textAlignment = .center
        rsvpButton.setTitleColor((eventModel.category ?? EventCategory.Culture).getGradientColors()[1], for: .normal)
        rsvpButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        rsvpButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset*2, bottom: innerInset, right: innerInset*2)
        rsvpButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 14.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        return rsvpButton
        
    }()
    
    lazy private(set) var editButton: LoadingButton = {
        
        let innerInset: CGFloat = yInset*0.4
        
        var editButton = LoadingButton(bgColor: nil, label: nil)
        editButton.backgroundColor = .white
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.textAlignment = .center
        editButton.setTitleColor((eventModel.category ?? EventCategory.Culture).getGradientColors()[1], for: .normal)
        editButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        editButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset*2, bottom: innerInset, right: innerInset*2)
        editButton.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 14.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.2, shadowRadius: 8.0)
        return editButton
        
    }()
    
    lazy private(set) var backButton: BubbleButton = {
        
        let innerInset: CGFloat = yInset*0.5
        
        var backButton = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .title3).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
        backButton.contentEdgeInsets = UIEdgeInsets(top: innerInset, left: innerInset, bottom: innerInset, right: innerInset)
        backButton.backgroundColor = .clear
        return backButton
        
    }()
    
    init(eventModel: EventModel, isModallyPresented: Bool) {
        
        super.init(frame: .zero)
        
        self.eventModel = eventModel
        self.isModallyPresented = isModallyPresented
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        
    }
    
    private func configureView() {
     
        backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        if isModallyPresented {
            
            addSubview(scrollIndicatorIconView)
            scrollIndicatorIconView.anchor(centerX: centerXAnchor, width: widthAnchor, multiples: CGSize(width: 0.25, height: 1.0))
            
            addSubview(cardView)
            cardView.anchor(leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0.0, left: xInset, bottom: yInset, right: xInset))
            
        } else {
            
            addSubview(cardView)
            cardView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset))
            
        }
        
        locationMapView.anchor(height: heightAnchor, multiples: CGSize(width: 1.0, height: 0.15))
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if !firstTime { return }
        
        scrollIndicatorIconView.anchor(size: CGSize(width: 0.0, height: yInset*0.45))
        scrollIndicatorIconView.anchor(top: topAnchor, padding: UIEdgeInsets(top: yInset*0.6, left: 0.0, bottom: 0.0, right: 0.0))
        
        cardView.anchor(top: scrollIndicatorIconView.bottomAnchor, padding: UIEdgeInsets(top: yInset*0.6, left: 0.0, bottom: 0.0, right: 0.0))
        
        firstTime = false
        
    }
    
    func resetView(with model: EventModel) {
        
        eventModel = model
        
        backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        if isModallyPresented { scrollIndicatorIconView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0] }
        
        cardView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
        
        topFadeEdgeView.color = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
        
        bottomFadeEdgeView.color = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
        
        if MapViewController.uid == eventModel.authorId {
            
            rsvpButton.removeFromSuperview()
            
            cardView.addSubview(editButton)
            editButton.anchor(bottom: cardView.bottomAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: yInset, right: 0.0))
            bottomFadeEdgeView.anchor(height: editButton.heightAnchor, constants: CGSize(width: 0.0, height: yInset*2))
            
        } else {
            
            editButton.removeFromSuperview()
            
            cardView.addSubview(rsvpButton)
            rsvpButton.anchor(bottom: cardView.bottomAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: yInset, right: 0.0))
            bottomFadeEdgeView.anchor(height: rsvpButton.heightAnchor, constants: CGSize(width: 0.0, height: yInset*2))
            
        }
        
        topTagView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        if eventModel.isPublic {
            
            visibilityIconImageView.image = UIImage(systemSymbol: .globe).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            visibilityLabel.text = "Public"
            
        } else {
            
            visibilityIconImageView.image = UIImage(systemSymbol: .lockFill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            visibilityLabel.text = "Private"
            
        }
        
        if eventModel.onlineURL == nil {
            
            formatIconImageView.image = UIImage(systemSymbol: .person3Fill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            formatLabel.text = "Live"
            
        } else {
            
            formatIconImageView.image = UIImage(systemSymbol: .personCropRectangle).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            formatLabel.text = "Online"
            
        }
        
        if MapViewController.uid == eventModel.authorId {
            
            cardScrollView.contentInset = UIEdgeInsets(top: visibilityLabel.intrinsicContentSize.height + (yInset*3.0), left: 0.0, bottom: editButton.intrinsicContentSize.height + (yInset*2), right: 0.0)
            
        } else {
            
            cardScrollView.contentInset = UIEdgeInsets(top: visibilityLabel.intrinsicContentSize.height + (yInset*3.0), left: 0.0, bottom: rsvpButton.intrinsicContentSize.height + (yInset*2), right: 0.0)
            
        }
        
        popsicleBorderView.borderColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        if let title = eventModel.title {
            
            titleTextView.text = title
            
        } else {
            
            titleTextView.text = "Title Unavailable"
            
        }
        
        if let startDate = eventModel.startDate, let endDate = eventModel.endDate, let formattedDate = Date.getFormattedDateInterval(start: startDate, end: endDate) {
            
            dateTextView.text = formattedDate
            
        } else {
            
            dateTextView.text = "Date Unavailable"
            
        }
        
        createdByView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        locationContainerView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
        
        if let location = eventModel.location {
            
            location.lookUpLocationAddress { [weak self] (address) in
                
                guard let self = self else { return }
                
                if let address = address {
                    
                    self.locationLabel.text = address
                    
                } else {
                    
                    self.locationLabel.text = "Address Unavailable"
                    
                }
                
            }
            
        } else {
            
            locationLabel.text = "Address Unavailable"
            
        }
        
        if let details = eventModel.details {
            
            detailsTextView.text = details
            detailsTextView.isHidden = false
            
        } else {
            
            detailsTextView.text = ""
            detailsTextView.isHidden = true
            
        }
        
        if let onlineURL = eventModel.onlineURL {
            
            onlineURLContainerView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[1]
            onlineURLTextView.backgroundColor = (eventModel.category ?? EventCategory.Culture).getGradientColors()[0]
            
            onlineURLTextView.text = onlineURL.absoluteString
            onlineURLContainerView.isHidden = false
            
        } else {
            
            onlineURLTextView.text = ""
            onlineURLContainerView.isHidden = true
            
        }
        
    }
    
}
