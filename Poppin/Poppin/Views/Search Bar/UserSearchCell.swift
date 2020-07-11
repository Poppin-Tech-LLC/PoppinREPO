//
//  UserSearchCell.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/13/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

struct UserData {
    
    var username: String
    var uid: String
    var bio: String
    var fullName: String
    
}

final class UserSearchCell: UITableViewCell {
    
    static let cellIdentifier: String = "UserSearchCell"
    
    private let cellYInset: CGFloat = .getPercentageWidth(percentage: 4.2)
    private let cellXInset: CGFloat = .getPercentageWidth(percentage: 5.5)
    private let cellInnerInset: CGFloat = .getPercentageWidth(percentage: 1)
    
    lazy private var cellTextStackView: UIStackView = {
        
        let cellTextStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 0.7)
        
        var cellTextStackView = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel])
        cellTextStackView.axis = .vertical
        cellTextStackView.alignment = .fill
        cellTextStackView.distribution = .fill
        cellTextStackView.spacing = cellTextStackViewSpacing
        
        return cellTextStackView
        
    }()
    
    lazy private(set) var fullNameLabel: UILabel = {
        
        var fullNameLabel = UILabel()
        fullNameLabel.lineBreakMode = .byTruncatingTail
        fullNameLabel.numberOfLines = 1
        fullNameLabel.textAlignment = .left
        fullNameLabel.text = "Full Name"
        fullNameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        fullNameLabel.textColor = UIColor.mainDARKPURPLE
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.heightAnchor.constraint(equalToConstant: fullNameLabel.intrinsicContentSize.height).isActive = true
        
        return fullNameLabel
        
    }()
    
    lazy private(set) var usernameLabel: UILabel = {
        
        var usernameLabel = UILabel()
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.numberOfLines = 1
        usernameLabel.textAlignment = .left
        usernameLabel.text = "@username"
        usernameLabel.font = .dynamicFont(with: "Octarine-Light", style: .caption1)
        usernameLabel.textColor = UIColor.mainDARKPURPLE
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.heightAnchor.constraint(equalToConstant: fullNameLabel.intrinsicContentSize.height).isActive = true
        
        return usernameLabel
        
    }()
    
    lazy private(set) var userImageView: BubbleImageView = {
        
        var userImageView = BubbleImageView(image: UIImage.defaultUserPicture256)
        userImageView.contentMode = .scaleAspectFill
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
        
        return userImageView
        
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
        cellTextStackView.translatesAutoresizingMaskIntoConstraints = false
        cellTextStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellYInset).isActive = true
        cellTextStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cellYInset).isActive = true
        cellTextStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellXInset).isActive = true
        
        contentView.addSubview(userImageView)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellYInset*0.65).isActive = true
        userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cellYInset*0.65).isActive = true
        userImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellXInset).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: cellTextStackView.trailingAnchor, constant: cellInnerInset).isActive = true
        
    }
    
}

