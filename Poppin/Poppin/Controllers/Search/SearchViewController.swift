//
//  SearchViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/14/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
import FirebaseAuth

final class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let searchHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    let searchController = UISearchController(searchResultsController: nil)
    var cellIdentifier = "cell"
    var searchType: String?
    var uid: String?
    
    var storage: Storage?
    
    lazy var searchTable: UITableView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        var searchTable = UITableView(frame: self.view.bounds)
        searchTable.register(UserSearchCell.self, forCellReuseIdentifier: cellIdentifier)
        searchTable.delegate = self
        searchTable.dataSource = self
        return searchTable
        
    }()
    
    lazy var purpleView: UIView = {
        
        let purpleView = UIView()
        purpleView.backgroundColor = .white
        // purpleView.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return purpleView
        
    }()
    
    lazy var followingLabel: UILabel = {
        
        let followingLabel = UILabel()
        followingLabel.text = "following"
        followingLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 18.0, maxSize: 21.0))
        followingLabel.textColor = UIColor.mainDARKPURPLE
        followingLabel.textAlignment = .center
        return followingLabel
        
    }()
    
    lazy var followerLabel: UILabel = {
        
        let followerLabel = UILabel()
        followerLabel.text = "followers"
        followerLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 18.0, maxSize: 21.0))
        followerLabel.textColor = UIColor.mainDARKPURPLE
        followerLabel.textAlignment = .center
        return followerLabel
        
    }()
    
    lazy var backButton: ImageBubbleButton = {
        
        let purpleArrow = UIImage(systemName: "arrow.left.circle.fill")!.withTintColor(UIColor.mainDARKPURPLE)
        let backButton = ImageBubbleButton(bouncyButtonImage: purpleArrow)
        backButton.contentMode = .scaleToFill
        // backButton.setTitle("Back", for: .normal)
        //backButton.setTitleColor(.newPurple, for: .normal)
        backButton.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        return backButton
        
    }()
    
    var users: [UserSearchCell]?
    var filteredUser: [UserSearchCell]?
    
    //
    //    lazy private var searchBar: UISearchBar = {
    //        let searchBar = NewSearchBar(tintColor: UIColor.darkGray)
    //        searchBar.becomeFirstResponder()
    //        searchBar.delegate = self
    //        return searchBar
    //    }()
    //
    //    lazy private var searchTopStackView: UIView = {
    //
    //        let newsearchBar = NewSearchBar(tintColor: UIColor.darkGray)
    //        newsearchBar.becomeFirstResponder()
    //        newsearchBar.delegate = self
    //
    //
    //        let cancelButton = BouncyButton(bouncyButtonImage: nil)
    //        cancelButton.setTitle("Cancel", for: .normal)
    //        cancelButton.titleLabel!.textAlignment = .center
    //        cancelButton.setTitleColor(.darkGray, for: .normal)
    //        cancelButton.titleLabel!.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 15.0, maxSize: 20.0))
    //        cancelButton.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
    //
    //        cancelButton.translatesAutoresizingMaskIntoConstraints = false
    //        cancelButton.widthAnchor.constraint(equalToConstant: cancelButton.intrinsicContentSize.width).isActive = true
    //
    //        var searchTopStackView = UIView()
    //        // searchTopStackView.axis = .horizontal
    //        //searchTopStackView.alignment = .fill
    //        //searchTopStackView.spacing = searchHorizontalEdgeInset
    //
    //        searchTopStackView.addSubview(searchController.searchBar)
    //
    //        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
    //        searchTopStackView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 99)).isActive = true
    //        searchTopStackView.heightAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 11)).isActive = true
    //
    //        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width * 0.9, height: view.bounds.height * 0.05)
    //
    //
    //        //       searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    //        //        searchController.searchBar.widthAnchor.constraint(equalTo: searchTopStackView.widthAnchor).isActive = true
    //        //         searchController.searchBar.heightAnchor.constraint(equalTo: searchTopStackView.heightAnchor).isActive = true
    //        //
    //        return searchTopStackView
    //
    //    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if(searchType == "searchUsers"){
            
            self.present(searchController, animated: true, completion: nil)
            //searchController.definesPresentationContext = true
            
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            
            searchController.searchBar.delegate = self
            searchController.isActive = true
            
            searchTable.tableHeaderView = searchController.searchBar
            searchController.searchBar.tintColor = UIColor.white
            searchController.searchBar.barTintColor = UIColor.white
            searchController.definesPresentationContext = true
            
            DispatchQueue.main.async {
                self.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
    
    
    @objc func presentSearchController() {
        
        searchController.isActive = true
        
        DispatchQueue.main.async {
            
            self.searchController.searchBar.becomeFirstResponder()
            
        }
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentSearchController), name: NSNotification.Name(rawValue: "myNotification"), object: nil)
        
        storage = Storage.storage()
        users = []
        filteredUser = []
        
        if(searchType == "searchUsers") {
            
            getUsers()

            view.addSubview(searchTable)
            searchTable.translatesAutoresizingMaskIntoConstraints = false
            searchTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            searchTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            searchTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else if(searchType == "showFollowers") {
            
            getFollowers()
            
            view.addSubview(purpleView)
            purpleView.translatesAutoresizingMaskIntoConstraints = false
            purpleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            purpleView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
            purpleView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.09).isActive = true
            
            purpleView.addSubview(followerLabel)
            followerLabel.translatesAutoresizingMaskIntoConstraints = false
            followerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            followerLabel.bottomAnchor.constraint(equalTo: purpleView.bottomAnchor, constant: -view.bounds.height * 0.01).isActive = true
            
            purpleView.addSubview(backButton)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.height * 0.01).isActive = true
            backButton.bottomAnchor.constraint(equalTo: purpleView.bottomAnchor, constant: -view.bounds.height * 0.01).isActive = true
            backButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
            backButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
            
            view.addSubview(searchTable)
            searchTable.translatesAutoresizingMaskIntoConstraints = false
            searchTable.topAnchor.constraint(equalTo: purpleView.bottomAnchor).isActive = true
            searchTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            searchTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else if(searchType == "showFollowing") {
            
            getFollowing()
            
            view.addSubview(purpleView)
            purpleView.translatesAutoresizingMaskIntoConstraints = false
            purpleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            purpleView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
            purpleView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.09).isActive = true
            
            purpleView.addSubview(followingLabel)
            followingLabel.translatesAutoresizingMaskIntoConstraints = false
            followingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            followingLabel.bottomAnchor.constraint(equalTo: purpleView.bottomAnchor, constant: -view.bounds.height * 0.01).isActive = true
            
            purpleView.addSubview(backButton)
            backButton.translatesAutoresizingMaskIntoConstraints = false
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.bounds.height * 0.01).isActive = true
            backButton.bottomAnchor.constraint(equalTo: purpleView.bottomAnchor, constant: -view.bounds.height * 0.01).isActive = true
            backButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
            backButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.04).isActive = true
            
            view.addSubview(searchTable)
            searchTable.translatesAutoresizingMaskIntoConstraints = false
            searchTable.topAnchor.constraint(equalTo: purpleView.bottomAnchor).isActive = true
            searchTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            searchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            searchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            searchTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
        }
        
        view.backgroundColor = .white
        
        //        view.addSubview(searchTopStackView)
        //        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
        //        searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchVerticalEdgeInset).isActive = true
        //        searchTopStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc func closeSearchBar() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    public func getUsers() {
        
        let ref = Database.database().reference(withPath:"users")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Printing the child count
            // Checking if the reference has some values
            if snapshot.childrenCount > 0 {
                // Go through every child
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    if(Auth.auth().currentUser!.uid != data.key){
                        if let dat = data.value as? [String: Any] {
                            
                            let userName = dat["username"] as? String ?? ""
                            let uid = data.key
                            let bio = dat["bio"] as? String ?? ""
                            let fullName = dat["fullName"] as? String ?? ""
                            let userToAdd = UserSearchCell()
                            
                            userToAdd.userData = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                            self.users?.append(userToAdd)
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                // Background Thread
                                
                                DispatchQueue.main.async {
                                    
                                    self.searchTable.reloadData()
                                    
                                }
                            }
                        }
                    }
                }
            }
        })
        
    }
    
    public func getFollowers() {
        
        let ref = Database.database().reference()
        
        ref.child("users/\(uid!)/followers").observeSingleEvent(of: .value, with: { (snapshot) in
            // Printing the child count
            // Checking if the reference has some values
            
            if snapshot.childrenCount > 0 {
                
                let idArray: [String]
                let idDict = snapshot.value as! [String : AnyObject]
                idArray = Array(idDict.keys)
                
                for userId in idArray {
                    // Go through every child
                    //                  for data in snapshot.children.allObjects as! [DataSnapshot] {
                    //                    let userId = data.key
                    //                    print("USERID " + userId)
                    if(userId != self.uid){
                        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dat = snapshot.value as? [String: Any] {
                                
                                
                                let userName = dat["username"] as? String ?? ""
                                let userID = snapshot.key
                                let bio = dat["bio"] as? String ?? ""
                                let fullName = dat["fullName"] as? String ?? ""
                                let userToAdd = UserSearchCell()
                                print("Username " + userID)
                                userToAdd.userData = UserData(username: userName, uid: userID, bio: bio, fullName: fullName)
                                self.users?.append(userToAdd)
                                
                                print(userToAdd.userData.username)
                                
                            }
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                // Background Thread
                                
                                DispatchQueue.main.async {
                                    // Run UI Updates
                                    print("RELOADIN DATA")
                                    self.searchTable.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    public func getFollowing() {
        
        let ref = Database.database().reference()
        
        ref.child("users/\(uid!)/following").observeSingleEvent(of: .value, with: { (snapshot) in
            // Printing the child count
            // Checking if the reference has some values
            
            if snapshot.childrenCount > 0 {
                
                let idArray: [String]
                let idDict = snapshot.value as! [String : AnyObject]
                idArray = Array(idDict.keys)
                
                for userId in idArray {
                    // Go through every child
                    //                  for data in snapshot.children.allObjects as! [DataSnapshot] {
                    //                    let userId = data.key
                    //                    print("USERID " + userId)
                    if(userId != self.uid){
                        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let dat = snapshot.value as? [String: Any] {
                                
                                let userName = dat["username"] as? String ?? ""
                                let userID = snapshot.key
                                let bio = dat["bio"] as? String ?? ""
                                let fullName = dat["fullName"] as? String ?? ""
                                let userToAdd = UserSearchCell()
                                print("Username " + userID)
                                userToAdd.userData = UserData(username: userName, uid: userID, bio: bio, fullName: fullName)
                                self.users?.append(userToAdd)
                                
                                print(userToAdd.userData.username)
                                
                            }
                            
                            DispatchQueue.global(qos: .background).async {
                                
                                // Background Thread
                                
                                DispatchQueue.main.async {
                                    // Run UI Updates
                                    print("RELOADIN DATA")
                                    self.searchTable.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchType == "searchUsers"){
            if !searchController.isActive || searchController.searchBar.text == "" {
                return 0
            }
            if searchController.isActive && searchController.searchBar.text != "" {
                return filteredUser!.count
            }
        }
        else if(searchType == "showFollowers" || searchType == "showFollowing"){
            return users!.count
        }
        return users!.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserSearchCell
        var user: UserSearchCell
        user = UserSearchCell()
        
        if(searchType == "searchUsers"){
            if searchController.isActive && searchController.searchBar.text != "" {
                
                user = filteredUser![indexPath.row]
            } else {
                user = users![indexPath.row]
            }
        }
        else if (searchType == "showFollowers" || searchType == "showFollowing"){
            user = users![indexPath.row]
            
        }
        
        // Reference to an image file in Firebase Storage
        let reference = (self.storage?.reference().child("images/\(user.userData.uid)/profilepic.jpg"))!
        
        // Placeholder image
        let placeholderImage = UIImage.defaultUserPicture256
        
        // Load the image using SDWebImage
        //cell.userImageHolder.sd_setImage(with: reference, placeholderImage: placeholderImage)
        cell.userImage.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        cell.usernameLabel.text = "@" + user.userData.username
        cell.nameLabel.text = user.userData.fullName
        //cell.userImage.image = user.userData.image
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        let vc = ProfileViewController()
        
        if(searchType == "searchUsers"){
            ref.child("users/\(uid)/following").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(self.filteredUser![indexPath.row].userData.uid){
                    
                    vc.followButton.setTitle("following", for: .normal)
                    vc.followButton.setTitleColor(.mainDARKPURPLE, for: .normal)
                    vc.followButton.backgroundColor = .white
                    
                }else{
                    
                    vc.followButton.setTitle("follow", for: .normal)
                    vc.followButton.setTitleColor(.white, for: .normal)
                    vc.followButton.backgroundColor = .mainDARKPURPLE
                    
                }
                
            })
            
            vc.modalPresentationStyle = .fullScreen
            vc.nameLabel.text = filteredUser![indexPath.row].userData.fullName
            vc.usernameLabel.text = "@" + filteredUser![indexPath.row].userData.username
            vc.bioLabel.text = filteredUser![indexPath.row].userData.bio
            vc.uid = filteredUser![indexPath.row].userData.uid
            //vc.userImage.image = filteredUser![indexPath.row].userImage.image
            //            let transition = CATransition()
            //            transition.duration = 0.5
            //            transition.type = CATransitionType.moveIn
            //            transition.subtype = CATransitionSubtype.fromRight
            //            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            //            view.window!.layer.add(transition, forKey: kCATransition)
            // vc.modalTransitionStyle = .flipHorizontal
            self.dismiss(animated: true, completion: nil)
            self.present(vc, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
            
        } else if (searchType == "showFollowers" || searchType == "showFollowing"){
            
            ref.child("users/\(uid)/following").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(self.users![indexPath.row].userData.uid){
                    
                    vc.followButton.setTitle("following", for: .normal)
                    vc.followButton.setTitleColor(.mainDARKPURPLE, for: .normal)
                    vc.followButton.backgroundColor = .white
                    
                }else{
                    
                    vc.followButton.setTitle("follow", for: .normal)
                    vc.followButton.setTitleColor(.white, for: .normal)
                    vc.followButton.backgroundColor = .mainDARKPURPLE
                    
                }
                
            })
            vc.modalPresentationStyle = .fullScreen
            vc.nameLabel.text = users![indexPath.row].userData.fullName
            vc.usernameLabel.text = "@" + users![indexPath.row].userData.username
            vc.bioLabel.text = users![indexPath.row].userData.bio
            vc.uid = users![indexPath.row].userData.uid
            //vc.userImage.image = users![indexPath.row].userImage.image
            //self.dismiss(animated: true, completion: nil)
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // TO-DO: Implement here
        filterUsers(for: searchController.searchBar.text ?? "")
        
        
    }
    
    private func filterUsers(for searchText: String) {
        filteredUser = users?.filter { user in
            return user.userData.username.lowercased().contains(searchText.lowercased()) || user.userData.fullName.lowercased().contains(searchText.lowercased())
        }
        searchTable.reloadData()
    }
    
}
