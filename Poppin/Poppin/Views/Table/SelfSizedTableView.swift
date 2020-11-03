//
//  TableView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

class TableView: UITableView {
    
    override var contentSize: CGSize {
        
        didSet {
            
            invalidateIntrinsicContentSize()
            
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        
    }
    
    init(bgColor: UIColor = .clear, cornerRadius: CGFloat = .zero, shadow: Shadow = Shadow(color: .clear, radius: 0.0, x: 0.0, y: 0.0), separatorColor: UIColor = .clear) {
        
        super.init(frame: .zero, style: .plain)
        
        self.isScrollEnabled = true
        self.backgroundColor = bgColor
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
        self.separatorColor = separatorColor
        self.layer.cornerRadius = cornerRadius
        self.apply(shadow: shadow)
        if cornerRadius != 0.0 { self.clipsToBounds = true }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ScrollableTableView: UIScrollView, UIScrollViewDelegate {
    
    private(set) var tableView: TableView
    private(set) var padding: UIEdgeInsets
    
    override init(frame: CGRect) {
        
        self.tableView = TableView()
        self.padding = .zero
        
        super.init(frame: frame)
        
        contentInset = self.padding
        
        configureView()
        
    }
    
    init(tableView: TableView = TableView(), padding: UIEdgeInsets = .zero) {
        
        self.tableView = tableView
        self.padding = padding
        
        super.init(frame: .zero)
        
        contentInset = self.padding
        
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        self.delaysContentTouches = false
        self.alwaysBounceVertical = true
        self.showsVerticalScrollIndicator = false
        self.keyboardDismissMode = .onDrag
        self.isDirectionalLockEnabled = true
        self.delegate = self
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, width: widthAnchor)
        
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        
        if view is TableView { return true }
        
        return super.touchesShouldCancel(in: view)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        scrollView.contentOffset.x = 0

    }
    
}
