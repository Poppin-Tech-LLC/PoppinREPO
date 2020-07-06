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
    
    private var searchTypes: [SearchType] = []
    private var userID: String = Auth.auth().currentUser!.uid
    private var username: String?
    private var storage: Storage = Storage.storage()
    private var isFetching: Bool = false
    
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
        
        var searchTopStackView = UIStackView()
        searchTopStackView.axis = .vertical
        searchTopStackView.alignment = .fill
        searchTopStackView.distribution = .fill
        searchTopStackView.spacing = innerInset
        
        if username != nil {
        
            searchTopStackView.addArrangedSubview(searchHeaderView)
            
        }
        
        searchTopStackView.addArrangedSubview(searchBarView)
        
        if !searchTypes.isEmpty {
            
            searchTopStackView.addArrangedSubview(searchSectionsView)
            
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
        searchHeaderUsernameLabel.text = "@" + (username ?? "username").lowercased()
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
    
    lazy private var searchSectionButtons: [SectionButton] = {
        
        var searchSectionButtons: [SectionButton] = []
        
        for searchType in searchTypes {
            
            let sectionButton = SectionButton(bouncyButtonImage: nil, section: searchSectionButtons.count)
            sectionButton.backgroundColor = .clear
            sectionButton.setTitleColor(UIColor.white, for: .normal)
            sectionButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .callout)
            sectionButton.titleLabel?.textAlignment = .center
            sectionButton.setTitle(searchType.rawValue, for: .normal)
            sectionButton.addTarget(self, action: #selector(showSection(sender:)), for: .touchUpInside)
            
            if sectionButton.section != 0 { sectionButton.alpha = 0.7 }
            
            searchSectionButtons.append(sectionButton)
            
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
    
    init(searchTypes: [SearchType], userID: String?, username: String?, shouldActivateSearchBar: Bool) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.searchTypes = searchTypes
        self.username = username
        
        if shouldActivateSearchBar { searchBar.becomeFirstResponder() }
        
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
        
        switch searchTypes[0] {
            
        case .Followers: fetchFollowers(section: 0)
        case .Following: fetchFollowing(section: 0)
        case .Users: fetchUsers(section: 0)
        case .Events: fetchEvents(section: 0)
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .poppinLIGHTGOLD
        
        view.addSubview(searchTopStackView)
        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if username == nil {
            
            searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchVerticalEdgeInset).isActive = true
            
        } else {
            
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
        
        if username != nil {
            
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    @objc private func showSection(sender: SectionButton) {
        
        if let currentIndex = searchPagingCollectionView.indexPathsForVisibleItems.first?.item, currentIndex != sender.section {
            
            for sectionButton in searchSectionButtons {
                
                if sectionButton.section == sender.section {
                    
                    sectionButton.alpha = 1.0
                    
                } else {
                    
                    sectionButton.alpha = 0.7
                    
                }
                
            }
            
            searchPagingCollectionView.scrollToItem(at: IndexPath(item: sender.section, section: 0), at: .centeredHorizontally, animated: true)
            
            if !sender.didFetchSection {
                
                switch searchTypes[sender.section] {
                    
                case .Users: fetchUsers(section: sender.section)
                case .Events: fetchEvents(section: sender.section)
                case .Followers: fetchFollowers(section: sender.section)
                case .Following: fetchFollowing(section: sender.section)
                    
                }
                
            }
            
        } else {
            
            print("ERROR: Unable to show " + searchTypes[sender.section].rawValue + ".")
            
        }
        
    }
    
    @objc private func transitionToPreviousPage() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func cancelButtonAction(sender: BouncyButton) {
        
        if username == nil {
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            searchBar.endEditing(true)
            
        }
        
    }
    
    private func fetchEvents(section: Int) {
     
        isFetching = true
        searchTablePlaceholderView.isHidden = true
        loadingIndicatorView.startAnimating()
        
        // Future Action
        
        if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Events {
            
            searchCell.users = []
            searchCell.filteredUsers = []
            searchCell.searchTableView.reloadData()
            
        }
        
        searchSectionButtons[section].didFetchSection = true
        loadingIndicatorView.stopAnimating()
        searchTablePlaceholderView.isHidden = false
        isFetching = false
        
    }
    
    private func fetchUsers(section: Int) {
        
        isFetching = true
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
                        
                        if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Users {
                            
                            searchCell.users.append(userToAdd)
                            searchCell.filteredUsers.append(userToAdd)
                            
                        }
                
                    }
                    
                }
                
                if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Users {
                    
                    searchCell.searchTableView.reloadData()
                    
                }
                
                self.searchSectionButtons[section].didFetchSection = true
                
            }
            
            self.loadingIndicatorView.stopAnimating()
            self.searchTablePlaceholderView.isHidden = false
            self.isFetching = false
            
        })
        
    }
    
    private func fetchFollowers(section: Int) {
        
        isFetching = true
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
                    self.isFetching = false
                    
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
                    self.isFetching = false
                    self.searchSectionButtons[section].didFetchSection = true
                    
                    if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Followers {
                        
                        searchCell.searchTableView.reloadData()
                        
                    }
                    
                }
                
            } else {
                
                self.loadingIndicatorView.stopAnimating()
                self.searchTablePlaceholderView.isHidden = false
                self.isFetching = false
                
            }
        })
    }
    
    private func fetchFollowing(section: Int) {
        
        isFetching = true
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
                    self.isFetching = false
                    
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
                    self.isFetching = false
                    self.searchSectionButtons[section].didFetchSection = true
                    
                    if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
                        
                        searchCell.searchTableView.reloadData()
                        
                    }
                    
                }
                
            } else {
                
                self.loadingIndicatorView.stopAnimating()
                self.searchTablePlaceholderView.isHidden = false
                self.isFetching = false
                
            }
            
        })
        
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let searchCell = searchPagingCollectionView.visibleCells.first as? SearchPageCell {
            
            if searchCell.filteredUsers.count == 0 {
                
                if !isFetching { searchTablePlaceholderView.isHidden = false }
                
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
            
            return searchTypes.count
            
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let pagingCollectionView = collectionView as? PagingCollectionView {
            
            if let searchPageCell = pagingCollectionView.dequeueReusableCell(withReuseIdentifier: pagingCollectionView.cellID, for: indexPath) as? SearchPageCell {
                
                searchPageCell.searchType = searchTypes[indexPath.item]
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
                
                self.searchSectionBarView.transform = CGAffineTransform(translationX: scrollView.contentOffset.x/CGFloat(searchTypes.count), y: 0.0)
                
            } else {
                
                self.searchSectionBarView.transform = CGAffineTransform(translationX: (scrollView.contentOffset.x/CGFloat(searchTypes.count)) - searchVerticalEdgeInset, y: 0.0)
                
            }
            
        }
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if let pagingCollectionView = scrollView as? PagingCollectionView {
            
            let newSection = Int(targetContentOffset.pointee.x / view.frame.width)
            
            if let currentSection = pagingCollectionView.indexPathsForVisibleItems.first?.item, currentSection != newSection, newSection >= 0, newSection < searchSectionButtons.count {
                
                print("Showing " + searchTypes[newSection].rawValue)
                
                for sectionButton in searchSectionButtons {
                    
                    if sectionButton.section == newSection {
                        
                        sectionButton.alpha = 1.0
                        
                    } else {
                        
                        sectionButton.alpha = 0.7
                        
                    }
                    
                }
                
                switch searchTypes[newSection] {
                    
                case .Users: fetchUsers(section: newSection)
                case .Events: fetchEvents(section: newSection)
                case .Followers: fetchFollowers(section: newSection)
                case .Following: fetchFollowing(section: newSection)
                    
                }
                
            } else {
                
                print("ERROR: Unable to show new section.")
                
            }
            
        }
        
    }
    
}
