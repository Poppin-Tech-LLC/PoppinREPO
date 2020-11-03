//
//  LocationSearchCell.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 11/5/19.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// Location Table View Cell UI.
final class LocationCell: UITableViewCell {
    
    /// Identifier used to retrieve a reusable cell.
    static let defaultReuseIdentifier = "LocationCell"
    
    /// Location title.
    var title: String? = nil {
        
        didSet {
            
            titleLabel.text = title
            
            if title == nil || title == "" {
                
                titleLabel.isHidden = true
                
            } else {
                
                titleLabel.isHidden = false
                
            }
            
        }
        
    }
    
    /// Location address.
    var address: String? = nil {
        
        didSet {
            
            addressLabel.text = address
            
            if address == nil || address == "" {
                
                addressLabel.isHidden = true
                
            } else {
                
                addressLabel.isHidden = false
                
            }
            
        }
        
    }
    
    // Contains the title and address labels.
    lazy private var contentStack = StackView(subviews: [titleLabel, addressLabel], axis: .vertical, alignment: .fill, distribution: .fill, spacing: .width(percent: 1.0), padding: NSDirectionalEdgeInsets(top: .width(percent: 4.0), leading: .width(percent: 4.0), bottom: .width(percent: 4.0), trailing: .width(percent: 4.0)))
    
    // Location title. Hidden by default.
    lazy private var titleLabel: OctarineLabel = {
        
        let titleLabel = OctarineLabel(text: title, color: .mainDARKPURPLE, bold: true, style: .subheadline, alignment: .left, lineLimit: 1)
        titleLabel.isHidden = true
        return titleLabel
        
    }()
    
    // Location address. Hidden by default.
    lazy private var addressLabel: OctarineLabel = {
        
        let addressLabel = OctarineLabel(text: address, color: .mainDARKPURPLE, bold: false, style: .footnote, alignment: .left, lineLimit: 1)
        addressLabel.isHidden = true
        return addressLabel
        
    }()
    
    // Loading icon. Hidden by default.
    lazy private var loadingView: UIActivityIndicatorView = {
        
        let loadingView = UIActivityIndicatorView()
        loadingView.isUserInteractionEnabled = false
        loadingView.color = .white
        return loadingView
        
    }()
    
    /**
    Overrides superclass initializer to configure the cell UI.

    - Parameters:
        - style: Cell style.
        - reuseIdentifier: String used to fetch reusable cells.
    */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure the cell UI.
    private func configureCell() {
        
        // 1. Set background color.
        contentView.backgroundColor = .white
        
        // 2. Add subviews.
        contentView.addSubview(contentStack)
        
        // 3. Apply constraints.
        contentStack.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor)
        
    }
    
    /// Show the loading view.
    func startLoading() {
        
        // 1. Disable cell.
        isUserInteractionEnabled = false
        
        // 2. Update UI.
        loadingView.color = .mainDARKPURPLE
        titleLabel.textColor = .white
        addressLabel.textColor = .white
        loadingView.startAnimating()
        
        // 3. Add loading view and constraint it.
        contentView.addSubview(loadingView)
        loadingView.anchor(centerX: contentView.centerXAnchor, centerY: contentView.centerYAnchor)
        
    }
    
    /// Hide the loading view.
    func stopLoading() {
        
        // 1. Enable cell.
        isUserInteractionEnabled = true
        
        // 2. Remove loading view.
        loadingView.removeFromSuperview()
        
        // 3. Update UI.
        loadingView.stopAnimating()
        titleLabel.textColor = .mainDARKPURPLE
        addressLabel.textColor = .mainDARKPURPLE
        loadingView.color = .white
        
    }
    
}

