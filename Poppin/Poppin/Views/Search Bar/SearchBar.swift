//
//  SearchBar.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 5/1/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class SearchBar: UISearchBar {
    
    static let defaultSearchBarHeight: CGFloat = .getPercentageWidth(percentage: 10.5)
    static let defaultSearchBarWidth: CGFloat = .getPercentageWidth(percentage: 90)
    
    lazy private var searchBarTintColor: UIColor = UIColor.white
    
    init(tintColor: UIColor?) {
        
        super.init(frame: .zero)
        
        if let newTintColor = tintColor { searchBarTintColor = newTintColor }
        
        configureSearchBar()
        
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        configureSearchBar()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureSearchBar()
        
    }
    
    private func configureSearchBar() {
        
        isTranslucent = true
        searchBarStyle = .minimal
        setImage(UIImage(systemSymbol: .magnifyingglass, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .heavy)).withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .search, state: .normal)
        setImage(UIImage(systemSymbol: .xmarkCircleFill, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .bold)).withTintColor(UIColor.white, renderingMode: .alwaysOriginal), for: .clear, state: .normal)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        searchTextField.leftView?.heightAnchor.constraint(equalToConstant: searchTextField.font!.pointSize * .getWidthFitSize(minSize: 1.0, maxSize: 1.15)).isActive = true
        searchTextField.leftView?.widthAnchor.constraint(equalTo: searchTextField.leftView!.heightAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        searchTextField.font = .dynamicFont(with: "Octarine-Bold", style: .callout)
        searchTextField.textColor = searchBarTintColor
        searchTextField.layer.cornerRadius = .getWidthFitSize(minSize: 12.0, maxSize: 16.0)
        searchTextField.layer.cornerCurve = .continuous
        searchTextField.layer.masksToBounds = true
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: searchBarTintColor])
        
    }
    
}

