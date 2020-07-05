//
//  ActivityViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 7/2/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit

class ActivityViewController : UIViewController {
    
    lazy var activityTitle : UILabel = {
        var l = UILabel()
        l.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .title1)
        l.text = "Activity"
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    
    lazy var tableView : UITableView = {
        var t = UITableView()
        return t
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        /* FOR TRIAL PURPOSES */
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    
        /* FOR TRIAL PURPOSES */
        modalPresentationStyle = .fullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainDARKPURPLE
        
        view.addSubview(activityTitle)
        activityTitle.translatesAutoresizingMaskIntoConstraints = false
        activityTitle.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 30)).isActive = true
        activityTitle.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
        activityTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 3)).isActive = true
        activityTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 100)).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 9)).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
