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
    
    private let cellYInset: CGFloat = .getPercentageWidth(percentage: 4)
    private let cellInnerSet: CGFloat = .getPercentageWidth(percentage: 1)
    private let cellXInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    lazy private var cellTextStackView: UIStackView = {
        
        let cellTextStackViewSpacing: CGFloat = .getPercentageWidth(percentage: 0.5)
        
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
        fullNameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        fullNameLabel.textColor = UIColor.mainDARKPURPLE
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.heightAnchor.constraint(equalToConstant: fullNameLabel.intrinsicContentSize.height + cellInnerSet).isActive = true
        
        return fullNameLabel
        
    }()
    
    lazy private(set) var usernameLabel: UILabel = {
        
        var usernameLabel = UILabel()
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.numberOfLines = 1
        usernameLabel.textAlignment = .left
        usernameLabel.text = "@username"
        usernameLabel.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        usernameLabel.textColor = UIColor.mainDARKPURPLE
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.heightAnchor.constraint(equalToConstant: fullNameLabel.intrinsicContentSize.height + cellInnerSet).isActive = true
        
        return usernameLabel
        
    }()
    
    lazy private(set) var userImageView: BubbleImageView = {
        
        var userImageView = BubbleImageView(image: UIImage.defaultUserPicture256)
        userImageView.contentMode = .scaleAspectFill
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.widthAnchor.constraint(equalTo: userImageView.heightAnchor).isActive = true
        
        return userImageView
        
    }()
    
    //    lazy var userImageHolder: UIImageView = {
    //        var userImageHolder = UIImageView()
    //        userImageHolder.layer.borderColor = UIColor.white.cgColor
    //        //userImage.image = .defaultUserPicture128
    //        userImageHolder.contentMode = .scaleAspectFit
    //        userImageHolder.frame = CGRect(x: 0, y: 0, width: contentView.bounds.height * 0.8, height: contentView.bounds.height * 0.8)
    //        //userImageHolder.layer.cornerRadius = userImage.bounds.height/2
    //
    //        //userImage.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    //        //userImage.clipsToBounds = true
    //        return userImageHolder
    //    }()
    
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
        userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellYInset).isActive = true
        userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cellYInset).isActive = true
        userImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -cellXInset).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: cellTextStackView.trailingAnchor, constant: cellInnerSet).isActive = true
        
    }
    
}

