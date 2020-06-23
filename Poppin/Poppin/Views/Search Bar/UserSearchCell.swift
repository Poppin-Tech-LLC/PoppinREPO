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
    
    var userData: UserData!
    
    lazy var usernameLabel: UILabel = {
        
        var usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: "Octarine-Light", size: 15)
        usernameLabel.textColor = UIColor.mainDARKPURPLE
        return usernameLabel
        
    }()
    
    lazy var nameLabel: UILabel = {
        
        var nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Octarine-Bold", size: 13)
        nameLabel.textColor = UIColor.mainDARKPURPLE
        return nameLabel
        
    }()
    
    lazy var userImage: UIImageView = {
        
        var userImage = UIImageView()
        userImage.layer.borderColor = UIColor.mainDARKPURPLE.cgColor
        //userImage.image = .defaultUserPicture128
        userImage.contentMode = .scaleAspectFit
        userImage.heightAnchor.constraint(equalToConstant: contentView.bounds.height * 0.8).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: contentView.bounds.height * 0.8).isActive = true
        userImage.frame = CGRect(x: 0, y: 0, width: contentView.bounds.height * 0.8, height: contentView.bounds.height * 0.8)
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.bounds.height/2
        //userImage.addShadowAndRoundCorners()
        //userImage.layer.cornerRadius = userImage.bounds.height/2
        //userImage.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        //userImage.clipsToBounds = true
        return userImage
        
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImage)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentView.bounds.height * 0.1).isActive = true
        
        contentView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: contentView.bounds.height * 0.25).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: contentView.bounds.height * 0.1).isActive = true
        
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -contentView.bounds.height * 0.25).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: contentView.bounds.height * 0.1).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

