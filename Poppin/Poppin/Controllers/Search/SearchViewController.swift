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

enum SearchType: String {
    
    case Following = "Following"
    case Followers = "Followers"
    case Main = "Main"
    case Default = "Default"
    
}

final class SearchViewController: UIViewController {
    
    private let searchVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let searchHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    
    private var searchType: SearchType = .Default
    private var uid: String?
    private var users: [UserData] = []
    private var filteredUsers: [UserData] = []
    private var storage: Storage = Storage.storage()
    
    private var isDisplayingAllCells: Bool = false
    
    lazy private var fadeView: UIView = {
        
        var fadeView = UIView()
        fadeView.backgroundColor = .mainDARKPURPLE
        fadeView.addShadowAndRoundCorners(cornerRadius: 0.0, shadowColor: .mainDARKPURPLE, shadowOpacity: 0.65, shadowRadius: 12, topRightMask: false, topLeftMask: false, bottomRightMask: true, bottomLeftMask: true)
        return fadeView
        
    }()
    
    lazy private var searchScrollView: UIScrollView = {
        
        let searchStackView = UIStackView(arrangedSubviews: [searchTableView, loadingIndicatorView])
        searchStackView.axis = .vertical
        searchStackView.alignment = .fill
        searchStackView.distribution = .fill
        searchStackView.spacing = searchVerticalEdgeInset
        
        var searchScrollView = UIScrollView()
        searchScrollView.alwaysBounceVertical = true
        searchScrollView.showsVerticalScrollIndicator = false
        searchScrollView.delaysContentTouches = false
        searchScrollView.contentInset = UIEdgeInsets(top: searchVerticalEdgeInset/2, left: 0.0, bottom: searchVerticalEdgeInset, right: 0.0)
        
        searchScrollView.addSubview(searchStackView)
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.topAnchor.constraint(equalTo: searchScrollView.topAnchor).isActive = true
        searchStackView.bottomAnchor.constraint(equalTo: searchScrollView.bottomAnchor).isActive = true
        searchStackView.leadingAnchor.constraint(equalTo: searchScrollView.leadingAnchor).isActive = true
        searchStackView.trailingAnchor.constraint(equalTo: searchScrollView.trailingAnchor).isActive = true
        searchStackView.widthAnchor.constraint(equalTo: searchScrollView.widthAnchor).isActive = true
        
        return searchScrollView
        
    }()
    
    lazy private var loadingIndicatorView: UIActivityIndicatorView = {
        
        var loadingIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loadingIndicatorView.color = .white
        loadingIndicatorView.hidesWhenStopped = true
        return loadingIndicatorView
        
    }()
    
    lazy private var searchTableView: SelfSizedTableView = {
        
        var searchTableView = SelfSizedTableView()
        searchTableView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        searchTableView.isScrollEnabled = false
        searchTableView.clipsToBounds = true
        searchTableView.separatorInset = .zero
        searchTableView.separatorColor = UIColor.mainDARKPURPLE.withAlphaComponent(0.5)
        searchTableView.backgroundColor = .mainDARKPURPLE
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = UITableView.automaticDimension
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UserSearchCell.self, forCellReuseIdentifier: UserSearchCell.cellIdentifier)
        
