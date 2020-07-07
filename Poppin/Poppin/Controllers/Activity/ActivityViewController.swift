//
//  ActivityViewController.swift
//  Poppin
//
//  Created by Josiah Aklilu on 7/2/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

//
//  MenuViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 6/25/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Activity {
    var user: String?
    var fIndicator: Bool?
    var timeCreated: String?
}

final class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activities = [Activity(user: "@somelibyanguy", fIndicator: true, timeCreated: "2s"), Activity(user: "@mrchoperini", fIndicator: true, timeCreated: "3d"), Activity(user: "@yosi", fIndicator: true, timeCreated: "1w"), Activity(user: "@andres_p", fIndicator: true, timeCreated: "1w"), Activity(user: "@max_ptr$", fIndicator: true, timeCreated: "2w"), Activity(user: "@helino", fIndicator: true, timeCreated: "4w"), Activity(user: "@josiahisdope", fIndicator: true, timeCreated: "3mo"), Activity(user: "@amine", fIndicator: true, timeCreated: "4y")]
    
    let avInsetY: CGFloat = .getPercentageWidth(percentage: 4)
    let avInsetX: CGFloat = .getPercentageWidth(percentage: 3)
    let avInnerInset: CGFloat = .getPercentageWidth(percentage: 5)
    
    weak var delegate: ActivityDelegate?
    
    lazy private var activityLabel: UILabel = {
        
        var activityLabel = UILabel()
        activityLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title1)
        activityLabel.textColor = .white
        activityLabel.text = "Activity"
        activityLabel.textAlignment = .center
        
        return activityLabel
        
    }()
    
    lazy private var popsicleBorderImageView: UIImageView = {
        
        var popsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.white))
        popsicleBorderImageView.contentMode = .scaleAspectFit
        return popsicleBorderImageView
        
    }()
    
    lazy private var avFeed: UITableView = {
        
        var t = UITableView()
        t.backgroundColor = .mainDARKPURPLE
        return t
        
    }()
    
    lazy private var avBorderView: UIView = {
        
        var avBorderView = UIView()
        avBorderView.backgroundColor = .white
        avBorderView.alpha = 1.0
        
        avBorderView.translatesAutoresizingMaskIntoConstraints = false
        avBorderView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return avBorderView
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .mainDARKPURPLE
        
        view.addSubview(avBorderView)
        avBorderView.translatesAutoresizingMaskIntoConstraints = false
        avBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        avBorderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        avBorderView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(activityLabel)
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        activityLabel.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 30)).isActive = true
        activityLabel.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 5)).isActive = true
        activityLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        activityLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        view.addSubview(popsicleBorderImageView)
        popsicleBorderImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleBorderImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: avInnerInset).isActive = true
        popsicleBorderImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -avInnerInset).isActive = true
        popsicleBorderImageView.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: .getPercentageHeight(percentage: 0.1)).isActive = true
        
        view.addSubview(avFeed)
        avFeed.translatesAutoresizingMaskIntoConstraints = false
        avFeed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: avInnerInset).isActive = true
        avFeed.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -avInnerInset).isActive = true
        avFeed.topAnchor.constraint(equalTo: popsicleBorderImageView.bottomAnchor, constant: .getPercentageHeight(percentage: 1)).isActive = true
        avFeed.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        avFeed.dataSource = self
        avFeed.delegate = self
        avFeed.register(ActivityCell.self, forCellReuseIdentifier: "avCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "avCell", for: indexPath) as! ActivityCell
        cell.activity = activities[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .getPercentageHeight(percentage: 10)
    }
}

class ActivityCell : UITableViewCell {
    
    lazy var avProfile : ImageBubbleButton = {
        var i = ImageBubbleButton(bouncyButtonImage: .defaultUserPicture256)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    lazy var avDetails : UILabel = {
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .caption2)
        l.textColor = .white
        l.numberOfLines = 2
        l.sizeToFit()
        l.textAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    lazy var avFollowButton : BouncyButton = {
        let f = BouncyButton(bouncyButtonImage: nil)
        f.setTitle("follow", for: .normal)
        f.setTitleColor(.mainDARKPURPLE, for: .normal)
        f.titleLabel?.font = UIFont(name: "Octarine-Bold", size: 14)
        f.backgroundColor = .white
        f.contentHorizontalAlignment = .center
        f.layer.cornerRadius = 8
        f.layer.masksToBounds = true
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    var activity : Activity? {
        didSet {
            print("didSet")
            guard let activityItem = activity else {return}
            let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            if let user = activityItem.user {
                //avProfile.setImage(, for: .normal)
                attributedText.append(NSAttributedString(string: user, attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .body), NSAttributedString.Key.foregroundColor: UIColor.white]))
            }
            if let fIndicator = activityItem.fIndicator {
                if(fIndicator) {
                    attributedText.append(NSAttributedString(string: " started following you. ", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .body), NSAttributedString.Key.foregroundColor: UIColor.white]))
                }
            }
           
            if let date = activityItem.timeCreated {
                attributedText.append(NSAttributedString(string: date, attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .body), NSAttributedString.Key.foregroundColor: UIColor.gray]))
            }
            avDetails.attributedText = attributedText
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .mainDARKPURPLE
        
        self.contentView.addSubview(avProfile)
        self.contentView.addSubview(avDetails)
        self.contentView.addSubview(avFollowButton)
        
        avProfile.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        avProfile.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .getPercentageWidth(percentage: 1)).isActive = true
        avProfile.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 9)).isActive = true
        avProfile.heightAnchor.constraint(equalTo: avProfile.widthAnchor).isActive = true
        
        avDetails.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        avDetails.leadingAnchor.constraint(equalTo: self.avProfile.leadingAnchor, constant: .getPercentageWidth(percentage: 12)).isActive = true
        avDetails.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 50)).isActive = true
        
        avFollowButton.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        avFollowButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 14)).isActive = true
        avFollowButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3)).isActive = true
        avFollowButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -(.getPercentageWidth(percentage: 1))).isActive = true
     }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

}
