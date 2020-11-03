//
//  CreateEventFirstSectionView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/26/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

/// First Section of the Create Event Page (Category and Visibility) UI.
final class CreateEventFirstSectionView: UIView {
    
    /// Index of the current page showing on the event category picker (defaults to 0).
    private(set) var currentPage: Int = 0
    
    // Popsicle icons for each of the event categories in the picker.
    lazy private var pagePopsicleIcons: [UIImage] = [EventCategory.allCases[0].getPopsicleIcon256().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 33), height: .width(percent: 33)))]
    
    // Current event category background (far most left category from the picker by default).
    lazy private var backgroundView: UIImageView = UIImageView(image: pageBackgrounds[0])
    
    // Gradient backgrounds for each of the event categories in the picker.
    lazy private var pageBackgrounds: [UIImage] = [EventCategory.allCases[0].getGradientBackground()]
    
    // Content margins.
    lazy private var contentLayoutGuide = UILayoutGuide()
    
    // Top bar containing the close button and the title label.
    lazy private var navigationBar: UIView = {
        
        let navigationBar = UIView()
        navigationBar.backgroundColor = .clear
        navigationBar.apply(shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
        navigationBar.layer.shadowOpacity = 0.0
        
        navigationBar.addSubview(closeButton)
        closeButton.anchor(top: navigationBar.topAnchor, leading: navigationBar.leadingAnchor, bottom: navigationBar.bottomAnchor)
        
        navigationBar.addSubview(titleLabel)
        titleLabel.anchor(top: closeButton.topAnchor, bottom: closeButton.bottomAnchor, centerX: navigationBar.centerXAnchor, padding: UIEdgeInsets(top: closeButton.padding.top + 3.0, left: 0.0, bottom: closeButton.padding.bottom, right: 0.0))
        
        return navigationBar
        
    }()
    
    /// Button that closes the create event page.
    lazy private(set) var closeButton: OctarineButton = {
        
        let closeButton = OctarineButton(bgColor: .clear, label: nil, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)))
        closeButton.setImage(UIImage(systemSymbol: .xmark, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .headline).pointSize, weight: .semibold)).withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        return closeButton
        
    }()
    
    // Create event page title.
    lazy private var titleLabel = OctarineLabel(text: "Create Event", color: .white, bold: true, style: .headline, alignment: .center, lineLimit: 1)
    
    // Horizontally-scrolling collection used to pick the category of the event (defaulted to the far most left one).
    lazy private var categoryPicker: UICollectionView = {
        
        let categoryPickerLayout = UICollectionViewFlowLayout()
        categoryPickerLayout.scrollDirection = .horizontal
        categoryPickerLayout.minimumLineSpacing = 0
        
        let categoryPicker = UICollectionView(frame: .zero, collectionViewLayout: categoryPickerLayout)
        categoryPicker.backgroundColor = .clear
        categoryPicker.isPagingEnabled = true
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.register(EventCategoryCell.self, forCellWithReuseIdentifier: EventCategoryCell.defaultReuseIdentifier)
        categoryPicker.showsHorizontalScrollIndicator = false
        return categoryPicker
        
    }()
    
    // Bottom content stack.
    lazy private var bottomStack: StackView = StackView(subviews: [pageMarkerStack, visibilityStackView, nextButton], axis: .vertical, alignment: .center, distribution: .fill, spacing: .width(percent: 6.0), padding: NSDirectionalEdgeInsets(top: .width(percent: 6.0), leading: 0.0, bottom: 0.0, trailing: 0.0))
    
    // Stack of page markers (far most left one is filled by default).
    lazy private var pageMarkerStack: StackView = {
        
        var pageMarkers: [UIImageView] = []
        
        for i in 0..<EventCategory.allCases.count {
        
            if i == 0 {
                
                pageMarkers.append(UIImageView(image: UIImage.filledPopsicleIcon64.scalePreservingAspectRatio(targetSize: CGSize(width: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, height: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize)).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)))
                
            } else {
                
                pageMarkers.append(UIImageView(image: UIImage.nonFilledPopsicleIcon64.scalePreservingAspectRatio(targetSize: CGSize(width: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, height: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize)).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)))
                
            }
            
        }
        
        let pageMarkerStack = StackView(subviews: pageMarkers, axis: .horizontal, alignment: .fill, distribution: .fill, spacing: .width(percent: 3.5), padding: .zero)
        return pageMarkerStack
        
    }()
    
    // Event public/private visibility stack.
    lazy private var visibilityStackView = StackView(subviews: [privateVisibilityStack, visibilitySwitch, publicVisibilityStack], axis: .horizontal, alignment: .center, distribution: .fill, spacing: .width(percent: 5.0), padding: .zero)
    
    // Private visibility icon and label stack (left of switch).
    lazy private var privateVisibilityStack: StackView = {
        
        let privateLabel = OctarineLabel(text: "Private", color: .white, bold: true, style: .caption1, alignment: .center, lineLimit: 1)
        
        let privateIcon = UIImageView(image: UIImage(systemSymbol: .lockFill, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
        
        let privateVisibilityStackView = StackView(subviews: [privateIcon, privateLabel], axis: .vertical, alignment: .center, distribution: .fill, spacing: .width(percent: 0.5), padding: .zero)
        return privateVisibilityStackView
        
    }()
    
    // Public visibility icon and label stack (right of switch).
    lazy private var publicVisibilityStack: StackView = {
        
        let publicLabel = OctarineLabel(text: "Public", color: .white, bold: true, style: .caption1, alignment: .center, lineLimit: 1)
        
        let publicIcon = UIImageView(image: UIImage(systemSymbol: .globe, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .footnote).pointSize, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
        
        let publicVisibilityStackView = StackView(subviews: [publicIcon, publicLabel], axis: .vertical, alignment: .center, distribution: .fill, spacing: .width(percent: 0.5), padding: .zero)
        publicVisibilityStackView.alpha = 0.7
        return publicVisibilityStackView
        
    }()
    
    /// Switch to toggle the event's visibility (private by default),
    lazy private(set) var visibilitySwitch: UISwitch = {
        
        let visibilitySwitch = UISwitch()
        visibilitySwitch.onTintColor = .poppinLIGHTGOLD
        visibilitySwitch.thumbTintColor = .white
        visibilitySwitch.isOn = false
        visibilitySwitch.addTarget(self, action: #selector(toggleVisibilityStackViews(sender:)), for: .valueChanged)
        return visibilitySwitch
        
    }()
    
    /// Button that transitions to the next section of the create event page.
    lazy private(set) var nextButton = OctarineButton(bgColor: .white, label: OctarineLabel(text: "Next", color: EventCategory.allCases[0].getGradientColors()[1], bold: true, style: .headline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 4.0), shadow: Shadow(color: UIColor.gray.withAlphaComponent(0.4), radius: 4.0, x: 0.0, y: 1.0))
    
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
        
        // 1. Load arrays async.
        DispatchQueue.main.async {
            
            for i in 0..<EventCategory.allCases.count {
                
                if i != 0 {
                    
                    self.pagePopsicleIcons.append(EventCategory.allCases[i].getPopsicleIcon256().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 33), height: .width(percent: 33))))
                    self.pageBackgrounds.append(EventCategory.allCases[i].getGradientBackground().scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 100), height: .height(percent: 100))))
                    
                }
                
            }
            
        }
        
        // 2. Add layout guides to the root view.
        _ = [contentLayoutGuide].map { self.addLayoutGuide($0) }
        
        // 3. Add subviews to the root view (each one on top of the others).
        _ = [backgroundView, navigationBar, categoryPicker, bottomStack].map { self.addSubview($0) }
        
        // 4. Apply constraints.
        backgroundView.attatchEdgesToSuperview()
        
        contentLayoutGuide.attatchEdgesTo(superview: self, safeArea: true, padding: UIEdgeInsets(top: .width(percent: 3.0), left: .width(percent: 4.0), bottom: .width(percent: 6.0), right: .width(percent: 4.0)))
        
        navigationBar.anchor(top: contentLayoutGuide.topAnchor, leading: contentLayoutGuide.leadingAnchor, trailing: contentLayoutGuide.trailingAnchor)
        
        bottomStack.anchor(leading: contentLayoutGuide.leadingAnchor, bottom: contentLayoutGuide.bottomAnchor, trailing: contentLayoutGuide.trailingAnchor)
        
        categoryPicker.anchor(top: navigationBar.bottomAnchor, leading: leadingAnchor, bottom: bottomStack.topAnchor, trailing: trailingAnchor)
        
    }
    
    // Updates the visibility stack UI once the visibility switch changes state.
    @objc private func toggleVisibilityStackViews(sender: UISwitch) {
        
        if sender.isOn {
            
            UIView.animate(withDuration: 0.55, delay: 0.0, usingSpringWithDamping: 0.825, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                
                self.privateVisibilityStack.alpha = 0.7
                self.publicVisibilityStack.alpha = 1.0
                
            }, completion: nil)
            
        } else {
            
            UIView.animate(withDuration: 0.55, delay: 0.0, usingSpringWithDamping: 0.825, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                
                self.privateVisibilityStack.alpha = 1.0
                self.publicVisibilityStack.alpha = 0.7
                
            }, completion: nil)
            
        }
        
    }
    
}

