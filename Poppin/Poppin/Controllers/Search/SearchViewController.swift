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
import Geofirestore
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

final class SearchViewController: UIViewController {
    
    private let searchVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let searchHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 3)
    private let searchInnerInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    private var searchTypes: [SearchType] = []
    private var userID: String = Auth.auth().currentUser!.uid
    private var username: String?
    private var storage: Storage = Storage.storage()
    private var isFetching: Bool = false
    private var currentPage: Int = 0
    private var shouldActivateSearchBar: Bool = false
    private var searchBarWasActive: Bool = false
    private var alwaysShowsCancelButton: Bool = false
    private var startIndex: Int = 0
    
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
        
        let searchHeaderBackButton = BouncyButton(bouncyButtonImage: UIImage(systemSymbol: .chevronLeft, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0.0, weight: .bold)).withTintColor(UIColor.white))
        searchHeaderBackButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
        
        searchHeaderBackButton.translatesAutoresizingMaskIntoConstraints = false
        searchHeaderBackButton.heightAnchor.constraint(equalToConstant: searchHeaderUsernameLabel.intrinsicContentSize.height*0.8).isActive = true
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
        searchHeaderUsernameLabel.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
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
    
    lazy private var searchBar: SearchBar = {
        
        var searchBar = SearchBar(tintColor: UIColor.white)
        searchBar.delegate = self
        return searchBar
        
    }()
    
    lazy private var searchBarCancelButton: BouncyButton = {
        
        var searchBarCancelButton = BouncyButton(bouncyButtonImage: nil)
        searchBarCancelButton.setTitle("Cancel", for: .normal)
        searchBarCancelButton.titleLabel?.textAlignment = .center
        searchBarCancelButton.setTitleColor(.white, for: .normal)
        searchBarCancelButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
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
            sectionButton.titleLabel?.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
            sectionButton.titleLabel?.textAlignment = .center
            sectionButton.setTitle(searchType.rawValue, for: .normal)
            sectionButton.addTarget(self, action: #selector(showSection(sender:)), for: .touchUpInside)
            
            if sectionButton.section != startIndex { sectionButton.alpha = 0.7 }
            
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
    
    lazy private var recentSearchesView: UIView = {
       let recentSearchesView = UIView()
        recentSearchesView.backgroundColor = .clear
        recentSearchesView.isUserInteractionEnabled = true
        return recentSearchesView
    }()
    
    lazy private var clearRecentSearchesButton: ImageBubbleButton = {
        let close = UIImage(systemName: "multiply.circle.fill")!.withTintColor(.white)
        let clearRecentSearchesButton = ImageBubbleButton(bouncyButtonImage: close)
        clearRecentSearchesButton.isUserInteractionEnabled = true
        clearRecentSearchesButton.addTarget(self, action: #selector(clearRecent), for: .touchUpInside)
        return clearRecentSearchesButton
    }()
    
    @objc func clearRecent(){
        DataController.clearRecentSearches()
        recentSearchesView.transform = CGAffineTransform(scaleX: 1, y: 0)
        searchPagingCollectionView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height * 0.05)
        self.view.layoutIfNeeded()
        
    }
    
     @objc func clearedRecents(_ notification: Notification) {
        if let searchCell = searchPagingCollectionView.visibleCells.first as? SearchPageCell {
            searchCell.filteredUsers = fetchRecentUsers()
            print(searchCell.filteredUsers.count)
            searchCell.searchTableView.reloadData()
        }
    }
    
    lazy private var recentSearchesLabel: UILabel = {
       let recentSearchesLabel = UILabel()
        recentSearchesLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title3)
        recentSearchesLabel.textColor = .white
        recentSearchesLabel.text = "Recent searches"
        recentSearchesLabel.backgroundColor = .clear
        return recentSearchesLabel
    }()
    
    lazy private var searchPagingCollectionView: PagingCollectionView = {
        
        var searchPagingCollectionView = PagingCollectionView(pageType: .Search)
        searchPagingCollectionView.delegate = self
        searchPagingCollectionView.dataSource = self
        return searchPagingCollectionView
        
    }()
    
    init(searchTypes: [SearchType], startIndex: Int, userID: String?, username: String?, shouldActivateSearchBar: Bool, alwaysShowsCancelButton: Bool) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.searchTypes = searchTypes
        self.username = username
        self.shouldActivateSearchBar = shouldActivateSearchBar
        self.alwaysShowsCancelButton = alwaysShowsCancelButton
        
        if startIndex >= 0 && startIndex < searchTypes.count { self.startIndex = startIndex }
        
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
        
        switch searchTypes[startIndex] {
            
        case .Followers: fetchFollowers(section: 0)
        case .Following: fetchFollowing(section: 0)
        case .Users: fetchUsers(section: 0)
        case .Events: fetchEvents(section: 0)
            
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .poppinLIGHTGOLD
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadedFollowing(_:)), name: .loadedFollowing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadedFollowers(_:)), name: .loadedFollowers, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(clearedRecents(_:)), name: .clearedRecents, object: nil)
        
        view.addSubview(searchTopStackView)
        searchTopStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if username == nil {
            
            searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: searchVerticalEdgeInset).isActive = true
            
        } else {
            
            searchTopStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            
        }
    
        searchTopStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(recentSearchesView)
        recentSearchesView.translatesAutoresizingMaskIntoConstraints = false
        recentSearchesView.topAnchor.constraint(equalTo: searchTopStackView.bottomAnchor).isActive = true
        recentSearchesView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recentSearchesView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        recentSearchesView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05).isActive = true
        
        recentSearchesView.addSubview(clearRecentSearchesButton)
        clearRecentSearchesButton.translatesAutoresizingMaskIntoConstraints = false
        clearRecentSearchesButton.trailingAnchor.constraint(equalTo: recentSearchesView.trailingAnchor, constant: -view.bounds.width * 0.05).isActive = true
        clearRecentSearchesButton.centerYAnchor.constraint(equalTo: recentSearchesView.centerYAnchor).isActive = true
        clearRecentSearchesButton.widthAnchor.constraint(equalToConstant: view.bounds.height * 0.03).isActive = true
        clearRecentSearchesButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.03).isActive = true
        
        recentSearchesView.addSubview(recentSearchesLabel)
        recentSearchesLabel.translatesAutoresizingMaskIntoConstraints = false
        recentSearchesLabel.leadingAnchor.constraint(equalTo: recentSearchesView.leadingAnchor, constant: view.bounds.width * 0.05).isActive = true
        recentSearchesLabel.centerYAnchor.constraint(equalTo: recentSearchesView.centerYAnchor).isActive = true
        recentSearchesLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
       // recentSearchesLabel.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.03).isActive = true
        
        recentSearchesView.transform = CGAffineTransform(scaleX: 1, y: 0)
        searchPagingCollectionView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height * 0.05)
        self.view.layoutIfNeeded()
        
        view.addSubview(searchPagingCollectionView)
        view.sendSubviewToBack(searchPagingCollectionView)
        searchPagingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchPagingCollectionView.topAnchor.constraint(equalTo: recentSearchesView.bottomAnchor).isActive = true
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
        
        if username != nil { navigationController?.interactivePopGestureRecognizer?.delegate = self }
        
        if shouldActivateSearchBar {
            
            searchBar.becomeFirstResponder()
            shouldActivateSearchBar = false
            
        }
        
        searchPagingCollectionView.layoutIfNeeded()
        showSection(sender: searchSectionButtons[startIndex])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if searchBarWasActive { searchBar.becomeFirstResponder() }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        if searchBar.isFirstResponder {
            
            searchBarWasActive = true
            searchBar.resignFirstResponder()
            
        }
        
    }
    
    @objc private func showSection(sender: SectionButton) {
        
        if currentPage != sender.section {
            
            currentPage = sender.section
            
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
            
            navigationController?.dismiss(animated: true, completion: nil)
            
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
    
    private func fetchRecentUsers() -> [UserData]{
        let user = DataController.getOtherUsers()
        
        var recentUsers: [UserData] = []
        
        print(user.count)
        for u in user {
            let username = u.value(forKey: "username") as! String
            let uid = u.value(forKey: "uid") as! String
            let bio = u.value(forKey: "bio") as! String
            let fullName = u.value(forKey: "fullName") as! String

            print(username)
            let userToAdd = UserData(username: username, uid: uid, bio: bio, fullName: fullName)
            
            recentUsers.append(userToAdd)
        }
        
        if(recentUsers.count > 0){
            recentSearchesView.transform = .identity
            searchPagingCollectionView.transform = .identity
            self.view.layoutIfNeeded()
        }else{
            recentSearchesView.transform = CGAffineTransform(scaleX: 1, y: 0)
            searchPagingCollectionView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height * 0.05)
            self.view.layoutIfNeeded()
        }
        
        return recentUsers.reversed()
    }
    
    private func fetchUsers(section: Int) {
        
        isFetching = true
        searchTablePlaceholderView.isHidden = true
        loadingIndicatorView.startAnimating()
        
        
         let geoFirestoreRef = Firestore.firestore()

               let geoFirestore = GeoFirestore(collectionRef: geoFirestoreRef.collection("userLocs"))
               
               let userRef = geoFirestoreRef.collection("users")
               // Query using CLLocation
               let center = CLLocation(latitude: MapViewController.defaultMapViewCenterLocation.latitude, longitude: MapViewController.defaultMapViewCenterLocation.longitude)
        
            let radius = Double(MapViewController.defaultMapViewRegionRadius/1000.0)

               let circleQuery2 = geoFirestore.query(withCenter: center, radius: radius)
               
               _ = circleQuery2.observe(.documentEntered, with: { (key, location) in
 
                   userRef.document(key!).getDocument{ (document, error) in
                       if let document = document, document.exists {
        
                           let data = document.data()
                        
                        let userName = data?["username"] as? String ?? ""
                        let uid = key!
                        let bio = data?["bio"] as? String ?? ""
                        let fullName = data?["fullName"] as? String ?? ""
                        let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                        
                        print(uid)
                        
                        if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Users {
                            
                            searchCell.users.append(userToAdd)

                       } else {
                           print("Document does not exist")
                       }
                   
               }
                }
               if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Users {
                   searchCell.filteredUsers = self.fetchRecentUsers()
                   if(searchCell.filteredUsers.count < 1){
                       self.searchTablePlaceholderView.isHidden = false
                   }else{
                       self.searchTablePlaceholderView.isHidden = true
                   }
                   
                   print("RELLOOAADINNGG")
                   searchCell.searchTableView.reloadData()
                   
               }
               
               print("DIDNT RELOAD")
               self.searchSectionButtons[section].didFetchSection = true
               
               
               self.loadingIndicatorView.stopAnimating()
               //self.searchTablePlaceholderView.isHidden = false
               self.isFetching = false
               })
        
    }
    
    @objc func loadedFollowers(_ notification: Notification) {
          let section = notification.userInfo?["section"] as? Int ?? 0
          self.loadingIndicatorView.stopAnimating()
          self.searchTablePlaceholderView.isHidden = false
          self.isFetching = false
          self.searchSectionButtons[section].didFetchSection = true
          
          if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Followers {
              searchCell.searchTableView.reloadData()
              
          }
      }
    
    private func fetchFollowers(section: Int) {
        
        isFetching = true
        searchTablePlaceholderView.isHidden = true
        loadingIndicatorView.startAnimating()
        
        let followerRef = Firestore.firestore().collection("users")
        
        followerRef.document(userID).getDocument{ (document, error) in
        if let document = document, document.exists {
            let data = document.data()
             let followers = data?["followers"] as? [String: Any] ?? [:]
             let userIDs: [String] = Array(followers.keys)
            
            if userIDs.isEmpty || (userIDs.count == 1 && userIDs[0] == self.userID) {
                
                self.loadingIndicatorView.stopAnimating()
                self.searchTablePlaceholderView.isHidden = false
                self.isFetching = false
                
                return
                
            }
            
            for (i, userId) in userIDs.enumerated() {
               // print(userId)
                if userId != self.userID {
                    followerRef.document(userId).getDocument{ (document, error) in
                        let data = document?.data()
                        
                        let userName = data?["username"] as? String ?? ""
                        let uid = userId
                        let bio = data?["bio"] as? String ?? ""
                        let fullName = data?["fullName"] as? String ?? ""
                        let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                        
                        if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Followers {
                            print(userId)
                            searchCell.users.append(userToAdd)
                            searchCell.filteredUsers.append(userToAdd)
                            
                        }
                        
                        if(i == 0){
                            print("LAST INDEX")
                            NotificationCenter.default.post(name: .loadedFollowers, object: nil, userInfo: ["section": section])
                            
                        }

                    }

                }
                
            }

        } else {
            print("Document does not exist")
            }
        }
    }
    
    @objc func loadedFollowing(_ notification: Notification) {
        let section = notification.userInfo?["section"] as? Int ?? 0
        self.loadingIndicatorView.stopAnimating()
        self.searchTablePlaceholderView.isHidden = false
        self.isFetching = false
        self.searchSectionButtons[section].didFetchSection = true
        
        if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
            searchCell.searchTableView.reloadData()
            
        }
    }
    
  
    
    private func fetchFollowing(section: Int) {
        
        isFetching = true
        searchTablePlaceholderView.isHidden = true
        loadingIndicatorView.startAnimating()
        let group = DispatchGroup()

        let followingRef = Firestore.firestore().collection("users")
        
        followingRef.document(userID).getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var following = data?["following"] as? [String: Any] ?? [:]
                following.removeValue(forKey: self.userID)
                
                let userIDs: [String] = Array(following.keys)
                
                if userIDs.isEmpty || (userIDs.count == 1 && userIDs[0] == self.userID) {
                    
                    self.loadingIndicatorView.stopAnimating()
                    self.searchTablePlaceholderView.isHidden = false
                    self.isFetching = false
                                        
                    return
                    
                }
                

                for (i, userId) in userIDs.enumerated() {
                       // group.enter()
                        followingRef.document(userId).getDocument{ (document, error) in
                            let data = document?.data()
                            
                            let userName = data?["username"] as? String ?? ""
                            let uid = userId
                            let bio = data?["bio"] as? String ?? ""
                            let fullName = data?["fullName"] as? String ?? ""
                            let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
                            
                            if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
                                print(userId)
                                searchCell.users.append(userToAdd)
                                searchCell.filteredUsers.append(userToAdd)
                                
                            }

                            if(i == 0){
                                NotificationCenter.default.post(name: .loadedFollowing, object: nil, userInfo: ["section": section])

                            }
                            
                    }
                    
                }

