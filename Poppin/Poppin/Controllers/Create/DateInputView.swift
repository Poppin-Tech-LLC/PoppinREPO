//
//  DateInputView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/31/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct PreviewDateInputView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType(formattedStartDate: nil, formattedEndDate: nil, formattedDuration: nil, category: nil)
        
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

final class DateInputView: UIView {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var formattedStartDate: String?
    private var formattedEndDate: String?
    private var formattedDuration: String?
    private var category: EventCategory = .Culture
    
    weak var delegate: DateInputDelegate?
    
    lazy private var cardView: UIView = {
       
        var cardView = UIView()
        cardView.clipsToBounds = true
        cardView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        cardView.backgroundColor = category.getGradientColors()[0]
        
        cardView.addSubview(cancelButton)
        cancelButton.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: 0.0, right: 0.0))
        
        cardView.addSubview(dateTitleLabel)
        dateTitleLabel.anchor(centerX: cardView.centerXAnchor, centerY: cancelButton.centerYAnchor)
        
        cardView.addSubview(saveButton)
        saveButton.anchor(top: cardView.topAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: yInset, left: 0.0, bottom: 0.0, right: xInset))
        
        cardView.addSubview(startDateTextField)
        startDateTextField.anchor(top: cancelButton.bottomAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: yInset, left: xInset, bottom: 0.0, right: xInset))
        
        cardView.addSubview(endDateTextField)
        endDateTextField.anchor(top: startDateTextField.bottomAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: yInset*1.33, left: xInset, bottom: 0.0, right: xInset))
        
        cardView.addSubview(durantionTitleLabel)
        durantionTitleLabel.anchor(top: endDateTextField.bottomAnchor, leading: cardView.leadingAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: yInset*1.33, left: xInset, bottom: 0.0, right: xInset))
        
        return cardView
        
    }()
    
    lazy private(set) var cancelButton: BouncyButton = {
        
        var cancelButton = BouncyButton(bouncyButtonImage: nil)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        cancelButton.setTitleColor(.white, for: .normal)
        return cancelButton
        
    }()
    
    lazy private var dateTitleLabel: UILabel = {
        
        var dateTitleLabel = UILabel()
        dateTitleLabel.text = "Date and Time"
        dateTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        dateTitleLabel.textColor = .white
        dateTitleLabel.textAlignment = .center
        dateTitleLabel.numberOfLines = 1
        return dateTitleLabel
        
    }()
    
    lazy private(set) var saveButton: BouncyButton = {
        
        var saveButton = BouncyButton(bouncyButtonImage: nil)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        saveButton.setTitleColor(.white, for: .normal)
        return saveButton
        
    }()

    lazy private(set) var startDateTextField: UITextField = {
        
        let pickerTypeLabel = UILabel()
        pickerTypeLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        pickerTypeLabel.text = "Start Date"
        pickerTypeLabel.textColor = .white
        pickerTypeLabel.numberOfLines = 1
        pickerTypeLabel.textAlignment = .center
        
        let doneButton = BouncyButton(bouncyButtonImage: nil)
        doneButton.setTitle("Next", for: .normal)
        doneButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(closeDatePicker), for: .touchUpInside)
        
        let borderView = UIView()
        borderView.backgroundColor = category.getGradientColors()[1]
        
        let pickerBarView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: .getPercentageWidth(percentage: 100), height: pickerTypeLabel.intrinsicContentSize.height + (yInset*1.5)))
        pickerBarView.backgroundColor = category.getGradientColors()[0]
        pickerBarView.addSubview(borderView)
        borderView.anchor(top: pickerBarView.topAnchor, leading: pickerBarView.leadingAnchor, trailing: pickerBarView.trailingAnchor, size: CGSize(width: 0.0, height: 2.0))
        pickerBarView.addSubview(doneButton)
        doneButton.anchor(trailing: pickerBarView.trailingAnchor, centerY: pickerBarView.centerYAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: xInset*1.1))
        pickerBarView.addSubview(pickerTypeLabel)
        pickerTypeLabel.anchor(centerX: pickerBarView.centerXAnchor, centerY: pickerBarView.centerYAnchor)
        
        var startDateTextField = UITextField()
        startDateTextField.backgroundColor = category.getGradientColors()[0]
        startDateTextField.textColor = .white
        startDateTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        startDateTextField.text = formattedStartDate
        startDateTextField.attributedPlaceholder = NSAttributedString(string: "Start Date", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
        startDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: xInset*0.33, height: startDateTextField.intrinsicContentSize.height))
        startDateTextField.leftViewMode = .always
        startDateTextField.clearButtonMode = .whileEditing
        startDateTextField.returnKeyType = .next
        startDateTextField.autocapitalizationType = .none
        startDateTextField.autocorrectionType = .no
        startDateTextField.clearButtonMode = .never
        startDateTextField.setBottomBorder(color: UIColor.white, height: 1.0)
        startDateTextField.inputAccessoryView = pickerBarView
        
        startDateTextField.translatesAutoresizingMaskIntoConstraints = false
        startDateTextField.heightAnchor.constraint(equalToConstant: startDateTextField.intrinsicContentSize.height+(yInset*0.5)).isActive = true
        
        return startDateTextField
        
    }()
    
    lazy private(set) var endDateTextField: UITextField = {
        
        let pickerTypeLabel = UILabel()
        pickerTypeLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        pickerTypeLabel.text = "End Date"
        pickerTypeLabel.textColor = .white
        pickerTypeLabel.numberOfLines = 1
        pickerTypeLabel.textAlignment = .center
        
        let doneButton = BouncyButton(bouncyButtonImage: nil)
        doneButton.setTitle("Back", for: .normal)
        doneButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(closeDatePicker), for: .touchUpInside)
        
        let borderView = UIView()
        borderView.backgroundColor = category.getGradientColors()[1]
        
        let pickerBarView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: .getPercentageWidth(percentage: 100), height: pickerTypeLabel.intrinsicContentSize.height + (yInset*1.5)))
        pickerBarView.backgroundColor = category.getGradientColors()[0]
        pickerBarView.addSubview(borderView)
        borderView.anchor(top: pickerBarView.topAnchor, leading: pickerBarView.leadingAnchor, trailing: pickerBarView.trailingAnchor, size: CGSize(width: 0.0, height: 2.0))
        pickerBarView.addSubview(doneButton)
        doneButton.anchor(trailing: pickerBarView.trailingAnchor, centerY: pickerBarView.centerYAnchor, padding: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: xInset*1.1))
        pickerBarView.addSubview(pickerTypeLabel)
        pickerTypeLabel.anchor(centerX: pickerBarView.centerXAnchor, centerY: pickerBarView.centerYAnchor)
        
        var endDateTextField = UITextField()
        endDateTextField.backgroundColor = category.getGradientColors()[0]
        endDateTextField.textColor = .white
        endDateTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        endDateTextField.text = formattedEndDate
        endDateTextField.attributedPlaceholder = NSAttributedString(string: "End Date", attributes: [NSAttributedString.Key.font : UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline), NSAttributedString.Key.foregroundColor : UIColor.white])
        endDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: xInset*0.33, height: endDateTextField.intrinsicContentSize.height))
        endDateTextField.leftViewMode = .always
        endDateTextField.clearButtonMode = .whileEditing
        endDateTextField.returnKeyType = .next
        endDateTextField.autocapitalizationType = .none
        endDateTextField.autocorrectionType = .no
        endDateTextField.clearButtonMode = .never
        endDateTextField.setBottomBorder(color: UIColor.white, height: 1.0)
        endDateTextField.inputAccessoryView = pickerBarView
        
        endDateTextField.translatesAutoresizingMaskIntoConstraints = false
        endDateTextField.heightAnchor.constraint(equalToConstant: endDateTextField.intrinsicContentSize.height+(yInset*0.33)).isActive = true
        
        return endDateTextField
        
    }()
    
    lazy private(set) var durantionTitleLabel: UILabel = {
        
        var dateTitleLabel = UILabel()
        dateTitleLabel.text = formattedDuration
        dateTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        dateTitleLabel.textColor = .white
        dateTitleLabel.textAlignment = .right
        dateTitleLabel.numberOfLines = 1
        return dateTitleLabel
        
    }()
    
    init(formattedStartDate: String?, formattedEndDate: String?, formattedDuration: String?, category: EventCategory?) {
        
        super.init(frame: .zero)
        
        self.formattedStartDate = formattedStartDate
        self.formattedEndDate = formattedEndDate
        self.formattedDuration = formattedDuration
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
    
    @objc private func closeDatePicker() {
        
        delegate?.closeDatePicker()
        
    }
    
}
