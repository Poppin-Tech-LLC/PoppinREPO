//
//  LocationSearchCell.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 11/5/19.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class LocationSearchCell: UITableViewCell {
    
    static let cellIdentifier: String = "LocationSearchCell"
    
    private let cellYInset: CGFloat = .getPercentageWidth(percentage: 4.2)
    private let cellXInset: CGFloat = .getPercentageWidth(percentage: 5.5)
    private let cellInnerInset: CGFloat = .getPercentageWidth(percentage: 1)
    
    var title: String? {
        
        didSet {
            
            locationTitleLabel.text = title
            
            if title == nil || title == "" {
                
                locationTitleLabel.isHidden = true
                
            } else {
                
                locationTitleLabel.isHidden = false
                
            }
            
        }
        
    }
    
    var subtitle: String? {
        
        didSet {
            
            locationAddressLabel.text = subtitle
            
            if subtitle == nil || subtitle == "" {
                
                locationAddressLabel.isHidden = true
                
            } else {
                
                locationAddressLabel.isHidden = false
                
            }
            
        }
        
    }
    
    lazy private var cellTextStackView: UIStackView = {
        
        let cellTextStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 0.7)
        
        var cellTextStackView = UIStackView(arrangedSubviews: [locationTitleLabel, locationAddressLabel])
        cellTextStackView.axis = .vertical
        cellTextStackView.alignment = .fill
        cellTextStackView.distribution = .fill
        cellTextStackView.spacing = cellTextStackViewSpacing
        return cellTextStackView
        
    }()
    
    lazy private var locationTitleLabel: UILabel = {
        
        var locationTitleLabel = UILabel()
        locationTitleLabel.lineBreakMode = .byTruncatingTail
        locationTitleLabel.numberOfLines = 1
        locationTitleLabel.textAlignment = .left
        locationTitleLabel.text = title
        locationTitleLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        locationTitleLabel.textColor = UIColor.mainDARKPURPLE
        locationTitleLabel.anchor(size: CGSize(width: 0.0, height: locationTitleLabel.intrinsicContentSize.height))
        return locationTitleLabel
        
    }()
    
    lazy private var locationAddressLabel: UILabel = {
        
        var locationAddressLabel = UILabel()
        locationAddressLabel.lineBreakMode = .byTruncatingTail
        locationAddressLabel.numberOfLines = 1
        locationAddressLabel.textAlignment = .left
        locationAddressLabel.text = "Address"
        locationAddressLabel.font = .dynamicFont(with: "Octarine-Light", style: .footnote)
        locationAddressLabel.textColor = UIColor.mainDARKPURPLE
        locationAddressLabel.anchor(size: CGSize(width: 0.0, height: locationTitleLabel.intrinsicContentSize.height))
        return locationAddressLabel
        
    }()
    
    lazy private var locationLoadingView: UIView = {
        
        var locationLoadingView = UIView()
        locationLoadingView.backgroundColor = .white
        
        locationLoadingView.addSubview(loadingIndicatorView)
        loadingIndicatorView.anchor(centerX: locationLoadingView.centerXAnchor, centerY: locationLoadingView.centerYAnchor)
        
        return locationLoadingView
        
    }()
    
    lazy private var loadingIndicatorView: UIActivityIndicatorView = {
        
        var loadingIndicatorView = UIActivityIndicatorView(style: .medium)
        loadingIndicatorView.color = .mainDARKPURPLE
        return loadingIndicatorView
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureCell()
        
    }
    
    private func configureCell() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(cellTextStackView)
        cellTextStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: cellYInset, left: cellXInset, bottom: cellYInset, right: cellXInset))
        
        contentView.addSubview(locationLoadingView)
        locationLoadingView.anchor(centerX: contentView.centerXAnchor, centerY: contentView.centerYAnchor)
        
    }
    
    func startLoading() {
        
        loadingIndicatorView.startAnimating()
        
        contentView.addSubview(locationLoadingView)
        locationLoadingView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: cellYInset, left: cellXInset, bottom: cellYInset, right: cellXInset))
        
    }
    
    func stopLoading() {
    
        loadingIndicatorView.stopAnimating()
        
        contentView.removeFromSuperview()
        
    }
    
}