//                group.notify(queue: .main) {
//                    print("RELOOOADDINNGG")
//                    self.loadingIndicatorView.stopAnimating()
//                    self.searchTablePlaceholderView.isHidden = false
//                    self.isFetching = false
//                    self.searchSectionButtons[section].didFetchSection = true
//
//                    if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
//                        print("RELOOOADDINNGG2222")
//
//                        searchCell.searchTableView.reloadData()
//
//                    }
//                }
                
            } else {
                print("Document does not exist")
            }
        }
        
//        isFetching = true
//        searchTablePlaceholderView.isHidden = true
//        loadingIndicatorView.startAnimating()
//
//        let ref = Database.database().reference()
//
//        ref.child("users/\(userID)/following").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
//
//            guard let self = self else { return }
//
//            // Printing the child count
//            // Checking if the reference has some values
//            if snapshot.childrenCount > 0, let uidDic = snapshot.value as? [String : AnyObject] {
//
//                let userIDs: [String] = Array(uidDic.keys)
//
//                if userIDs.isEmpty || (userIDs.count == 1 && userIDs[0] == self.userID) {
//
//                    self.loadingIndicatorView.stopAnimating()
//                    self.searchTablePlaceholderView.isHidden = false
//                    self.isFetching = false
//
//                    return
//
//                }
//
//                let group = DispatchGroup()
//
//                for userId in userIDs {
//
//                    // Go through every child
//                    if userId != self.userID {
//
//                        group.enter()
//                        ref.child("users/\(userId)").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
//
//                            guard let self = self else { return }
//
//                            if let data = snapshot.value as? [String: Any] {
//
//                                let userName = data["username"] as? String ?? ""
//                                let uid = snapshot.key
//                                let bio = data["bio"] as? String ?? ""
//                                let fullName = data["fullName"] as? String ?? ""
//                                let userToAdd = UserData(username: userName, uid: uid, bio: bio, fullName: fullName)
//
//                                if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
//
//                                    searchCell.users.append(userToAdd)
//                                    searchCell.filteredUsers.append(userToAdd)
//
//                                }
//
//                            }
//
//                            group.leave()
//
//                        })
//                    }
//                }
//
//                group.notify(queue: .main) {
//
//                    self.loadingIndicatorView.stopAnimating()
//                    self.searchTablePlaceholderView.isHidden = false
//                    self.isFetching = false
//                    self.searchSectionButtons[section].didFetchSection = true
//
//                    if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell, searchCell.searchType == .Following {
//
//                        searchCell.searchTableView.reloadData()
//
//                    }
//
//                }
//
//            } else {
//
//                self.loadingIndicatorView.stopAnimating()
//                self.searchTablePlaceholderView.isHidden = false
//                self.isFetching = false
//
//            }
//
//        })
//
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
            
            let profileVC = ProfileViewController(with: searchCell.filteredUsers[indexPath.row], isUser: false)
            
            if(searchTypes[0] == .Users){
                DataController.addRecentSearch(bio: searchCell.filteredUsers[indexPath.row].bio, username: searchCell.filteredUsers[indexPath.row].username, fullName: searchCell.filteredUsers[indexPath.row].fullName, uid: searchCell.filteredUsers[indexPath.row].uid)
            }
            
            navigationController?.pushViewController(profileVC, animated: true)
            if(searchBar.text == ""){
                searchCell.filteredUsers = fetchRecentUsers()
            }
            searchCell.searchTableView.reloadData()
        }
        
    }
    
}