extension CreateEventFirstSectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    /// Delegate function that returns the size for the cell at an index. Lets the cell resize itself.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        
    }
    
    /// Delegate function that returns the number of cells for each section. Returs the current number of event categories.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return EventCategory.allCases.count }
    
    /// Delegate function that returns the UI for the cell at an index. Returns a custom Event Category cell.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 1. Checks if there are cells to reuse.
        if let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCategoryCell.defaultReuseIdentifier, for: indexPath) as? EventCategoryCell {
            
            // 2. Customize and return the reused cell.
            categoryCell.categoryIcon.image = pagePopsicleIcons[indexPath.row]
            categoryCell.categoryTitle.text = EventCategory.allCases[indexPath.row].rawValue
            categoryCell.categoryDescription.text = EventCategory.allCases[indexPath.row].getDescription()
            return categoryCell
            
        }
        
        // 3. If fails to return a custom cell, return a default one.
        else { return UICollectionViewCell() }
        
    }
    
    /// Delegate function called when the scroll view scrolls. Depending on the curent scroll position, the current page index is updated. Also, the category picker is animated.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 1. Get scroll ofset.
        let pageOffset = scrollView.contentOffset.x / frame.width
        
        // 2. Safe check the offset is not beyond the limits of the category picker.
        if pageOffset >= 0.0, pageOffset < CGFloat(EventCategory.allCases.count) {
            
            let minOffset = CGFloat(currentPage) - 0.5
            let maxOffset = CGFloat(currentPage) + 0.5
            
            // 3. The user scrolls left enough to shift to previous page.
            if pageOffset < minOffset {
                
                // 4. Current page index is updated.
                currentPage-=1
                
                // 5. Animate the background.
                UIView.transition(with: backgroundView,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { self.backgroundView.image = self.pageBackgrounds[self.currentPage] },
                completion: nil)
                
                // 6. Animate the next button label color.
                UIView.transition(with: nextButton,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { self.nextButton.setTitleColor(EventCategory.allCases[self.currentPage].getGradientColors()[1], for: .normal) },
                completion: nil)
                
                // 7. Animate the page markers.
                UIView.transition(with: pageMarkerStack,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: {
                    
                    if let previousPageMarker = self.pageMarkerStack.arrangedSubviews[self.currentPage + 1] as? UIImageView, let currentPageMarker = self.pageMarkerStack.arrangedSubviews[self.currentPage] as? UIImageView {
                        
                        let previousImage = previousPageMarker.image
                        
                        previousPageMarker.image = currentPageMarker.image
                        currentPageMarker.image = previousImage
                        
                    }
                    
                    
                }, completion: nil)
                
            } else if pageOffset > maxOffset {
                
                // 8. Current page index is updated.
                currentPage+=1
                
                // 9. Animate the background.
                UIView.transition(with: backgroundView,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { self.backgroundView.image = self.pageBackgrounds[self.currentPage] },
                completion: nil)
                
                // 10. Animate the next button label color.
                UIView.transition(with: nextButton,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: { self.nextButton.setTitleColor(EventCategory.allCases[self.currentPage].getGradientColors()[1], for: .normal) },
                completion: nil)
                
                // 11. Animate the page markers.
                UIView.transition(with: pageMarkerStack,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: {
                
                    if let previousPageMarker = self.pageMarkerStack.arrangedSubviews[self.currentPage - 1] as? UIImageView, let currentPageMarker = self.pageMarkerStack.arrangedSubviews[self.currentPage] as? UIImageView {
                        
                        let previousImage = previousPageMarker.image
                        
                        previousPageMarker.image = currentPageMarker.image
                        currentPageMarker.image = previousImage
                        
                    }
                
                }, completion: nil)
                
            }
            
        }
        
        // 12. Get center x of the category picker.
        let centerX = categoryPicker.center.x
        
        // 13. Animate visible cells for a smooth transition between pages.
        for cell in categoryPicker.visibleCells {
            
            // 14. Safe check if cell is custom cell. If fails, continue to the next cell.
            guard let cell = cell as? EventCategoryCell else { continue }
            
            // 15. Get center x of the current cell.
            let cellCenterX = cell.convert(CGPoint.zero, to: self).x + categoryPicker.frame.size.width / 2.0
            
            // 16. Calculate animation scale.
            var scale = 1.00 + (0.02 - ((abs(cellCenterX - centerX)/centerX) * 0.105))
            
            // 17. If scale is beyond animation limits, set it to the max or min value.
            if scale > 1.0 { scale = 1.0 }
            else if scale < 0.860091 { scale = 0.860091 }
            
            // 18. Animate the cell size according to the calculated scale.
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            // 19. Animate the cell opacity according to the calculated scale.
            cell.contentView.alpha = changeSizeScaleToAlphaScale(scale)
            
        }
        
    }
    
    // Helper function that calculates a relative opacity scale according to a size scale passed.
    private func changeSizeScaleToAlphaScale(_ x : CGFloat) -> CGFloat {
        
        let minScale : CGFloat = 0.86
        let maxScale : CGFloat = 1.0
        
        let minAlpha : CGFloat = 0.25
        let maxAlpha : CGFloat = 1.0
        
        return ((maxAlpha - minAlpha) * (x - minScale)) / (maxScale - minScale) + minAlpha
        
    }
    
}

