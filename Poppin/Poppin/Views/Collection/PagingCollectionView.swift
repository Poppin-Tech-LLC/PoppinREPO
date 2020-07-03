//
//  PagingCollectionView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

enum PageType: String {
    
    case Default = "Default"
    case Search = "Search"
    
}

final class PagingCollectionView: UICollectionView {
    
    private var pageType: PageType = .Default {
        
        didSet { cellID = pageType.rawValue }
        
    }
    
    private(set) var cellID: String = PageType.Default.rawValue
    
    init(pageType: PageType?) {
        
        let tabNavigationCollectionViewLayout = UICollectionViewFlowLayout()
        tabNavigationCollectionViewLayout.minimumLineSpacing = 0
        tabNavigationCollectionViewLayout.scrollDirection = .horizontal
        
        super.init(frame: .zero, collectionViewLayout: tabNavigationCollectionViewLayout)
        
        if let pageType = pageType { self.pageType = pageType }
        
        configureCollectionView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureCollectionView()
        
    }
    
    private func configureCollectionView() {
        
        if pageType == .Search {
            
            self.register(SearchPageCell.self, forCellWithReuseIdentifier: pageType.rawValue)
            
        }
        
        backgroundColor = .clear
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        bounces = true
        
    }
    
}

final class SearchPageCell: UICollectionViewCell {
    
    private let searchVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let searchHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    
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
    
    lazy private(set) var searchTableView: SelfSizedTableView = {
        
        var searchTableView = SelfSizedTableView()
        searchTableView.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 12.0, maxSize: 16.0), shadowColor: UIColor.darkGray, shadowOffset: CGSize(width: 0.0, height: 1.0), shadowOpacity: 0.3, shadowRadius: 8.0)
        searchTableView.isScrollEnabled = false
        searchTableView.clipsToBounds = true
        searchTableView.separatorInset = .zero
        searchTableView.separatorColor = UIColor.mainDARKPURPLE
        searchTableView.backgroundColor = .white
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = UITableView.automaticDimension
        searchTableView.register(UserSearchCell.self, forCellReuseIdentifier: UserSearchCell.cellIdentifier)
        
        return searchTableView
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        configureCell()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        configureCell()
        
    }
    
    private func configureCell() {
        
        contentView.addSubview(searchScrollView)
        searchScrollView.translatesAutoresizingMaskIntoConstraints = false
        searchScrollView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        searchScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        searchScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: searchHorizontalEdgeInset).isActive = true
        searchScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -searchHorizontalEdgeInset).isActive = true
        
    }
    
}