        return searchTableView
        
    }()
    
    /*lazy private var purpleView: UIView = {
        
        let purpleView = UIView()
        purpleView.backgroundColor = .white
        purpleView.addShadowAndRoundCorners(shadowOffset: CGSize(width: 5.0, height: 5.0))
        return purpleView
        
    }()
    
    lazy private var followingLabel: UILabel = {
        
        let followingLabel = UILabel()
        followingLabel.text = "following"
        followingLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 18.0, maxSize: 21.0))
        followingLabel.textColor = UIColor.mainDARKPURPLE
        followingLabel.textAlignment = .center
        return followingLabel
        
    }()
    
    lazy private var followerLabel: UILabel = {
        
        let followerLabel = UILabel()
        followerLabel.text = "followers"
        followerLabel.font = UIFont(name: "Octarine-Bold", size: .getWidthFitSize(minSize: 18.0, maxSize: 21.0))
        followerLabel.textColor = UIColor.mainDARKPURPLE
        followerLabel.textAlignment = .center
        return followerLabel
        
    }()
    
    lazy private var backButton: ImageBubbleButton = {
        
        let purpleArrow = UIImage(systemName: "arrow.left.circle.fill")!.withTintColor(UIColor.mainDARKPURPLE)
        let backButton = ImageBubbleButton(bouncyButtonImage: purpleArrow)
        backButton.contentMode = .scaleToFill
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        backButton.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        return backButton
        
    }()*/
    
    lazy private var searchTopStackView: UIView = {
        
        let cancelButton = BouncyButton(bouncyButtonImage: nil)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        cancelButton.addTarget(self, action: #selector(closeSearchBar), for: .touchUpInside)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.widthAnchor.constraint(equalToConstant: cancelButton.intrinsicContentSize.width).isActive = true
        
        var searchTopStackView = UIStackView(arrangedSubviews: [searchBar, cancelButton])
        searchTopStackView.axis = .horizontal
        searchTopStackView.alignment = .fill
        searchTopStackView.spacing = searchHorizontalEdgeInset
        
        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
        searchTopStackView.widthAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarWidth).isActive = true
        searchTopStackView.heightAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarHeight).isActive = true
        
        return searchTopStackView
        
    }()
    
    lazy private var searchBar: UISearchBar = {
        
        let searchBar = SearchBar(tintColor: UIColor.white)
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        return searchBar
        
    }()
    
    init(searchType: SearchType) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.searchType = searchType
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        /* FOR TRIAL PURPOSES */
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    /*override func viewDidAppear(_ animated: Bool) {
        
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
    }*/
    
    
    /*@objc func presentSearchController() {
        
        searchController.isActive = true
        
        DispatchQueue.main.async {
            
            self.searchController.searchBar.becomeFirstResponder()
            
        }
        
    }*/
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /*NotificationCenter.default.addObserver(self, selector: #selector(presentSearchController), name: NSNotification.Name(rawValue: "myNotification"), object: nil)
        
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
            
        }*/
        
        view.backgroundColor = .mainDARKPURPLE
        
        view.addSubview(searchTopStackView)
        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
        searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchVerticalEdgeInset).isActive = true
        searchTopStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(fadeView)
        view.sendSubviewToBack(fadeView)
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        fadeView.topAnchor.constraint(equalTo: searchTopStackView.topAnchor).isActive = true
        fadeView.bottomAnchor.constraint(equalTo: searchTopStackView.bottomAnchor, constant: searchVerticalEdgeInset*0.33).isActive = true
        fadeView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fadeView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(searchScrollView)
        view.sendSubviewToBack(searchScrollView)
        searchScrollView.translatesAutoresizingMaskIntoConstraints = false
        searchScrollView.topAnchor.constraint(equalTo: searchTopStackView.bottomAnchor, constant: searchVerticalEdgeInset/2).isActive = true
        searchScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchScrollView.leadingAnchor.constraint(equalTo: searchTopStackView.leadingAnchor).isActive = true
        searchScrollView.trailingAnchor.constraint(equalTo: searchTopStackView.trailingAnchor).isActive = true
        
        fetchUsers()
        
    }
    
    /*override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
    }*/
    
    /*func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.dismiss(animated: true, completion: nil)
        
    }*/
    
    
    @objc func closeSearchBar() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func fetchUsers() {
        
        loadingIndicatorView.startAnimating()
        
        let ref = Database.database().reference(withPath:"users")
        
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
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
                            let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                            self.users.append(userToAdd)
                
                        }
                    }
                }
                
                self.isDisplayingAllCells = true
                self.searchTableView.reloadData()
                
            }
        })
        
    }
    
    /*public func getFollowers() {
        
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
    }*/
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchType == .Main {
            
            if searchBar.text != "" { return filteredUsers.count }
            
        }/* else if searchType == "showFollowers" || searchType == "showFollowing" {
            
            return users!.count
            
        }*/
        
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.cellIdentifier, for: indexPath) as! UserSearchCell
        var userData: UserData?
        
        if searchType == .Main {
            
            if searchBar.text != "" {
                
                userData = filteredUsers[indexPath.row]
                
            } else {
                
                userData = users[indexPath.row]
                
            }
            
        }/* else if searchType == "showFollowers" || searchType == "showFollowing" {
            
            user = users![indexPath.row]
            
        }*/
        
        if let userData = userData {
            
            // Reference to an image file in Firebase Storage
            let reference = self.storage.reference().child("images/\(userData.uid)/profilepic.jpg")
            
            // Placeholder image
            let placeholderImage = UIImage.defaultUserPicture256
            
            // Load the image using SDWebImage
            userCell.userImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            
            userCell.usernameLabel.text = "@" + userData.username
            userCell.fullNameLabel.text = userData.fullName
            
        }
        
        return userCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        let profileVC = ProfileViewController()
        
        if searchType == .Main {
            
            ref.child("users/\(uid)/following").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(self.filteredUsers[indexPath.row].uid){
                    
                    profileVC.followButton.setTitle("following", for: .normal)
                    profileVC.followButton.setTitleColor(.mainDARKPURPLE, for: .normal)
                    profileVC.followButton.backgroundColor = .white
                    
                } else {
                    
                    profileVC.followButton.setTitle("follow", for: .normal)
                    profileVC.followButton.setTitleColor(.white, for: .normal)
                    profileVC.followButton.backgroundColor = .mainDARKPURPLE
                    
                }
                
            })
            
            profileVC.nameLabel.text = filteredUsers[indexPath.row].fullName
            profileVC.usernameLabel.text = "@" + filteredUsers[indexPath.row].username
            profileVC.bioLabel.text = filteredUsers[indexPath.row].bio
            profileVC.uid = filteredUsers[indexPath.row].uid
            
            //vc.userImage.image = filteredUser![indexPath.row].userImage.image
            //            let transition = CATransition()
            //            transition.duration = 0.5
            //            transition.type = CATransitionType.moveIn
            //            transition.subtype = CATransitionSubtype.fromRight
            //            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            //            view.window!.layer.add(transition, forKey: kCATransition)
            // vc.modalTransitionStyle = .flipHorizontal
            
            navigationController?.pushViewController(profileVC, animated: true)
            
        }/* else if (searchType == "showFollowers" || searchType == "showFollowing"){
            
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
            
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        loadingIndicatorView.stopAnimating()
        
        if isDisplayingAllCells {
            
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                cell.alpha = 1
                
            })
            
            if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last, lastVisibleIndexPath == indexPath {
                
                isDisplayingAllCells = false
                
            }
            
        }
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        loadingIndicatorView.startAnimating()
        filterUsers(for: searchText)
        
    }
    
    private func filterUsers(for searchText: String) {
        
        filteredUsers = users.filter { user in
            
            return user.username.lowercased().contains(searchText.lowercased()) || user.fullName.lowercased().contains(searchText.lowercased())
            
        }
        
        searchTableView.reloadData()
        
    }
    
}

final class SelfSizedTableView: UITableView {
    
    override var contentSize: CGSize {
        
        didSet {
            
            invalidateIntrinsicContentSize()
            
        }
        
    }

    override var intrinsicContentSize: CGSize {
        
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        
    }

}
