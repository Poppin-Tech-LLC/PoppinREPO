//
//  SwitchAccountViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 7/14/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseStorage

class SwitchAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    weak var delegate: SwitchAccountDelegate?
    
    private var storage: Storage = Storage.storage()
    
    var accounts: [UserData] = []
    
    lazy var test: UIView = {
        let test = UIView()
        test.backgroundColor = .red
        return test
    }()
    
    lazy var accountsTable: UITableView = {
        let accountsTable = UITableView()
        accountsTable.delegate = self
        accountsTable.dataSource = self
        accountsTable.register(UserSearchCell.self, forCellReuseIdentifier: UserSearchCell.cellIdentifier)
        accountsTable.register(AddOrgCell.self, forCellReuseIdentifier: AddOrgCell.cellIdentifier)
        accountsTable.layer.cornerRadius = 20
        accountsTable.isScrollEnabled = false
        return accountsTable
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainDARKPURPLE
        
        view.layer.cornerRadius = 20
        
        view.addSubview(accountsTable)
        accountsTable.translatesAutoresizingMaskIntoConstraints = false
        accountsTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        accountsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        accountsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        accountsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < accounts.count){
            let userCell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.cellIdentifier, for: indexPath) as! UserSearchCell
            let userData: UserData = accounts[indexPath.row]
            
            // Reference to an image file in Firebase Storage
            let reference = self.storage.reference().child("images/\(userData.uid)/profilepic.jpg")
            
            // Placeholder image
            let placeholderImage = UIImage.defaultUserPicture256
            
            // Load the image using SDWebImage
            userCell.userImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            
            if(indexPath.row == 0){
                userCell.contentView.backgroundColor = .mainDARKPURPLE
                userCell.usernameLabel.textColor = .white
                userCell.fullNameLabel.textColor = .white
            }
            
            userCell.usernameLabel.text = "@" + userData.username
            userCell.fullNameLabel.text = userData.fullName
            return userCell
        }else{
            let addCell = tableView.dequeueReusableCell(withIdentifier: AddOrgCell.cellIdentifier, for: indexPath) as! AddOrgCell
            return addCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return .getPercentageHeight(percentage: 10)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0){
            delegate?.closeSwitchAccount()
        }
        else{
        if(indexPath.row < accounts.count){
            DataController.addAccount(bio: MapViewController.bio, username: MapViewController.username, fullName: MapViewController.fullName, uid: MapViewController.uid)
            let bio = accounts[indexPath.row].bio
            let username = accounts[indexPath.row].username
            let fullName = accounts[indexPath.row].fullName
            let uid = accounts[indexPath.row].uid

            DataController.removeWithID(uid: uid, entity: "OtherAccounts")
            DataController.eraseAll(forEntity: "User")
            DataController.addUser(bio: bio, username: username, fullName: fullName, uid: uid, radius: Double(MapViewController.defaultMapViewRegionRadius/1000.0), latitude: Double(MapViewController.defaultMapViewCenterLocation.latitude), longitude: Double(MapViewController.defaultMapViewCenterLocation.longitude), notificationName: .editedProfileMap)
            
            delegate?.closeSwitchAccount()
            NotificationCenter.default.post(name: .editedProfile, object: nil)

        }else{
            let newUser = UserData(username: "", uid: "", bio: "", fullName: "")
            let vc = EditProfileViewController(with: newUser, newUser: true, followerCount: "0", followingCount: "0")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            delegate?.closeSwitchAccount()
        }
        }
    }
    

    
}

final class AddOrgCell: UITableViewCell {
    
    static let cellIdentifier: String = "AddOrg"
    
    private let cellYInset: CGFloat = .getPercentageWidth(percentage: 4.2)
    private let cellXInset: CGFloat = .getPercentageWidth(percentage: 5.5)
    private let cellInnerInset: CGFloat = .getPercentageWidth(percentage: 1)
    
    
    lazy private(set) var addOrgLabel: UILabel = {
        
        var addOrgLabel = UILabel()
        addOrgLabel.lineBreakMode = .byTruncatingTail
        addOrgLabel.numberOfLines = 1
        addOrgLabel.textAlignment = .left
        addOrgLabel.text = "Create a new Org"
        addOrgLabel.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        addOrgLabel.textColor = UIColor.mainDARKPURPLE
        
        addOrgLabel.translatesAutoresizingMaskIntoConstraints = false
        addOrgLabel.heightAnchor.constraint(equalToConstant: addOrgLabel.intrinsicContentSize.height).isActive = true
        
        return addOrgLabel
        
    }()
    
    
    lazy private(set) var plusView: BubbleImageView = {
        let plus = UIImage(systemSymbol: .plus, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .medium)).withTintColor(UIColor.mainDARKPURPLE, renderingMode: .alwaysOriginal)
        var plusView = BubbleImageView(image: plus)
        plusView.contentMode = .scaleAspectFill
        
        plusView.translatesAutoresizingMaskIntoConstraints = false
        plusView.widthAnchor.constraint(equalTo: plusView.heightAnchor).isActive = true
        
        return plusView
        
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
        
        contentView.addSubview(addOrgLabel)
        addOrgLabel.translatesAutoresizingMaskIntoConstraints = false
        addOrgLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        addOrgLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellXInset).isActive = true
        
        contentView.addSubview(plusView)
        plusView.translatesAutoresizingMaskIntoConstraints = false
        plusView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellYInset*1.5).isActive = true
        plusView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -cellYInset*1.5).isActive = true
        plusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -(cellXInset + (cellYInset * 0.85))).isActive = true
        plusView.leadingAnchor.constraint(equalTo: addOrgLabel.trailingAnchor, constant: cellInnerInset).isActive = true
        
    }
    
}

