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
    private var userID: String = Auth.auth().currentUser!.uid
    private var users: [UserData] = []
    private var filteredUsers: [UserData] = []
    private var storage: Storage = Storage.storage()
    private var isFetchingUsers: Bool = false
    
    lazy private var backgroundView: UIView = {
        
        let backgroundImageView = UIImageView(image: UIImage.appBackground)
        backgroundImageView.contentMode = .scaleAspectFill
        
        var backgroundView = UIView()
        backgroundView.backgroundColor = .poppinLIGHTGOLD
        
        backgroundView.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        
        return backgroundView
        
    }()
    
    lazy private var searchTablePlaceholderView: UIView = {
        
        let placeholderImageView = UIImageView(image: UIImage(systemSymbol: .nosign, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .bold)).withTintColor(UIColor.white, renderingMode: .alwaysOriginal))
        placeholderImageView.contentMode = .scaleAspectFit
        
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.heightAnchor.constraint(equalTo: placeholderImageView.widthAnchor).isActive = true
        
        let placeholderLabel = UILabel()
        placeholderLabel.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        placeholderLabel.text = "No Results Found..."
        placeholderLabel.textColor = .white
        placeholderLabel.textAlignment = .center
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.heightAnchor.constraint(equalToConstant: placeholderLabel.intrinsicContentSize.height).isActive = true
        
        var searchTablePlaceholderView = UIView()
        searchTablePlaceholderView.backgroundColor = .clear
        searchTablePlaceholderView.isHidden = true
        
        searchTablePlaceholderView.addSubview(placeholderImageView)
        placeholderImageView.bottomAnchor.constraint(equalTo: searchTablePlaceholderView.centerYAnchor, constant: -searchVerticalEdgeInset/4).isActive = true
        placeholderImageView.centerXAnchor.constraint(equalTo: searchTablePlaceholderView.centerXAnchor).isActive = true
        placeholderImageView.widthAnchor.constraint(equalTo: searchTablePlaceholderView.widthAnchor, multiplier: 0.17).isActive = true
        
        searchTablePlaceholderView.addSubview(placeholderLabel)
        placeholderLabel.topAnchor.constraint(equalTo: searchTablePlaceholderView.centerYAnchor, constant: searchVerticalEdgeInset/4).isActive = true
        placeholderLabel.leadingAnchor.constraint(equalTo: searchTablePlaceholderView.leadingAnchor).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: searchTablePlaceholderView.trailingAnchor).isActive = true
        
        return searchTablePlaceholderView
        
    }()
    
    lazy private var searchScrollView: UIScrollView = {
        
        var searchScrollView = UIScrollView()
        searchScrollView.alwaysBounceVertical = true
        searchScrollView.showsVerticalScrollIndicator = false
        searchScrollView.delaysContentTouches = false
        searchScrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: searchVerticalEdgeInset, right: 0.0)
        
        searchScrollView.addSubview(searchTableView)
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.topAnchor.constraint(equalTo: searchScrollView.topAnchor).isActive = true
        searchTableView.bottomAnchor.constraint(equalTo: searchScrollView.bottomAnchor).isActive = true
        searchTableView.leadingAnchor.constraint(equalTo: searchScrollView.leadingAnchor).isActive = true
        searchTableView.trailingAnchor.constraint(equalTo: searchScrollView.trailingAnchor).isActive = true
        searchTableView.widthAnchor.constraint(equalTo: searchScrollView.widthAnchor).isActive = true
        
        return searchScrollView
        
    }()
    
    lazy private var loadingIndicatorView: UIActivityIndicatorView = {
        
        var loadingIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
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
        searchTableView.separatorColor = UIColor.mainDARKPURPLE
        searchTableView.backgroundColor = .white
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = UITableView.automaticDimension
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(UserSearchCell.self, forCellReuseIdentifier: UserSearchCell.cellIdentifier)
        
        return searchTableView
        
    }()
    /*
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
        
        if searchType == .Main || searchType == .Default {
            
            cancelButton.addTarget(self, action: #selector(dismissSearchViewController), for: .touchUpInside)
            
        } else {
            
            cancelButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
            
        }
        
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
        
        if searchType == .Main || searchType == .Default {
            
            searchBar.becomeFirstResponder()
            
        }
        
        searchBar.delegate = self
        return searchBar
        
    }()
    
    init(searchType: SearchType, userID: String?) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.searchType = searchType
        
        if let userID = userID { self.userID = userID }
        
        configureController()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        
        configureController()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        /* FOR TRIAL PURPOSES */
        
        configureController()
        
    }
    
    private func configureController() {
        
        switch searchType {
            
        case .Followers: fetchFollowers()
        case .Following: fetchFollowing()
        case .Main, .Default: fetchUsers()
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .poppinLIGHTGOLD
        
        view.addSubview(searchTopStackView)
        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
        searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchVerticalEdgeInset).isActive = true
        searchTopStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(searchScrollView)
        view.sendSubviewToBack(searchScrollView)
        searchScrollView.translatesAutoresizingMaskIntoConstraints = false
        searchScrollView.topAnchor.constraint(equalTo: searchTopStackView.bottomAnchor, constant: searchVerticalEdgeInset).isActive = true
        searchScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchScrollView.leadingAnchor.constraint(equalTo: searchTopStackView.leadingAnchor).isActive = true
        searchScrollView.trailingAnchor.constraint(equalTo: searchTopStackView.trailingAnchor).isActive = true
        
        view.addSubview(loadingIndicatorView)
        view.sendSubviewToBack(loadingIndicatorView)
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorView.topAnchor.constraint(equalTo: searchTopStackView.bottomAnchor).isActive = true
        loadingIndicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -searchVerticalEdgeInset).isActive = true
        loadingIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: searchHorizontalEdgeInset).isActive = true
        loadingIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -searchHorizontalEdgeInset).isActive = true
        
        view.addSubview(searchTablePlaceholderView)
        view.sendSubviewToBack(searchTablePlaceholderView)
        searchTablePlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        searchTablePlaceholderView.topAnchor.constraint(equalTo: searchTopStackView.bottomAnchor).isActive = true
        searchTablePlaceholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        searchTablePlaceholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: searchHorizontalEdgeInset).isActive = true
        searchTablePlaceholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -searchHorizontalEdgeInset).isActive = true
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if searchType == .Followers || searchType == .Following {
            
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    @objc private func dismissSearchViewController() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func transitionToPreviousPage() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    private func fetchUsers() {
        
        isFetchingUsers = true
        searchTablePlaceholderView.isHidden = true
        loadingIndicatorView.startAnimating()
        
        let ref = Database.database().reference(withPath:"users")
        
        ref.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            // Printing the child count
            // Checking if the reference has some values
            if snapshot.childrenCount > 0 {
                
                // Go through every child
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if Auth.auth().currentUser!.uid != data.key, let dat = data.value as? [String: Any] {
                        
                        let userName = dat["username"] as? String ?? ""
                        let uid = data.key
                        let bio = dat["bio"] as? String ?? ""
                        let fullName = dat["fullName"] as? String ?? ""
                        let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                        self.users.append(userToAdd)
                
                    }
                }
                
                self.filteredUsers = self.users
                
            }
            
            self.loadingIndicatorView.stopAnimating()
            self.searchTablePlaceholderView.isHidden = false
            self.isFetchingUsers = false
            
        })
        
    }
    
    private func fetchFollowers() {
        
        isFetchingUsers = true
        searchTablePlaceholderView.isHidden = true
        loadingIndicatorView.startAnimating()
        
        let ref = Database.database().reference()
        
        ref.child("users/\(userID)/followers").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            // Printing the child count
            // Checking if the reference has some values
            if snapshot.childrenCount > 0, let uidDic = snapshot.value as? [String : AnyObject] {
                
                let userIDs: [String] = Array(uidDic.keys)
                
                if userIDs.isEmpty || (userIDs.count == 1 && userIDs[0] == self.userID) {
                    
                    self.loadingIndicatorView.stopAnimating()
                    self.searchTablePlaceholderView.isHidden = false
                    self.isFetchingUsers = false
                    
                    return
                    
                }
                
                let group = DispatchGroup()
                
                for userId in userIDs {
                    
                    // Go through every child
                    if userId != self.userID {
                        
                        group.enter()
                        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                            
                            guard let self = self else { return }
                            
                            if let data = snapshot.value as? [String: Any] {
                                
                                let userName = data["username"] as? String ?? ""
                                let uid = snapshot.key
                                let bio = data["bio"] as? String ?? ""
                                let fullName = data["fullName"] as? String ?? ""
                                let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                                self.users.append(userToAdd)
                                
                            }
                            
                            group.leave()
                            
                        })
                        
                    }
                    
                }
                
                group.notify(queue: .main) {
                    
                    self.filteredUsers = self.users
                    self.loadingIndicatorView.stopAnimating()
                    self.searchTablePlaceholderView.isHidden = false
                    self.isFetchingUsers = false
                    self.searchTableView.reloadData()
                    
                }
                
            } else {
                
                self.loadingIndicatorView.stopAnimating()
                self.searchTablePlaceholderView.isHidden = false
                self.isFetchingUsers = false
                
            }
        })
    }
    
    private func fetchFollowing() {
        
        isFetchingUsers = true
        searchTablePlaceholderView.isHidden = true
        loadingIndicatorView.startAnimating()
        
        let ref = Database.database().reference()
        
        ref.child("users/\(userID)/following").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            // Printing the child count
            // Checking if the reference has some values
            if snapshot.childrenCount > 0, let uidDic = snapshot.value as? [String : AnyObject] {
                
                let userIDs: [String] = Array(uidDic.keys)
                
                if userIDs.isEmpty || (userIDs.count == 1 && userIDs[0] == self.userID) {
                    
                    self.loadingIndicatorView.stopAnimating()
                    self.searchTablePlaceholderView.isHidden = false
                    self.isFetchingUsers = false
                    
                    return
                    
                }
                
                let group = DispatchGroup()
                
                for userId in userIDs {
                    
                    // Go through every child
                    if userId != self.userID {
                        
                        group.enter()
                        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                            
                            guard let self = self else { return }
                            
                            if let data = snapshot.value as? [String: Any] {
                                
                                let userName = data["username"] as? String ?? ""
                                let uid = snapshot.key
                                let bio = data["bio"] as? String ?? ""
                                let fullName = data["fullName"] as? String ?? ""
                                let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                                self.users.append(userToAdd)
                                
                            }
                            
                            group.leave()
                            
                        })
                    }
                }
                
                group.notify(queue: .main) {
                    
                    self.filteredUsers = self.users
                    self.loadingIndicatorView.stopAnimating()
                    self.searchTablePlaceholderView.isHidden = false
                    self.isFetchingUsers = false
                    self.searchTableView.reloadData()
                    
                }
                
            } else {
                
                self.loadingIndicatorView.stopAnimating()
                self.searchTablePlaceholderView.isHidden = false
                self.isFetchingUsers = false
                
            }
            
        })
        
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let lastSeparator = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 1.0))
        lastSeparator.backgroundColor = .white
        return lastSeparator
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if filteredUsers.count == 0 {
            
            if !isFetchingUsers { searchTablePlaceholderView.isHidden = false }
            tableView.sectionFooterHeight = 0.0
            
        } else {
            
            searchTablePlaceholderView.isHidden = true
            tableView.sectionFooterHeight = 1.0
            
        }
        
        return filteredUsers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.cellIdentifier, for: indexPath) as! UserSearchCell
        
        userCell.selectionStyle = .none
        
        let userData: UserData = filteredUsers[indexPath.row]
        
        // Reference to an image file in Firebase Storage
        let reference = self.storage.reference().child("images/\(userData.uid)/profilepic.jpg")
        
        // Placeholder image
        let placeholderImage = UIImage.defaultUserPicture256
        
        // Load the image using SDWebImage
        userCell.userImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        
        userCell.usernameLabel.text = "@" + userData.username
        userCell.fullNameLabel.text = userData.fullName
        
        return userCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let profileVC = ProfileViewController(with: filteredUsers[indexPath.row])
        
        navigationController?.pushViewController(profileVC, animated: true)
        
    }
    
}

extension SearchViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            filteredUsers = users
            searchTableView.reloadData()
            
        } else {
            
            filterUsers(for: searchText)
            
        }
        
    }
    
    private func filterUsers(for searchText: String) {
        
        filteredUsers = users.filter { user in
            
            return user.username.lowercased().contains(searchText.lowercased()) || user.fullName.lowercased().contains(searchText.lowercased())
            
        }
        
        searchTableView.reloadData()
        
    }
    
}
