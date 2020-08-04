//
//  rsvpViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

final class RSVPViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let rsvpVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let rsvpHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    
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
    
    lazy private var exitButton: BubbleButton = {
        
        var eb = BubbleButton(bouncyButtonImage: UIImage(systemSymbol: .multiply, withConfiguration: UIImage.SymbolConfiguration(pointSize: 0, weight: .medium)).withTintColor(.white, renderingMode: .alwaysOriginal))
        eb.contentEdgeInsets = UIEdgeInsets(top: rsvpTopLabel.intrinsicContentSize.height*0.5, left: rsvpTopLabel.intrinsicContentSize.height*0.5, bottom: rsvpTopLabel.intrinsicContentSize.height*0.5, right: rsvpTopLabel.intrinsicContentSize.height*0.5)
        eb.backgroundColor = .clear
        eb.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        eb.translatesAutoresizingMaskIntoConstraints = false
        eb.heightAnchor.constraint(equalToConstant: rsvpTopLabel.intrinsicContentSize.height*2).isActive = true
        eb.widthAnchor.constraint(equalTo: eb.heightAnchor).isActive = true
        
        return eb
        
    }()
    
    @objc private func exit() {
        navigationController?.popViewController(animated: true)
    }
    
    lazy private var rsvpTopLabel: UILabel = {
        
        var l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Bold", style: .headline)
        l.text = "My Week"
        l.numberOfLines = 1
        l.textAlignment = .center
        l.textColor = .white
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.heightAnchor.constraint(equalToConstant: l.intrinsicContentSize.height).isActive = true
        l.widthAnchor.constraint(equalToConstant: l.intrinsicContentSize.width).isActive = true
        
        return l
        
    }()
    
    lazy private var rsvpFeed: UITableView = {
     
        var t = UITableView()
        t.backgroundColor = .clear
        t.isSpringLoaded = true
        t.allowsSelection = false
        t.showsHorizontalScrollIndicator = false
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        
        return t
        
    }()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        
        label.font = UIFont.dynamicFont(with: "Octarine-Bold", style: .subheadline)
        let sectionName: String
        switch section {
            case 0:
                sectionName = "Today"
            case 1:
                sectionName = "Upcoming week"
            case 2:
                sectionName = "Past"
            // ...
            default:
                sectionName = ""
        }
        label.text = sectionName
        label.textColor = .white
        
        view.addSubview(label)
        view.backgroundColor = .clear
    
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 5
            case 1:
                return 3
            case 2:
                return 7
            // ...
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myEventsCell", for: indexPath) as! MyEventsCell
    
        let rPG = Int.random(in: 1 ... 10000000)
        if(rPG < 10000) {
            cell.eventPG.text = "\(rPG)"
        } else if(rPG < 1000000) {
            cell.eventPG.text = "\(round(10.0*(Double(rPG)/1000.0))/10.0)K"
        } else {
            cell.eventPG.text = "\(round(10.0*(Double(rPG)/1000000.0))/10.0)M"
        }
        
        let pi = Bool.random()
        cell.privacyIcon.image =
            pi ?
            UIImage(systemSymbol: .lockFill).withTintColor(.mainDARKPURPLE).withRenderingMode(.alwaysOriginal) :
            UIImage(systemSymbol: .globe).withTintColor(.mainDARKPURPLE).withRenderingMode(.alwaysOriginal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .getPercentageHeight(percentage: 8)
    }
    
    override func viewDidLoad() {
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(exitButton)
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: rsvpVerticalEdgeInset - rsvpTopLabel.intrinsicContentSize.height*0.25).isActive = true
        exitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: rsvpHorizontalEdgeInset - rsvpTopLabel.intrinsicContentSize.height*0.25).isActive = true
        
        view.addSubview(rsvpTopLabel)
        rsvpTopLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rsvpTopLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: rsvpVerticalEdgeInset + rsvpTopLabel.intrinsicContentSize.height*0.25).isActive = true
        
        view.addSubview(rsvpFeed)
        rsvpFeed.translatesAutoresizingMaskIntoConstraints = false
        rsvpFeed.topAnchor.constraint(equalTo: rsvpTopLabel.bottomAnchor, constant: rsvpVerticalEdgeInset).isActive = true
        rsvpFeed.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -rsvpVerticalEdgeInset).isActive = true
        rsvpFeed.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: rsvpHorizontalEdgeInset).isActive = true
        rsvpFeed.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -rsvpHorizontalEdgeInset).isActive = true
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = rsvpFeed.bounds
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor]
//        gradientLayer.locations = [0, 0.5]
//        //rsvpFeed.layer.addSublayer(gradientLayer)
//        rsvpFeed.layer.mask = gradientLayer
        
        rsvpFeed.dataSource = self
        rsvpFeed.delegate = self
        rsvpFeed.register(MyEventsCell.self, forCellReuseIdentifier: "myEventsCell")
    }
    
}
