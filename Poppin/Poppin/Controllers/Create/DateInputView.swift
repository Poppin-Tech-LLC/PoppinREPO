//
//  DateInputView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/31/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftDate
import SwiftUI

/// Event Date Input Page UI
final class DateInputView: UIView {
    
    /// Minimum event duration (30 minutes).
    let minEventDuration = EventModel.minEventDuration
    
    /// Maximum event duration (8 hours).
    let maxEventDuration = EventModel.maxEventDuration
    
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
    lazy private var titleLabel = OctarineLabel(text: "Event Date and Time", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1)
    
    /// Closes the input field and updates the event details.
    lazy private(set) var saveButton = OctarineButton(bgColor: EventCategory.allCases[0].getGradientColors()[0], label: OctarineLabel(text: "Save", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 4.0), left: .width(percent: 4.0), bottom: .width(percent: 4.0), right: .width(percent: 4.0)), cornerRadius: .width(percent: 4.0))
    
    /// Content scrollable stack.
    lazy private(set) var contentStack: ScrollableStackView = {
        
        let contentStack = ScrollableStackView(stackView: StackView(subviews: [startDateTextField, endDateTextField, durantionLabel], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 6.0), padding: .zero), padding: UIEdgeInsets(top: .width(percent: 1.0), left: 0.0, bottom: .width(percent: 1.0), right: 0.0))
        contentStack.delegate = self
        return contentStack
        
    }()

    /// Event start date input field.
    lazy private(set) var startDateTextField: UITextField = {
        
        let startDateTextField = UITextField()
        startDateTextField.backgroundColor = EventCategory.allCases[0].getGradientColors()[0]
        startDateTextField.textColor = .white
        startDateTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        startDateTextField.attributedPlaceholder = NSAttributedString(string: "Start Date and Time", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
        startDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: startDateTextField.intrinsicContentSize.height))
        startDateTextField.leftViewMode = .always
        startDateTextField.clearButtonMode = .whileEditing
        startDateTextField.returnKeyType = .next
        startDateTextField.autocapitalizationType = .none
        startDateTextField.autocorrectionType = .no
        startDateTextField.clearButtonMode = .never
        startDateTextField.setBottomBorder(color: UIColor.white, height: 1.0)
        startDateTextField.inputAccessoryView = pickerBarView
        startDateTextField.inputView = startDatePicker
        return startDateTextField
        
    }()
    
    /// Event start date picker. Defaults to the current date rounded to the next 15 minutes.
    lazy private(set) var startDatePicker: UIDatePicker = {
        
        let startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .dateAndTime
        startDatePicker.minuteInterval = 5
        startDatePicker.minimumDate = Date().dateRoundedAt(at: .toCeil5Mins) + 15.minutes
        startDatePicker.maximumDate = Date().dateRoundedAt(at: .toCeil5Mins) + 15.minutes + 7.days
        startDatePicker.setDate(startDatePicker.minimumDate ?? Date().dateRoundedAt(at: .toCeil5Mins) + 15.minutes, animated: false)
        return startDatePicker
        
    }()
    
    /// Event end date input field.
    lazy private(set) var endDateTextField: UITextField = {
        
        let endDateTextField = UITextField()
        endDateTextField.backgroundColor = EventCategory.allCases[0].getGradientColors()[0]
        endDateTextField.textColor = .white
        endDateTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        endDateTextField.attributedPlaceholder = NSAttributedString(string: "End Date and Time", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
        endDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: .width(percent: 1.0), height: endDateTextField.intrinsicContentSize.height))
        endDateTextField.leftViewMode = .always
        endDateTextField.clearButtonMode = .whileEditing
        endDateTextField.returnKeyType = .next
        endDateTextField.autocapitalizationType = .none
        endDateTextField.autocorrectionType = .no
        endDateTextField.clearButtonMode = .never
        endDateTextField.setBottomBorder(color: UIColor.white, height: 1.0)
        endDateTextField.inputAccessoryView = pickerBarView
        endDateTextField.inputView = endDatePicker
        return endDateTextField
        
    }()
    
    /// Event end date picker. Defaults to the start date plus the minimum event duration (30 minutes).
    lazy private(set) var endDatePicker: UIDatePicker = {
        
        let endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.minuteInterval = 5
        endDatePicker.minimumDate = (startDatePicker.minimumDate ?? Date().dateRoundedAt(at: .toCeil5Mins) + 15.minutes) + minEventDuration
        endDatePicker.maximumDate = Date().dateRoundedAt(at: .toCeil5Mins) + 15.minutes + 7.days
        endDatePicker.setDate(endDatePicker.minimumDate ?? (startDatePicker.minimumDate ?? Date().dateRoundedAt(at: .toCeil5Mins) + 15.minutes) + minEventDuration, animated: false)
        return endDatePicker
        
    }()
    
    // Accessory view on top of the keyboard.
    lazy private var pickerBarView: CardView = {
        
        let pickerBarView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[0])
        pickerBarView.frame = CGRect(x: 0.0, y: 0.0, width: .width(percent: 100), height: actionButton.intrinsicContentSize.height + 2.0)
        
        // 1. Add subviews to the card view (each one on top of the others).
        _ = [borderView, typeLabel, actionButton].map { pickerBarView.addSubview($0) }
        
        // 2. Apply constraints.
        borderView.anchor(top: pickerBarView.topAnchor, leading: pickerBarView.leadingAnchor, trailing: pickerBarView.trailingAnchor)
        
        typeLabel.anchor(centerX: pickerBarView.centerXAnchor, centerY: pickerBarView.centerYAnchor)
        
        actionButton.anchor(trailing: pickerBarView.trailingAnchor, centerY: pickerBarView.centerYAnchor)

        return pickerBarView
        
    }()
    
    // Border of the accessory view.
    lazy private var borderView: CardView = {
        
        let borderView = CardView(bgColor: EventCategory.allCases[0].getGradientColors()[1])
        borderView.anchor(size: CGSize(width: 0.0, height: 2.0))
        return borderView
        
    }()
    
    /// Input field type label.
    lazy private(set) var typeLabel = OctarineLabel(text: "Start Date and Time", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1)
    
    /// Jumps to the next or previous input field.
    lazy private(set) var actionButton = OctarineButton(bgColor: .clear, label: OctarineLabel(text: "Next", color: .white, bold: true, style: .subheadline, alignment: .center, lineLimit: 1), padding: UIEdgeInsets(top: .width(percent: 2.0), left: .width(percent: 4.0), bottom: .width(percent: 2.0), right: .width(percent: 4.0)))
    
    /// Shows the duration of the event calculated from the start and end dates. If the duration is invalid, a "-" is used.
    lazy private(set) var durantionLabel = OctarineLabel(text: "Duration: -", color: .white, bold: true, style: .subheadline, alignment: .right, lineLimit: 1)
    
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
    
    // Configure UI.
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
        
        // 5. Update start date text field.
        startDateTextField.backgroundColor = lightColor
        startDateTextField.text = eventInput?.startDate?.getFormattedDate()
        
        // 6. Update end date text field.
        endDateTextField.backgroundColor = lightColor
        endDateTextField.text = eventInput?.endDate?.getFormattedDate()
        
        // 7. Update start date picker.
        if let startDate = eventInput?.startDate { startDatePicker.setDate(startDate, animated: false) }
        
        // 8. Update end date picker.
        if let endDate = eventInput?.endDate { endDatePicker.setDate(endDate, animated: false) }
        
        // 9. Change picker bar view and border view color.
        pickerBarView.backgroundColor = lightColor
        borderView.backgroundColor = darkColor
        
        // 10. Update duration label.
        durantionLabel.text = "Duration: " + getFormattedDuration(startDate: eventInput?.startDate, endDate: eventInput?.endDate)
        
        // 11. Notify input fields changes.
        inputFieldsDidChange()
        
    }
    
    /// Called when changes occur to any of the input fields. Enables or disables the save button according to the input fields content.
    func inputFieldsDidChange() {
        
        // 1. Once input fields have been filled, enable the save button.
        if !startDateTextField.isEmpty() && !endDateTextField.isEmpty() && saveButton.isDisabled {
            
            saveButton.isDisabled = false
            
        } else if startDateTextField.isEmpty() || endDateTextField.isEmpty() && !saveButton.isDisabled {
            
            saveButton.isDisabled = true
            
        }
        
    }
    
    /// Calculates and formats a duration from a start date and end date. If the duration is invalid, a default value is returned.
    func getFormattedDuration(startDate: Date?, endDate: Date?) -> String {
        
        // 1. Safe checks. Return default value if fail.
        guard let startDate = startDate else { return "-" }
        guard let endDate = endDate else { return "-" }
        if startDate.isAfterDate(endDate, granularity: .minute) { return "-" }
        guard let hours = (endDate - startDate).hour else { return "-" }
        guard let minutes = (endDate - startDate).minute else { return "-" }
        
        // 2. Return formatted duration.
        return String(hours) + "h " + String(minutes) + "m"
        
    }
    
}

extension DateInputView: UIScrollViewDelegate {
    
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

struct PreviewDateInputView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = DateInputView
    
}

struct TestPreviewDateInputView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewDateInputView
    
}
