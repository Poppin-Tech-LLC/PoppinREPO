//
//  SearchBar.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 5/1/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

final class SearchBarView: CardView {
    
    var searchBarColor: UIColor = .white {

        didSet {

            searchBar.searchBarColor = searchBarColor
            cancelButton.setTitleColor(searchBarColor, for: .normal)

        }

    }
    
    lazy private(set) var searchBar: SearchBar = {
        
        let searchBar = SearchBar(searchBarColor: searchBarColor)
        searchBar.searchTextField.delegate = self
        return searchBar
        
    }()
    
    lazy private(set) var cancelButton: OctarineButton = {
        
        let cancelButton = OctarineButton(bgColor: .clear, label: OctarineLabel(text: "Cancel", color: searchBarColor, bold: true, style: .subheadline, alignment: .center, lineLimit: 1))
        cancelButton.alpha = 0.0
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return cancelButton
        
    }()
    
    lazy private var searchBarEditingTrailingConstraint = NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: cancelButton, attribute: .leading, multiplier: 1.0, constant: -.width(percent: 3.0))
    
    lazy private var searchBarNotEditingTrailingConstraint = NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: self.layoutMarginsGuide, attribute: .trailing, multiplier: 1.0, constant: 0.0)
    
    init(searchBarColor: UIColor = .white, searchBarPlaceholder: String = "Search...", padding: UIEdgeInsets = .zero) {
        
        super.init(bgColor: .clear, padding: padding)
        
        self.searchBarColor = searchBarColor
        self.searchBar.searchBarPlaceholder = searchBarPlaceholder
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        backgroundColor = .clear
        
        _ = [cancelButton, searchBar].map { addSubview($0) }
        
        cancelButton.anchor(top: layoutMarginsGuide.topAnchor, bottom: layoutMarginsGuide.bottomAnchor, trailing: layoutMarginsGuide.trailingAnchor)
        
        searchBar.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, bottom: layoutMarginsGuide.bottomAnchor)
        searchBarNotEditingTrailingConstraint.isActive = true
        
    }
    
    @objc private func cancel() {
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.endEditing(true)
                        self.cancelButton.alpha = 0.0
                        self.searchBarEditingTrailingConstraint.isActive = false
                        self.searchBarNotEditingTrailingConstraint.isActive = true
                        
                        self.layoutIfNeeded()
                        
        }, completion: nil)
        
    }
    
}

extension SearchBarView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.825,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: {
                        
                        self.endEditing(true)
                        self.cancelButton.alpha = 1.0
                        self.searchBarEditingTrailingConstraint.isActive = true
                        self.searchBarNotEditingTrailingConstraint.isActive = false
                        
                        self.layoutIfNeeded()
                        
        }, completion: nil)
        
        return true
        
    }
    
}

final class SearchBar: UISearchBar {
    
    var searchBarColor: UIColor = .white {
        
        didSet {
            
            setImage(UIImage(systemSymbol: .magnifyingglass, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(searchBarColor, renderingMode: .alwaysOriginal), for: .search, state: .normal)
            setImage(UIImage(systemSymbol: .xmarkCircleFill, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(searchBarColor, renderingMode: .alwaysOriginal), for: .clear, state: .normal)
            searchTextField.textColor = searchBarColor
            searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: searchBarColor])
            
        }
        
    }
    
    var searchBarPlaceholder: String = "Search..." {
        
        didSet {
            
            searchTextField.attributedPlaceholder = NSAttributedString(string: searchBarPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: searchBarColor])
            
        }
        
    }
    
    init(searchBarColor: UIColor = .white, searchBarPlaceholder: String = "Search...") {
        
        super.init(frame: .zero)
        
        self.searchBarColor = searchBarColor
        self.searchBarPlaceholder = searchBarPlaceholder
        
        configureSearchBar()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.searchBarColor = .white
        
        configureSearchBar()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSearchBar() {
        
        isTranslucent = true
        searchBarStyle = .minimal
        searchTextField.clearButtonMode = .whileEditing
        
        setImage(UIImage(systemSymbol: .magnifyingglass, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(searchBarColor, renderingMode: .alwaysOriginal), for: .search, state: .normal)
        setImage(UIImage(systemSymbol: .xmarkCircleFill, withConfiguration: UIImage.SymbolConfiguration(pointSize: UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline).pointSize, weight: .heavy)).withTintColor(searchBarColor, renderingMode: .alwaysOriginal), for: .clear, state: .normal)
        
        searchTextField.attatchEdgesToSuperview()
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        searchTextField.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        searchTextField.textColor = searchBarColor
        searchTextField.layer.cornerRadius = .width(percent: 3.0)
        searchTextField.layer.cornerCurve = .continuous
        searchTextField.layer.masksToBounds = true
        searchTextField.attributedPlaceholder = NSAttributedString(string: searchBarPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: searchBarColor])
        
    }
    
}

