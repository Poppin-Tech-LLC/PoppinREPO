//
//  SettingsSecondPageViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 7/30/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

class SettingsSecondPageViewController: UIViewController {
    
    lazy var test: UILabel = {
       let test = UILabel()
        test.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        test.backgroundColor = .clear
        test.textColor = .white
        test.textAlignment = .center
        test.sizeToFit()
        return test
    }()
    
    init(with testString: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        test.text = testString
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(test)
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