/// Event Category Picker Cell UI.
final class EventCategoryCell : UICollectionViewCell {
    
    /// Used to reuse an existent cell (more efficient).
    static let defaultReuseIdentifier: String = "EventCategoryCell"
    
    /// Cell content (icon, border and labels).
    lazy private(set) var contentStack = StackView(subviews: [categoryIcon, textStack], axis: .vertical, alignment: .center, distribution: .fill, spacing: .width(percent: 4.0), padding: .zero)
    
    /// Popsicle icon of the current event category (defaultsto the culture popsicle).
    lazy private(set) var categoryIcon : UIImageView = UIImageView(image: UIImage.culturePopsicleIcon256.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 33), height: .width(percent: 33))))
    
    // Verical stack containing the labels and popsicle border of the cell.
    lazy private var textStack = StackView(subviews: [categoryTitle, popsicleBorder, categoryDescription], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 2.5), padding: NSDirectionalEdgeInsets(top: .width(percent: 0.0), leading: .width(percent: 20.0), bottom: 0.0, trailing: .width(percent: 20.0)))
    
    /// Title of the current event category (defaults to Culture).
    lazy private(set) var categoryTitle: OctarineLabel = {
        
        let categoryLabel = OctarineLabel(text: EventCategory.allCases[0].rawValue, color: .white, bold: true, style: .title3, alignment: .center, lineLimit: 1)
        categoryLabel.lineBreakMode = .byWordWrapping
        return categoryLabel
        
    }()
    
    // Separates the title and description labels.
    lazy private var popsicleBorder = PopsicleBorderView(with: .white, .headline)
    
    /// Description of the current event category (defaults to the cultural event description).
    lazy private(set) var categoryDescription: OctarineLabel = {
        
        let descriptionLabel = OctarineLabel(text: EventCategory.allCases[0].getDescription(), color: .white, bold: false, style: .headline, alignment: .center, lineLimit: 0)
        descriptionLabel.lineBreakMode = .byWordWrapping
        return descriptionLabel
        
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
    
        // 1. Clear the background.
        contentView.backgroundColor = .clear
        
        // 2. Add subviews to the content view of the cell.
        contentView.addSubview(contentStack)
        
        // 3. Apply contraints.
        contentStack.anchor(leading: leadingAnchor, trailing: trailingAnchor, centerY: contentView.centerYAnchor)
        
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
