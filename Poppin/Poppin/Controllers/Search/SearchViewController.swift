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

final class SearchViewController: UIViewController {
    
    private let searchVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let searchHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    private let searchInnerInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    private var searchType: SearchType = .Default
    private var userID: String = Auth.auth().currentUser!.uid
    private var username: String = "username"
    private var storage: Storage = Storage.storage()
    private var currentPage: Int = 0
    private var isFetchingUsers: Bool = false
    private var didFetchFollowers: Bool = false
    private var didFetchFollowing: Bool = false
    
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
    
    lazy private var loadingIndicatorView: UIActivityIndicatorView = {
        
        var loadingIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        loadingIndicatorView.color = .white
        loadingIndicatorView.hidesWhenStopped = true
        return loadingIndicatorView
        
    }()
    
    lazy private var searchTopStackView: UIStackView = {
        
        let innerInset: CGFloat = .getPercentageWidth(percentage: 2)
        
        var searchTopStackView = UIStackView(arrangedSubviews: [searchHeaderView, searchBarView, searchSectionsView])
        searchTopStackView.axis = .vertical
        searchTopStackView.alignment = .fill
        searchTopStackView.distribution = .fill
        searchTopStackView.spacing = innerInset
        
        if searchType == .Main {
        
            searchHeaderView.isHidden = true
            
        }
        
        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
        searchTopStackView.widthAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarWidth).isActive = true
        
        searchBarHiddenConstraint.isActive = true
        
