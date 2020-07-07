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
    var type: ActivityType?
    var timeCreated: String?
    var category: PopsicleCategory?
}

enum ActivityType: String {
    case ff = "ff" // follow/following type activity
    case ce = "ce" // created event type activity
}

final class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activities = [
        Activity(user: "@somelibyanguy", type: .ff, timeCreated: "2020-02-02 02:00", category: nil),
        Activity(user: "@mrchoperini", type: .ff, timeCreated: "2020-06-30 08:00", category: nil),
        Activity(user: "@yosi", type: .ce, timeCreated: "2019-11-03 12:00", category: .Food),
        Activity(user: "@andres_p", type: .ff, timeCreated: "2020-07-07 14:00", category: nil),
        Activity(user: "@max_ptr$", type: .ce, timeCreated: "2020-07-07 13:58", category: .Social),
        Activity(user: "@helino_is_so_dope_the_coolest_sister_ever", type: .ff, timeCreated: "2014-04-11 02:10", category: nil),
        Activity(user: "@josiahis_dope", type: .ff, timeCreated: "2017-03-25 06:31", category: nil),
        Activity(user: "@amine", type: .ce, timeCreated: "2020-07-07 12:51", category: .Culture)
    ]
    
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
        t.isSpringLoaded = true
        t.allowsSelection = false
        t.showsHorizontalScrollIndicator = false
        t.showsVerticalScrollIndicator = false
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
    
    var following : Bool = false
    var going : Bool = false
    
    lazy var avProfile : ImageBubbleButton = {
        
        var i = ImageBubbleButton(bouncyButtonImage: .defaultUserPicture256)
        i.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
        
    }()
    
    lazy var avDetails : UILabel = {
        
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .caption2)
        l.adjustsFontSizeToFitWidth = true
        l.textColor = .white
        
        l.numberOfLines = 3
