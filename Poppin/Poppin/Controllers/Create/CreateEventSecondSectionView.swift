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

/// Second Section of the Create Event Page (Title, Date, Location, Online Link, and Details) UI.
final class CreateEventSecondSectionView: UIView {
    
    /// Event annotation representing the current selected location.
    lazy private(set) var eventAnnotation = EventAnnotation(id: nil, location: MapViewController.defaultMapViewCenterLocation, category: EventCategory.allCases[0])
    
    // Card container.
    lazy private var cardView: CardView = {
        
        let cardView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0], padding: UIEdgeInsets(top: 0.0, left: .width(percent: 8.0), bottom: .width(percent: 3.0), right: .width(percent: 9.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [contentStack, navigationBar, createButton].map { cardView.addSubview($0) }
        
        // 2. Apply constraints.
        navigationBar.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor)
        
        contentStack.anchor(top: navigationBar.bottomAnchor, leading: cardView.layoutMarginsGuide.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.layoutMarginsGuide.trailingAnchor)
        
        createButton.anchor(bottom: cardView.layoutMarginsGuide.bottomAnchor, centerX: cardView.centerXAnchor)
        
        return cardView
        
    }()
    
    /// Top bar containing the back button and a tag with the event type and visibility.
    lazy private var navigationBar: CardView = {
        
        let navigationBar = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0], padding: .zero, cornerRadius: 0.0, shadow: Shadow(color: EventCategory.allCases[0].getGradientColors()[1].withAlphaComponent(0.6), radius: 4.0, x: 0.0, y: 1.0))
        navigationBar.layer.shadowOpacity = 0.0
        
        navigationBar.addSubview(backButton)
        backButton.anchor(top: navigationBar.topAnchor, leading: navigationBar.leadingAnchor, bottom: navigationBar.bottomAnchor)
        
        navigationBar.addSubview(topTag)
        topTag.anchor(top: backButton.topAnchor, bottom: backButton.bottomAnchor, centerX: navigationBar.centerXAnchor, padding: UIEdgeInsets(top: backButton.padding.top, left: 0.0, bottom: backButton.padding.bottom, right: 0.0))
        
        return navigationBar
        
    }()
    
    /// Button that transitions to the previous section of the create event.
    lazy private(set) var backButton: OctarineButton = {
        
        let backButton = OctarineButton(bgColor: .clear, label: nil, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)))
        backButton.setImage(UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        return backButton
        
    }()
    
    // Tag that specifies whether the event is public/private and live/online.
    lazy private var topTag: CardView = {
        
        let visibilityStack = StackView(subviews: [visibilityIcon, visibilityLabel], axis: .horizontal, alignment: .center, distribution: .fill, spacing: .width(percent: 2.0), padding: .zero)
        
        let separator = CardView(bgColor: .white, padding: .zero, cornerRadius: 1.0)
        separator.anchor(size: CGSize(width: 2.0, height: 0.0))
        
        let formatStack = StackView(subviews: [formatIcon, formatLabel], axis: .horizontal, alignment: .center, distribution: .fill, spacing: .width(percent: 2.0), padding: .zero)
        
        let contentStack = StackView(subviews: [visibilityStack, separator, formatStack], axis: .horizontal, alignment: .fill, distribution: .fill, spacing: .width(percent: 3.0), padding: .zero)
        
        let topTag = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[1], padding: UIEdgeInsets(top: .width(percent: 1.5), left: .width(percent: 2.5), bottom: .width(percent: 1.5), right: .width(percent: 2.5)), cornerRadius: .width(percent: 3))
        
        topTag.addSubview(contentStack)
        contentStack.anchor(top: topTag.layoutMarginsGuide.topAnchor, leading: topTag.layoutMarginsGuide.leadingAnchor, bottom: topTag.layoutMarginsGuide.bottomAnchor, trailing: topTag.layoutMarginsGuide.trailingAnchor)
        return topTag
        
    }()
    
    /// Symbol representing whether the event is public (globe) or private (lock).
    lazy private(set) var visibilityIcon = UIImageView(image: UIImage(systemSymbol: .globe, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
    
    /// Public or private.
    lazy private(set) var visibilityLabel = OctarineLabel(text: "Public", color: .white, bold: true, style: .caption1, alignment: .center, lineLimit: 1)
    
    /// Symbol representing whether the event is live (people) or online (screen).
    lazy private(set) var formatIcon = UIImageView(image: UIImage(systemSymbol: .person3Fill, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
    
    /// Live or online.
    lazy private(set) var formatLabel = OctarineLabel(text: "Live", color: .white, bold: true, style: .caption1, alignment: .center, lineLimit: 1)
    
    // Content scrollable stack.
    lazy private(set) var contentStack: ScrollableStackView = {
        
        let contentStack = ScrollableStackView(stackView: StackView(subviews: [titleButton, popsicleBorder, dateButton, locationContainer, locationButtonContainer, onlineURLContainer, onlineURLButtonContainer, detailsButton], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 4.0), padding: .zero), padding: UIEdgeInsets(top: .width(percent: 1.0), left: 0.0, bottom: createButton.intrinsicContentSize.height*1.5, right: 0.0))
        contentStack.delegate = self
        contentStack.stackView.setCustomSpacing(.width(percent: 1.0), after: titleButton)
        contentStack.stackView.setCustomSpacing(.width(percent: 1.0), after: popsicleBorder)
        contentStack.stackView.setCustomSpacing(0.0, after: locationContainer)
        contentStack.stackView.setCustomSpacing(.width(percent: 6.0), after: locationButtonContainer)
        contentStack.stackView.setCustomSpacing(0.0, after: onlineURLContainer)
        return contentStack
        
    }()
    
    /// Displays the title of the event and when pressed, transitions to another page for edition. By default, the button shows a placeholder icon and label.
    lazy private(set) var titleButton: OctarineButton = {
        
        let pencil = NSTextAttachment()
        pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

        let placeholderTitle = NSMutableAttributedString(string: "Add Title ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline), .foregroundColor: UIColor.white])
        placeholderTitle.append(NSAttributedString(attachment: pencil))
        
        let titleButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[0], label: OctarineLabel(color: .white, bold: true, style: .headline, alignment: .center, lineLimit: 0), padding: UIEdgeInsets(top: .width(percent: 1.5), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 2.0))
        titleButton.setAttributedTitle(placeholderTitle, for: .normal)
        return titleButton
        
    }()
    
    // Separates the title and description labels.
    lazy private var popsicleBorder = PopsicleBorderView(with: EventCategory.allCases[0].getGradientColors()[1], .headline)
    
    /// Displays the start and end date of the event in a formatted fashion and when pressed, transitions to another page for edition. By default, the button shows a placeholder icon and label.
    lazy private(set) var dateButton: OctarineButton = {
        
        let pencil = NSTextAttachment()
        pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Light", style: .callout).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

        let placeholderTitle = NSMutableAttributedString(string: "Add Date ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Light", style: .callout), .foregroundColor: UIColor.white])
        placeholderTitle.append(NSAttributedString(attachment: pencil))
        
        let dateButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[0], label: OctarineLabel(color: .white, bold: false, style: .callout, alignment: .center, lineLimit: 0), padding: UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 2.0))
        dateButton.setAttributedTitle(placeholderTitle, for: .normal)
        return dateButton
        
    }()
    
    // Container holding the event address label and a map.
    lazy private var locationContainer: CardView = {
        
        let contentStack = StackView(subviews: [locationLabel, locationMapView], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 1.5), padding: NSDirectionalEdgeInsets(top: .width(percent: 1.5), leading: .width(percent: 1.5), bottom: .width(percent: 1.5), trailing: .width(percent: 1.5)))
        
        let locationContainer = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[1], cornerRadius: .width(percent: 4.0))
        
        // 1. Add subviews.
        _ = [contentStack].map { locationContainer.addSubview($0) }
        
        // 2. Apply constraints.
        contentStack.attatchEdgesToSuperview()
        return locationContainer
        
    }()
    
    /// Displays the location address of the event. By default, it shows placeholder text.
    lazy private(set) var locationLabel = OctarineLabel(text: "Location", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1)
    
    /// Map showing the location of the event (marked with a popsicle annotation). Defaults to the middle of campus.
    lazy private(set) var locationMapView: MapView = {
        
        let locationMapView = MapView(center: MapViewController.defaultMapViewCenterLocation, radius: 200.0, showsUserLocation: false, tapAction: nil)
        locationMapView.addShadowAndRoundCorners(cornerRadius: .width(percent: 3.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        locationMapView.layer.masksToBounds = true
        return locationMapView
        
    }()
    
    // Container for the location button (allows custom width for the button).
    lazy private var locationButtonContainer: UIView = {
        
        let locationButtonContainer = UIView()
        locationButtonContainer.backgroundColor = .clear
        locationButtonContainer.addSubview(locationButton)
        locationButton.anchor(top: locationButtonContainer.topAnchor, bottom: locationButtonContainer.bottomAnchor, centerX: locationButtonContainer.centerXAnchor)
        return locationButtonContainer
        
    }()
    
    /// When pressed, transitions to another page for edition. By default, the button shows a placeholder icon and label.
    lazy private(set) var locationButton: OctarineButton = {
        
        let pencil = NSTextAttachment()
        pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

        let placeholderTitle = NSMutableAttributedString(string: "Add ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline), .foregroundColor: UIColor.white])
        placeholderTitle.append(NSAttributedString(attachment: pencil))
        
        let locationButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[1], label: OctarineLabel(color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 1.5), left: .width(percent: 3.0), bottom: .width(percent: 1.5), right: .width(percent: 3.0)))
        locationButton.shouldBounce = false
        locationButton.setAttributedTitle(placeholderTitle, for: .normal)
        locationButton.addShadowAndRoundCorners(cornerRadius: .width(percent: 3.5), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        return locationButton
        
    }()
    
    // Container holding the event online URL.
    lazy private var onlineURLContainer: CardView = {
        
        let contentStack = StackView(subviews: [onlineURLLabel, onlineURLTextView], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 1.5), padding: NSDirectionalEdgeInsets(top: .width(percent: 1.5), leading: .width(percent: 1.5), bottom: .width(percent: 1.5), trailing: .width(percent: 1.5)))
        
        let onlineURLContainer = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[1], cornerRadius: .width(percent: 4.0))
        
        // 1. Add subviews.
        _ = [contentStack].map { onlineURLContainer.addSubview($0) }
        
        // 2. Apply constraints.
        contentStack.attatchEdgesToSuperview()
        
        return onlineURLContainer
        
    }()
    
    // Title of the online URL container.
    lazy private var onlineURLLabel = OctarineLabel(text: "Online Event Link", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1)
    
    /// Displays the online URL of the event (if any). When pressed, it opens the link on a safari page. By defaults, it shows a disclaimer message explaining the purpose of the link.
    lazy private(set) var onlineURLTextView: UITextView = {
        
        let onlineURLTextView = UITextView()
        onlineURLTextView.textColor = .white
        onlineURLTextView.backgroundColor = EventCategory.allCases[0].getGradientColors()[0]
        onlineURLTextView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        onlineURLTextView.text = "Your event can take place online by adding a link. The physical location you enter will only be informative and help people find your event."
        onlineURLTextView.addShadowAndRoundCorners(cornerRadius: .width(percent: 4.0), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
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
    
    // Container for the location button (allows custom width for the button).
    lazy private var onlineURLButtonContainer: UIView = {
        
        let onlineURLButtonContainer = UIView()
        onlineURLButtonContainer.backgroundColor = .clear
        onlineURLButtonContainer.addSubview(onlineURLButton)
        onlineURLButton.anchor(top: onlineURLButtonContainer.topAnchor, bottom: onlineURLButtonContainer.bottomAnchor, centerX: onlineURLButtonContainer.centerXAnchor)
        return onlineURLButtonContainer
        
    }()
    
    /// When pressed, transitions to another page for edition. By default, the button shows a placeholder icon and label.
    lazy private(set) var onlineURLButton: OctarineButton = {
        
        let pencil = NSTextAttachment()
        pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

        let placeholderTitle = NSMutableAttributedString(string: "Add ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline), .foregroundColor: UIColor.white])
        placeholderTitle.append(NSAttributedString(attachment: pencil))
        
        let onlineURLButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[1], label: OctarineLabel(color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 1.5), left: .width(percent: 3.0), bottom: .width(percent: 1.5), right: .width(percent: 3.0)))
        onlineURLButton.shouldBounce = false
        onlineURLButton.setAttributedTitle(placeholderTitle, for: .normal)
        onlineURLButton.addShadowAndRoundCorners(cornerRadius: .width(percent: 3.5), shadowOpacity: 0.0, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        return onlineURLButton
        
    }()
    
    /// Displays the details of the event and when pressed, transitions to another page for edition. By default, the button shows a placeholder icon and label.
    lazy private(set) var detailsButton: OctarineButton = {
        
        let pencil = NSTextAttachment()
        pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Light", style: .headline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

        let placeholderTitle = NSMutableAttributedString(string: "Add Details ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Light", style: .headline), .foregroundColor: UIColor.white])
        placeholderTitle.append(NSAttributedString(attachment: pencil))
        
        let detailsButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[0], label: OctarineLabel(color: .white, bold: false, style: .headline, alignment: .center, lineLimit: 0), padding: UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 2.0))
        detailsButton.setAttributedTitle(placeholderTitle, for: .normal)
        return detailsButton
        
    }()
    
    /// Once all required input has been entered, creates the event and updates the database.
    lazy private(set) var createButton = LoadingButton(bgColor: .white, label: OctarineLabel(text: "Create", color: EventCategory.allCases[0].getGradientColors()[1], bold: true, style: .headline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: EventCategory.allCases[0].getGradientColors()[1], radius: 6.0, x: 0.0, y: 0.0))
    
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
        
        locationMapView.anchor(height: heightAnchor, multiples: CGSize(width: 1.0, height: 0.15))
        
    }
    
    /// Updates the UI according to the current input entered for the event being created. If any values are nil, default ones are used.
    func updateUI(eventInput: EventModel?) {
        
        let lightColor = eventInput?.category?.getGradientColors()[0] ?? EventCategory.allCases[0].getGradientColors()[0]
        let highlightedColor = lightColor.darkerColor(percent: 0.1)
        let darkColor = eventInput?.category?.getGradientColors()[1] ?? EventCategory.allCases[0].getGradientColors()[1]
        
        // 1. Change background and card color.
        backgroundColor = darkColor
        cardView.backgroundColor = lightColor
        
        // 2. Update navigation bar.
        navigationBar.backgroundColor = lightColor
        navigationBar.layer.shadowColor = darkColor.withAlphaComponent(0.6).cgColor
        
        // 3. Update top tag.
        topTag.backgroundColor = darkColor
        
        // 4. Update visibility icon and label.
        update(visibility: eventInput?.isPublic)
        
        // 5. Update event format icon and label.
        update(format: eventInput?.onlineURL != nil)
        
        // 6. Update title button.
        titleButton.backgroundColor = lightColor
        titleButton.highlightedColor = highlightedColor
        titleButton.nonHighlightedColor = lightColor
        
        update(title: eventInput?.title)
        
        // 7. Update popsicle border view.
        popsicleBorder.borderTraits.0 = darkColor
        
        // 8. Update date button.
        dateButton.backgroundColor = lightColor
        dateButton.highlightedColor = highlightedColor
        dateButton.nonHighlightedColor = lightColor
        
        update(startDate: eventInput?.startDate, endDate: eventInput?.endDate)
        
        // 9. Update location container.
        locationContainer.backgroundColor = darkColor
        
        // 10. Update event annotation.
        eventAnnotation.category = eventInput?.category ?? EventCategory.allCases[0]
        
        // 11. Update location label, map, and button.
        locationLabel.text = "Location"
        locationButton.backgroundColor = darkColor
        locationButton.highlightedColor = darkColor.darkerColor(percent: 0.1)
        locationButton.nonHighlightedColor = darkColor
        
        update(location: eventInput?.location, address: nil)
        
        // 12. Update online URL container.
        onlineURLContainer.backgroundColor = darkColor
        
        // 13. Update online URL text view and button.
        onlineURLTextView.backgroundColor = lightColor
        onlineURLButton.backgroundColor = darkColor
        onlineURLButton.highlightedColor = darkColor.darkerColor(percent: 0.1)
        onlineURLButton.nonHighlightedColor = darkColor
        
        update(onlineURL: eventInput?.onlineURL)
        
        // 14. Update details button.
        detailsButton.backgroundColor = lightColor
        detailsButton.highlightedColor = highlightedColor
        detailsButton.nonHighlightedColor = lightColor
        
        update(details: eventInput?.details)
        
        // 15. Update create button.
        createButton.setTitleColor(darkColor, for: .normal)
        createButton.layer.shadowColor = darkColor.cgColor
        
    }
    
    func update(visibility isPublic: Bool?) {
        
        if let isPublic = isPublic, !isPublic {
            
            visibilityIcon.image = UIImage(systemSymbol: .lockFill, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal)
            visibilityLabel.text = "Private"
            
        } else {
            
            visibilityIcon.image = UIImage(systemSymbol: .globe, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal)
            visibilityLabel.text = "Public"
            
        }
        
    }
    
    func update(format isOnline: Bool?) {
        
        if let isOnline = isOnline, isOnline {
            
            formatIcon.image = UIImage(systemSymbol: .personCropRectangle, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal)
            formatLabel.text = "Online"
            
        } else {
            
            formatIcon.image = UIImage(systemSymbol: .person3Fill, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal)
            formatLabel.text = "Live"
            
        }
        
    }
    
    func update(title: String?) {
        
        if let title = title {
            
            titleButton.setAttributedTitle(nil, for: .normal)
            titleButton.setTitle(title, for: .normal)
            
        } else {
            
            let pencil = NSTextAttachment()
            pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let placeholderTitle = NSMutableAttributedString(string: "Add Title ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline), .foregroundColor: UIColor.white])
            placeholderTitle.append(NSAttributedString(attachment: pencil))
            
            titleButton.setTitle(nil, for: .normal)
            titleButton.setAttributedTitle(placeholderTitle, for: .normal)
            
        }
        
    }
    
    func update(startDate: Date?, endDate: Date?) {
        
        if let startDate = startDate, let endDate = endDate {
            
            dateButton.setAttributedTitle(nil, for: .normal)
            dateButton.setTitle(Date.getFormattedDateInterval(start: startDate, end: endDate), for: .normal)
            
        } else {
            
            let pencil = NSTextAttachment()
            pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Light", style: .callout).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let placeholderTitle = NSMutableAttributedString(string: "Add Date ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Light", style: .callout), .foregroundColor: UIColor.white])
            placeholderTitle.append(NSAttributedString(attachment: pencil))
            
            dateButton.setTitle(nil, for: .normal)
            dateButton.setAttributedTitle(placeholderTitle, for: .normal)
            
        }
        
    }
    
    func update(location: CLLocationCoordinate2D?, address: String?) {
     
        if let location = location {
            
            if let address = address {
                
                self.locationLabel.text = address
                
            } else {
                
                self.locationLabel.text = "Location"
                
                location.lookUpLocationAddress { [weak self] (address) in
                    
                    guard let self = self else { return }
                    
                    if let address = address {
                        
                        self.locationLabel.text = address
                        
                    } else {
                        
                        self.locationLabel.text = "Address Unavailable"
                        
                    }
                    
                }
                
            }
            
            locationMapView.removeAnnotations(locationMapView.annotations)
            eventAnnotation.coordinate = location
            locationMapView.updateBoundaryRegion(center: eventAnnotation.coordinate, radius: 200.0, animated: false)
            locationMapView.addAnnotation(eventAnnotation)
            locationMapView.updateVisibleRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), radius: 200.0, animated: true)
            
            locationButton.setAttributedTitle(nil, for: .normal)
            locationButton.setTitle("Edit", for: .normal)
            
        } else {
            
            locationMapView.removeAnnotations(locationMapView.annotations)
            
            locationMapView.updateBoundaryRegion(center: MapViewController.defaultMapViewCenterLocation, radius: 200.0, animated: false)
            
            locationMapView.updateVisibleRegion(center: MapViewController.defaultMapViewCenterLocation, radius: 200.0, animated: true)
            
            let pencil = NSTextAttachment()
            pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let placeholderTitle = NSMutableAttributedString(string: "Add ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline), .foregroundColor: UIColor.white])
            placeholderTitle.append(NSAttributedString(attachment: pencil))
            
            locationButton.setTitle(nil, for: .normal)
            locationButton.setAttributedTitle(placeholderTitle, for: .normal)
            
        }
        
    }
    
    func update(onlineURL: URL?) {
        
        update(format: onlineURL != nil)
     
        if let onlineURL = onlineURL {
            
            onlineURLTextView.text = onlineURL.absoluteString
            
            onlineURLButton.setAttributedTitle(nil, for: .normal)
            onlineURLButton.setTitle("Edit", for: .normal)
            
        } else {
            
            onlineURLTextView.text = "Your event can take place online by adding a link. The physical location you enter will only be informative and help people find your event."
            
            let pencil = NSTextAttachment()
            pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let placeholderTitle = NSMutableAttributedString(string: "Add ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline), .foregroundColor: UIColor.white])
            placeholderTitle.append(NSAttributedString(attachment: pencil))
            
            onlineURLButton.setTitle(nil, for: .normal)
            onlineURLButton.setAttributedTitle(placeholderTitle, for: .normal)
            
        }
        
    }
    
    func update(details: String?) {
        
        if let details = details {
            
            detailsButton.setAttributedTitle(nil, for: .normal)
            detailsButton.setTitle(details, for: .normal)
            
        } else {
            
            let pencil = NSTextAttachment()
            pencil.image = UIImage(systemSymbol: .pencil, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Light", style: .headline).pointSize, weight: .heavy)).withTintColor(.white, renderingMode: .alwaysOriginal)

            let placeholderTitle = NSMutableAttributedString(string: "Add Details ", attributes: [.font: UIFont.dynamicFont(with: "Octarine-Light", style: .headline), .foregroundColor: UIColor.white])
            placeholderTitle.append(NSAttributedString(attachment: pencil))
            
            detailsButton.setTitle(nil, for: .normal)
            detailsButton.setAttributedTitle(placeholderTitle, for: .normal)
            
        }
        
    }
    
}

extension CreateEventSecondSectionView: UIScrollViewDelegate {
    
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

struct PreviewCreateEventSecondSectionView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
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