        return searchTopStackView
        
    }()
    
    lazy private var searchHeaderView: UIView = {
        
        let searchHeaderBackButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .arrowLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .bold)).withTintColor(UIColor.white))
        searchHeaderBackButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
        
        searchHeaderBackButton.translatesAutoresizingMaskIntoConstraints = false
        searchHeaderBackButton.heightAnchor.constraint(equalToConstant: searchHeaderUsernameLabel.intrinsicContentSize.height).isActive = true
        searchHeaderBackButton.widthAnchor.constraint(equalTo: searchHeaderBackButton.heightAnchor).isActive = true
        
        var searchHeaderView = UIView()
        searchHeaderView.backgroundColor = .clear
        
        searchHeaderView.translatesAutoresizingMaskIntoConstraints = false
        searchHeaderView.heightAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarHeight).isActive = true
        
        searchHeaderView.addSubview(searchHeaderUsernameLabel)
        searchHeaderUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        searchHeaderUsernameLabel.topAnchor.constraint(equalTo: searchHeaderView.topAnchor).isActive = true
        searchHeaderUsernameLabel.bottomAnchor.constraint(equalTo: searchHeaderView.bottomAnchor).isActive = true
        searchHeaderUsernameLabel.centerXAnchor.constraint(equalTo: searchHeaderView.centerXAnchor).isActive = true
        
        searchHeaderView.addSubview(searchHeaderBackButton)
        searchHeaderBackButton.translatesAutoresizingMaskIntoConstraints = false
        searchHeaderBackButton.centerYAnchor.constraint(equalTo: searchHeaderView.centerYAnchor).isActive = true
        searchHeaderBackButton.leadingAnchor.constraint(equalTo: searchHeaderView.leadingAnchor).isActive = true
        
        return searchHeaderView
        
    }()
    
    lazy private var searchHeaderUsernameLabel: UILabel = {
        
        var searchHeaderUsernameLabel = UILabel()
        searchHeaderUsernameLabel.textColor = .white
        searchHeaderUsernameLabel.textAlignment = .center
        searchHeaderUsernameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .callout)
        searchHeaderUsernameLabel.text = "@" + username.lowercased()
        return searchHeaderUsernameLabel
        
    }()
    
    lazy private var searchBarView: UIView = {
        
        var searchBarView = UIView()
        searchBarView.backgroundColor = .clear
        
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.heightAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarHeight).isActive = true
        
        searchBarView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: searchBarView.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor).isActive = true
        
        searchBarView.addSubview(searchBarCancelButton)
        searchBarCancelButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarCancelButton.topAnchor.constraint(equalTo: searchBarView.topAnchor).isActive = true
        searchBarCancelButton.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor).isActive = true
        searchBarCancelButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor).isActive = true
        
        return searchBarView
        
    }()
    
    lazy private var searchBar: UISearchBar = {
        
        var searchBar = SearchBar(tintColor: UIColor.white)
        
        if searchType == .Main || searchType == .Default {
            
            searchBar.becomeFirstResponder()
            
        }
        
        searchBar.delegate = self
        return searchBar
        
    }()
    
    lazy private var searchBarCancelButton: BouncyButton = {
        
        var searchBarCancelButton = BouncyButton(bouncyButtonImage: nil)
        searchBarCancelButton.setTitle("Cancel", for: .normal)
        searchBarCancelButton.titleLabel?.textAlignment = .center
        searchBarCancelButton.setTitleColor(.white, for: .normal)
        searchBarCancelButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        searchBarCancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: .touchUpInside)
        searchBarCancelButton.alpha = 0.0
        
        searchBarCancelButton.translatesAutoresizingMaskIntoConstraints = false
        searchBarCancelButton.widthAnchor.constraint(equalToConstant: searchBarCancelButton.intrinsicContentSize.width).isActive = true
        
        return searchBarCancelButton
        
    }()
    
    lazy private var searchBarHiddenConstraint: NSLayoutConstraint = {
    
        var searchBarHiddenConstraint = NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: searchBarView, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        return searchBarHiddenConstraint
    
    }()
    
    lazy private var searchBarShowingConstraint: NSLayoutConstraint = {
    
        var searchBarShowingConstraint = NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: searchBarCancelButton, attribute: .leading, multiplier: 1.0, constant: -searchHorizontalEdgeInset)
        return searchBarShowingConstraint
    
    }()
    
    lazy private var searchSectionsView: UIView = {
        
        let sectionButtonsStackView = UIStackView(arrangedSubviews: searchSectionButtons)
        sectionButtonsStackView.axis = .horizontal
        sectionButtonsStackView.alignment = .fill
        sectionButtonsStackView.distribution = .fillEqually
        sectionButtonsStackView.spacing = 0
        
        sectionButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        sectionButtonsStackView.heightAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarHeight - .getPercentageWidth(percentage: 0.7)).isActive = true
        
        var searchSectionsView = UIView()
        searchSectionsView.backgroundColor = .clear
        
        searchSectionsView.translatesAutoresizingMaskIntoConstraints = false
        searchSectionsView.heightAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarHeight).isActive = true
        
        searchSectionsView.addSubview(sectionButtonsStackView)
        sectionButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        sectionButtonsStackView.topAnchor.constraint(equalTo: searchSectionsView.topAnchor).isActive = true
        sectionButtonsStackView.leadingAnchor.constraint(equalTo: searchSectionsView.leadingAnchor).isActive = true
        sectionButtonsStackView.trailingAnchor.constraint(equalTo: searchSectionsView.trailingAnchor).isActive = true
        
        searchSectionsView.addSubview(searchSectionBarView)
        searchSectionBarView.translatesAutoresizingMaskIntoConstraints = false
        searchSectionBarView.topAnchor.constraint(equalTo: sectionButtonsStackView.bottomAnchor).isActive = true
        searchSectionBarView.leadingAnchor.constraint(equalTo: searchSectionsView.leadingAnchor).isActive = true
        searchSectionBarView.bottomAnchor.constraint(equalTo: searchSectionsView.bottomAnchor).isActive = true
        
        return searchSectionsView
        
    }()
    
    lazy private var searchSectionButtons: [BouncyButton] = {
        
        var searchSectionButtons: [BouncyButton] = []
        
        if searchType == .Main {
            
            let usersSectionButton = BouncyButton(bouncyButtonImage: nil)
            usersSectionButton.backgroundColor = .clear
            usersSectionButton.setTitleColor(UIColor.white, for: .normal)
            usersSectionButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .callout)
            usersSectionButton.setTitle("Users", for: .normal)
            usersSectionButton.titleLabel?.textAlignment = .center
            //usersSectionButton.addTarget(self, action: #selector(showFollowers), for: .touchUpInside)
            
            searchSectionButtons.append(usersSectionButton)
            
        } else if searchType == .Followers || searchType == .Following {
            
            let followersSectionButton = BouncyButton(bouncyButtonImage: nil)
            followersSectionButton.backgroundColor = .clear
            followersSectionButton.setTitleColor(UIColor.white, for: .normal)
            followersSectionButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .callout)
            followersSectionButton.setTitle("Followers", for: .normal)
            followersSectionButton.titleLabel?.textAlignment = .center
            followersSectionButton.addTarget(self, action: #selector(showFollowers), for: .touchUpInside)
            
            let followingSectionButton = BouncyButton(bouncyButtonImage: nil)
            followingSectionButton.backgroundColor = .clear
            followingSectionButton.setTitleColor(UIColor.white, for: .normal)
            followingSectionButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .callout)
            followingSectionButton.setTitle("Following", for: .normal)
            followingSectionButton.titleLabel?.textAlignment = .center
            followingSectionButton.alpha = 0.7
            followingSectionButton.addTarget(self, action: #selector(showFollowing), for: .touchUpInside)
            
            searchSectionButtons.append(followersSectionButton)
            searchSectionButtons.append(followingSectionButton)
            
        }
        
        return searchSectionButtons
        
    }()
    
    lazy private var searchSectionBarView: UIView = {
        
        var searchSectionBarView = UIView()
        searchSectionBarView.backgroundColor = .white
        
        searchSectionBarView.addShadowAndRoundCorners(cornerRadius: 2.0, shadowOpacity: 0.0)
        
        searchSectionBarView.translatesAutoresizingMaskIntoConstraints = false
        searchSectionBarView.widthAnchor.constraint(equalToConstant: SearchBar.defaultSearchBarWidth / CGFloat(searchSectionButtons.count)).isActive = true
        
        return searchSectionBarView
        
    }()
    
    lazy private var searchPagingCollectionView: PagingCollectionView = {
        
        var searchPagingCollectionView = PagingCollectionView(pageType: .Search)
        searchPagingCollectionView.delegate = self
        searchPagingCollectionView.dataSource = self
        return searchPagingCollectionView
        
    }()
    
    init(searchType: SearchType, userID: String?, username: String?) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.searchType = searchType
        
        if let userID = userID { self.userID = userID }
        
        if let username = username { self.username = username }
        
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
        
        if searchType == .Main || searchType == .Default {
            
            searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchVerticalEdgeInset).isActive = true
            
        } else if searchType == .Followers || searchType == .Following {
            
            searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            
        }
    
        searchTopStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(searchPagingCollectionView)
        view.sendSubviewToBack(searchPagingCollectionView)
        searchPagingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchPagingCollectionView.topAnchor.constraint(equalTo: searchTopStackView.bottomAnchor).isActive = true
        searchPagingCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchPagingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchPagingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
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
    
    @objc private func showFollowers() {
        
        if currentPage != 0 {
            
            self.searchSectionButtons[0].alpha = 1.0
            self.searchSectionButtons[1].alpha = 0.7
            if !self.didFetchFollowers { self.fetchFollowers() }
            self.currentPage = 0
            
            self.searchPagingCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
    }
    
    @objc private func showFollowing() {
        
        if currentPage != 1 {
            
            searchSectionButtons[0].alpha = 0.7
            searchSectionButtons[1].alpha = 1.0
            if !self.didFetchFollowing { self.fetchFollowing() }
            self.currentPage = 1
            
            self.searchPagingCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
    }
    
    @objc private func transitionToPreviousPage() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func cancelButtonAction(sender: BouncyButton) {
        
        if searchType == .Main || searchType == .Default {
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            searchBar.endEditing(true)
            
        }
        
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
                        
                        if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Main {
                            
                            searchCell.users.append(userToAdd)
                            searchCell.filteredUsers.append(userToAdd)
                            
                        }
                
                    }
                }
                
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
                                
                                if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Followers {
                                    
                                    searchCell.users.append(userToAdd)
                                    searchCell.filteredUsers.append(userToAdd)
                                    
                                }
                                
                                
                            }
                            
                            group.leave()
                            
                        })
                        
                    }
                    
                }
                
                group.notify(queue: .main) {
                    
                    self.loadingIndicatorView.stopAnimating()
                    self.searchTablePlaceholderView.isHidden = false
                    self.isFetchingUsers = false
                    self.didFetchFollowers = true
                    
                    if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Followers {
                        
                        searchCell.searchTableView.reloadData()
                        
                    }
                    
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
                                
                                if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
                                    
                                    searchCell.users.append(userToAdd)
                                    searchCell.filteredUsers.append(userToAdd)
                                    
                                }
                                
                            }
                            
                            group.leave()
                            
                        })
                    }
                }
                
                group.notify(queue: .main) {
                    
                    self.loadingIndicatorView.stopAnimating()
                    self.searchTablePlaceholderView.isHidden = false
                    self.isFetchingUsers = false
                    self.didFetchFollowing = true
                    
                    if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
                        
                        searchCell.searchTableView.reloadData()
                        
                    }
                    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let searchCell = searchPagingCollectionView.visibleCells.first as? SearchPageCell {
            
            if searchCell.filteredUsers.count == 0 {
                
                if !isFetchingUsers { searchTablePlaceholderView.isHidden = false }
                
            } else {
                
                searchTablePlaceholderView.isHidden = true
                
            }
            
            return searchCell.filteredUsers.count
            
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let searchCell = searchPagingCollectionView.visibleCells.first as? SearchPageCell {
            
            let userCell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.cellIdentifier, for: indexPath) as! UserSearchCell
            
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                
                userCell.separatorInset = UIEdgeInsets(top: 0.0, left: view.frame.size.width, bottom: 0.0, right: 0.0)
                
            } else {
                
                userCell.separatorInset = .zero
                
            }
            
            userCell.selectionStyle = .none
            
            let userData: UserData = searchCell.filteredUsers[indexPath.row]
            
            // Reference to an image file in Firebase Storage
            let reference = self.storage.reference().child("images/\(userData.uid)/profilepic.jpg")
            
            // Placeholder image
            let placeholderImage = UIImage.defaultUserPicture256
            
            // Load the image using SDWebImage
            userCell.userImageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
            
            userCell.usernameLabel.text = "@" + userData.username
            userCell.fullNameLabel.text = userData.fullName
            
            return userCell
            
        } else {
            
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let searchCell = searchPagingCollectionView.visibleCells.first as? SearchPageCell {
            
            let profileVC = ProfileViewController(with: searchCell.filteredUsers[indexPath.row])
            
            navigationController?.pushViewController(profileVC, animated: true)
            
        }
        
    }
    
}