extension SearchViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
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
        
        if searchBar is SearchBar, !alwaysShowsCancelButton {
            
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
        
        if(searchTypes[0] == .Users){
            if searchText == "" {
                //            recentSearchesView.transform = .identity
                //            searchPagingCollectionView.transform = .identity
                
                // self.view.layoutIfNeeded()
                if let searchCell = self.searchPagingCollectionView.visibleCells.first as? SearchPageCell {
                    
                    searchCell.filteredUsers = searchCell.users
                    searchCell.filteredUsers = self.fetchRecentUsers()
                    searchCell.searchTableView.reloadData()
                    
                }
                
            } else {
                
                filterUsers(for: searchText)
                recentSearchesView.transform = CGAffineTransform(scaleX: 1, y: 0)
                searchPagingCollectionView.transform = CGAffineTransform(translationX: 0, y: -view.bounds.height * 0.05)
                self.view.layoutIfNeeded()
                
            }
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
        
        if scrollView is PagingCollectionView {
            
            let newPage = Int(targetContentOffset.pointee.x / view.frame.width)
            
            if currentPage != newPage, newPage >= 0, newPage < searchSectionButtons.count {
                
                currentPage = newPage
                
                print("Showing " + searchTypes[currentPage].rawValue)
                
                for sectionButton in searchSectionButtons {
                    
                    if sectionButton.section == currentPage {
                        
                        sectionButton.alpha = 1.0
                        
                    } else {
                        
                        sectionButton.alpha = 0.7
                        
                    }
                    
                }
                
                switch searchTypes[currentPage] {
                    
                case .Users: fetchUsers(section: currentPage)
                case .Events: fetchEvents(section: currentPage)
                case .Followers: fetchFollowers(section: currentPage)
                case .Following: fetchFollowing(section: currentPage)
                    
                }
                
            } else {
                
                print("ERROR: Unable to show new section.")
                
            }
            
        }
        
    }
    
}
