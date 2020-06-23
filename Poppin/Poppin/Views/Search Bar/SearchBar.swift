//
//  SearchBar.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 5/1/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class SearchBar: UISearchBar {
    
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
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        searchTextField.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 15.0, maxSize: 20.0))
        searchTextField.textColor = searchBarTintColor
        searchTextField.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 19.0)
        searchTextField.layer.cornerCurve = .continuous
        searchTextField.layer.masksToBounds = true
        searchTextField.leftView?.tintColor = searchBarTintColor
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedString.Key.foregroundColor: searchBarTintColor])
        
    }
    
}

