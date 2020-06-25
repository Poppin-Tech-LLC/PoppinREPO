//
//  MenuViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/25/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {
    
    lazy private var menuBorderView: UIView = {
        
        var menuBorderView = UIView()
        menuBorderView.backgroundColor = .white
        return menuBorderView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .mainDARKPURPLE
        
        view.addSubview(menuBorderView)
        menuBorderView.translatesAutoresizingMaskIntoConstraints = false
        menuBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        menuBorderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBorderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuBorderView.widthAnchor.constraint(equalToConstant: 1.0).isActive = true
        
    }
    
}