extension SearchViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if searchBar is SearchBar {
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                
                self.searchBarHiddenConstraint.isActive = false
                self.searchBarShowingConstraint.isActive = true
                self.searchBarCancelButton.alpha = 1.0
                self.searchBarView.layoutIfNeeded()
                
            }, completion: nil)
            
        }
        
        return true
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        if searchBar is SearchBar {
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.searchBarShowingConstraint.isActive = false
                self.searchBarHiddenConstraint.isActive = true
                self.searchBarCancelButton.alpha = 0.0
                self.searchBarView.layoutIfNeeded()
                
            }, completion: nil)
            
        }
        
        return true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell {
                
                searchCell.filteredUsers = searchCell.users
                
                searchCell.searchTableView.reloadData()
                
            }
            
        } else {
            
            filterUsers(for: searchText)
            
        }
        
    }
    
    private func filterUsers(for searchText: String) {
        
        if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell {
            
            searchCell.filteredUsers = searchCell.users.filter { user in
                
                return user.username.lowercased().contains(searchText.lowercased()) || user.fullName.lowercased().contains(searchText.lowercased())
                
            }
            
            searchCell.searchTableView.reloadData()
            
        }
        
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView is PagingCollectionView {
            
            if searchType == .Main || searchType == .Default { return 1 }
            
            else { return 2 }
            
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let pagingCollectionView = collectionView as? PagingCollectionView {
            
            if let searchPageCell = pagingCollectionView.dequeueReusableCell(withReuseIdentifier: pagingCollectionView.cellID, for: indexPath) as? SearchPageCell {
                
                searchPageCell.searchType = self.searchType
                searchPageCell.searchTableView.delegate = self
                searchPageCell.searchTableView.dataSource = self
                
                return searchPageCell
                
            } else {
                
                return UICollectionViewCell()
                
            }
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView is PagingCollectionView {
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
            
        } else {
            
            return CGSize(width: 0.0, height: 0.0)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        return false
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView is PagingCollectionView {
            
            if scrollView.contentOffset.x < (view.frame.width / 2) {
                
                self.searchSectionBarView.transform = CGAffineTransform(translationX: scrollView.contentOffset.x/2, y: 0.0)
                
            } else {
                
                self.searchSectionBarView.transform = CGAffineTransform(translationX: (scrollView.contentOffset.x/2) - searchVerticalEdgeInset, y: 0.0)
                
            }
            
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView is PagingCollectionView {
            
            let index = Int(targetContentOffset.pointee.x / view.frame.width)
            
            if index != currentPage {
                
                switch index {
                    
                case 0:
                    
                    searchSectionButtons[0].alpha = 1.0
                    searchSectionButtons[1].alpha = 0.7
                    if !didFetchFollowers { fetchFollowers() }
                    currentPage = 0
                    
                case 1:
                    
                    searchSectionButtons[0].alpha = 0.7
                    searchSectionButtons[1].alpha = 1.0
                    if !didFetchFollowing { fetchFollowing() }
                    currentPage = 1
                    
                default: print("ERROR: ScrollView index is out bounds. Rejecting Change.")
                    
                }
                
            }
            
        }
        
    }
    
}