//        l.sizeToFit()
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
        
        f.addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)
        
        return f
        
    }()
    
    @objc func toggleFollow() {
        if(following) {
            avFollowButton.backgroundColor = .white
            avFollowButton.setTitle("follow", for: .normal)
            avFollowButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        } else {
            avFollowButton.backgroundColor = .gray
            avFollowButton.setTitle("following", for: .normal)
            avFollowButton.setTitleColor(.white, for: .normal)
        }
        following = !following
    }
    
    lazy var avGoingButton : BouncyButton = {
        
        let f = BouncyButton(bouncyButtonImage: nil)
        f.setTitle("going?", for: .normal)
        f.setTitleColor(.mainDARKPURPLE, for: .normal)
        f.titleLabel?.font = UIFont(name: "Octarine-Bold", size: 15)
        
        f.backgroundColor = .white
        f.contentHorizontalAlignment = .center
        f.layer.cornerRadius = 8
        f.layer.masksToBounds = true
        
        f.translatesAutoresizingMaskIntoConstraints = false
        
        f.addTarget(self, action: #selector(toggleGoing), for: .touchUpInside)
        
        return f
        
    }()
    
    @objc func toggleGoing() {
        if(going) {
            avGoingButton.backgroundColor = .white
            avGoingButton.setTitle("going?", for: .normal)
            avGoingButton.setTitleColor(.mainDARKPURPLE, for: .normal)
        } else {
            avGoingButton.backgroundColor = .sportsDARKGREEN
            avGoingButton.setTitle("going", for: .normal)
            avGoingButton.setTitleColor(.white, for: .normal)
        }
        going = !going
    }
    
    var activity : Activity? {
        didSet {
            print("didSet")
            guard let activityItem = activity else {return}
            
            let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            
            if let user = activityItem.user {
                //avProfile.setImage(, for: .normal)
                attributedText.append(NSAttributedString(string: user, attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .body), NSAttributedString.Key.foregroundColor: UIColor.white]))
            }
            
            if let type = activityItem.type {
                switch(type) {
                case ActivityType.ff :
                    
                    attributedText.append(NSAttributedString(string: " started following you. ", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .body), NSAttributedString.Key.foregroundColor: UIColor.white]))
                    
                    self.contentView.addSubview(avFollowButton)
                    avFollowButton.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
                    avFollowButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -(.getPercentageWidth(percentage: 0))).isActive = true
                    avFollowButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 21)).isActive = true
                    avFollowButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3.25)).isActive = true
                    
                case ActivityType.ce :
                    
                    attributedText.append(NSAttributedString(string: "'s event is about to start. ", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .body), NSAttributedString.Key.foregroundColor: UIColor.white]))
                    
                    avProfile.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 1), left: .getPercentageWidth(percentage: 1), bottom: .getPercentageWidth(percentage: 1), right: .getPercentageWidth(percentage: 1))
                    
                    self.contentView.addSubview(avGoingButton)
                    avGoingButton.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
                    avGoingButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -(.getPercentageWidth(percentage: 0))).isActive = true
                    avGoingButton.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 21)).isActive = true
                    avGoingButton.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 3.25)).isActive = true
                    
                    if let cat = activityItem.category {
                        switch(cat) {
                        case PopsicleCategory.Education :
                            avProfile.changeBouncyButtonImage(image: .educationPopsicleIcon256)
                        case PopsicleCategory.Food :
                            avProfile.changeBouncyButtonImage(image: .foodPopsicleIcon256)
                        case PopsicleCategory.Social :
                            avProfile.changeBouncyButtonImage(image: .socialPopsicleIcon256)
                        case PopsicleCategory.Sports :
                            avProfile.changeBouncyButtonImage(image: .sportsPopsicleIcon256)
                        case PopsicleCategory.Culture :
                            avProfile.changeBouncyButtonImage(image: .culturePopsicleIcon256)
                        case PopsicleCategory.Poppin :
                            avProfile.changeBouncyButtonImage(image: .poppinEventPopsicleIcon256)
                        default:
                            avProfile.changeBouncyButtonImage(image: .defaultPopsicleIcon256)
                        }
                     }

                 }
            }
           
            if let date = activityItem.timeCreated {
                attributedText.append(NSAttributedString(string: agoTime(date: date), attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .body), NSAttributedString.Key.foregroundColor: UIColor.gray]))
            }
            
            avDetails.attributedText = attributedText
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .mainDARKPURPLE
        
        self.contentView.addSubview(avProfile)
        self.contentView.addSubview(avDetails)
        
        avProfile.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        avProfile.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: .getPercentageWidth(percentage: 0.5)).isActive = true
        avProfile.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 10)).isActive = true
        avProfile.heightAnchor.constraint(equalTo: avProfile.widthAnchor).isActive = true
        
        avDetails.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        avDetails.leadingAnchor.constraint(equalTo: self.avProfile.leadingAnchor, constant: .getPercentageWidth(percentage: 12)).isActive = true
        avDetails.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 44)).isActive = true
         avDetails.heightAnchor.constraint(equalToConstant: .getPercentageHeight(percentage: 6)).isActive = true
        
     }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    /* HELPER function for converting date string into more concise "ago" string */
    func agoTime(date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm'"
        let fromDate = dateFormatter.date(from: date)
        //let fromDate = Date()
        let toDate = Date()

        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate!, to: toDate).year, interval > 0  {

            if(interval >= 1) {
                return "\(interval)" + "y"
            }
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate!, to: toDate).month, interval > 0  {

            if(interval >= 1) {
                return "\(interval)" + "mo"
            }
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate!, to: toDate).day, interval > 0  {

            if(interval >= 1) {
                return "\(interval)" + "d"
            }
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate!, to: toDate).hour, interval > 0 {

            if(interval >= 1) {
                return "\(interval)" + "h"
            }
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate!, to: toDate).minute, interval > 0 {

            if(interval >= 1) {
                return "\(interval)" + "m"
            }
        }
        
        // Seconds
        if let interval = Calendar.current.dateComponents([.second], from: fromDate!, to: toDate).minute, interval > 0 {

            if(interval >= 1) {
                return "\(interval)" + "s"
            }
        }

        return ""
    }

}
