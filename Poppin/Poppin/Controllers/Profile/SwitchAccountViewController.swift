//
//  SwitchAccountViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 7/14/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

class SwitchAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    weak var delegate: SwitchAccountDelegate?
    
    var accounts: [UserData] = []
    
    lazy var test: UIView = {
        let test = UIView()
        test.backgroundColor = .red
        return test
    }()
    
    lazy var accountsTable: UITableView = {
        let accountsTable = UITableView()
        accountsTable.delegate = self
        accountsTable.dataSource = self
        
        return accountsTable
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainDARKPURPLE
        
        view.layer.cornerRadius = 20
        
        view.addSubview(accountsTable)
        accountsTable.translatesAutoresizingMaskIntoConstraints = false
        accountsTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        accountsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        accountsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        accountsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserSearchCell.cellIdentifier, for: indexPath) as! UserSearchCell
        return cell
    }
    

    
}

