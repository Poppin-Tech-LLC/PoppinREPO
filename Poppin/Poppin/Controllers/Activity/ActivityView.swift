//
//  ActivityView.swift
//  Poppin
//
//  Created by Josiah Aklilu on 8/6/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import FirebaseUI
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PreviewActivityView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = ActivityView
    
}

struct TestPreviewActivityView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewActivityView
    
}

final class ActivityView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    weak var delegate: ActivityDelegate?
    
    private var activities : [ActivityModel] = []
    
    lazy private var cardView: UIView = {
       
        var cardView = UIView()
       
        cardView.backgroundColor = .mainDARKPURPLE
        
        cardView.addSubview(avBorderView)
        avBorderView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor)
        
        cardView.addSubview(activityLabel)
        activityLabel.anchor(top: cardView.topAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: yInset*3.5, left: 0, bottom: 0, right: 0))
        
        cardView.addSubview(popsicleBorderImageView)
        popsicleBorderImageView.anchor(top: cardView.topAnchor, centerX: cardView.centerXAnchor, padding: UIEdgeInsets(top: yInset*5.5, left: 0, bottom: 0, right: 0))
        
        cardView.addSubview(avFeed)
        avFeed.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: yInset*8, left: xInset*0.2, bottom: yInset*2, right: 0))
        
        return cardView
        
    }()
    
    lazy private var activityLabel: UILabel = {
        
        var activityLabel = UILabel()
        activityLabel.font = .dynamicFont(with: "Octarine-Bold", style: .title2)
        activityLabel.textColor = .white
        activityLabel.text = "Activity"
        activityLabel.textAlignment = .center
        
        return activityLabel
        
    }()
    
    lazy private var popsicleBorderImageView: UIImageView = {
        
        var popsicleBorderImageView = UIImageView(image: UIImage.popsicleBorder1024.withTintColor(.white))
        popsicleBorderImageView.contentMode = .scaleAspectFit
        
        popsicleBorderImageView.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 80)).isActive = true
        
        return popsicleBorderImageView
        
    }()
    
    lazy private var avBorderView: UIView = {
        
        var avBorderView = UIView()
        avBorderView.backgroundColor = .white
        avBorderView.alpha = 1.0
        
        avBorderView.translatesAutoresizingMaskIntoConstraints = false
        avBorderView.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        return avBorderView
        
    }()
    
    lazy private var avFeed: UITableView = {
        
        var t = UITableView()
        t.backgroundColor = .mainDARKPURPLE
        t.isSpringLoaded = true
        t.allowsSelection = false
        t.showsHorizontalScrollIndicator = false
        t.showsVerticalScrollIndicator = false
        t.separatorStyle = .none
        return t
        
    }()
    
    init() {
        
        super.init(frame: .zero)
        
        configureView()
        populateActivities()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        configureView()
        populateActivities()
        
    }
    
    private func configureView() {
        
        addSubview(cardView)
        cardView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        avFeed.dataSource = self
        avFeed.delegate = self
        avFeed.register(ActivityCell.self, forCellReuseIdentifier: "avCell")
        avFeed.register(RequestsCell.self, forCellReuseIdentifier: "rCell")
        
    }
    
    private func populateActivities() {
        
        let ref = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("activities")

        ref.getDocuments(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.activities.append(ActivityModel(inducedBy: document.data()["inducedBy"] as? String, details: document.data()["details"] as? String, dateInduced: document.data()["dateInduced"] as? String))
                        self.avFeed.reloadData()
                    }
                }
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.row == 0) {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath) as! RequestsCell
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "avCell", for: indexPath) as! ActivityCell
            
            let ac = activities[indexPath.row - 1]
            
            let username = ac.inducedBy!
            let attributedString = NSMutableAttributedString(string: "@" + username, attributes:[NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1), NSAttributedString.Key.attachment: URL(string: "http://www.google.com")!])
            
            attributedString.append(NSAttributedString(string: ac.details!, attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .caption1)]))
            
            cell.activityDetails.attributedText = attributedString
            
            cell.activityDate.text = agoTime(date: ac.dateInduced!)
            
            cell.activityPic.setImage(.defaultUserPicture128, for: .normal)
            cell.activityPic.contentEdgeInsets = UIEdgeInsets()

            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .getPercentageHeight(percentage: 7)
    }
    
    func agoTime(date: String) -> String {
    
        let fromDate = Date(date)
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
    
        return "n/a"
    }
    
}



class ActivityCell : UITableViewCell {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    lazy var activityPic : ImageBubbleButton = {
        
        var i = ImageBubbleButton(bouncyButtonImage: .culturePopsicleIcon128)
        i.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        i.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 1), left: .getPercentageWidth(percentage: 1), bottom: .getPercentageWidth(percentage: 1), right: .getPercentageWidth(percentage: 1))
        
        i.translatesAutoresizingMaskIntoConstraints = false
        i.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 9)).isActive = true
        i.heightAnchor.constraint(equalTo: i.widthAnchor).isActive = true
        
        return i
        
    }()
    
    lazy var activityDetails : UILabel = {
        
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .caption1)
        l.adjustsFontSizeToFitWidth = false
        l.textColor = .white
        l.numberOfLines = 2
        l.textAlignment = .left
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 50)).isActive = true
        
        return l
        
    }()
    
    lazy var activityDate : UILabel = {
        
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        l.adjustsFontSizeToFitWidth = false
        l.textColor = .gray
        l.numberOfLines = 1
        l.textAlignment = .center
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 13)).isActive = true
        
        return l
        
    }()
    
    lazy var eventStackView : UIStackView = {
        
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .equalCentering
        
        s.addArrangedSubview(activityPic)
        s.addArrangedSubview(activityDetails)
        s.addArrangedSubview(activityDate)
        
        s.setCustomSpacing(.getPercentageWidth(percentage: 1.5), after: activityPic)
        s.setCustomSpacing(.getPercentageWidth(percentage: 3), after: activityDetails)
        
        return s
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainDARKPURPLE
        
        self.contentView.addSubview(eventStackView)
        eventStackView.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: self.contentView.bottomAnchor, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset))
        
     }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: .getPercentageHeight(percentage: 0.5), left: 0, bottom: .getPercentageHeight(percentage: 0.5), right: 0))
    }
    
}

    

class RequestsCell : UITableViewCell {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    lazy var requestLabel : UILabel = {
        
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        l.adjustsFontSizeToFitWidth = false
        l.textColor = .white
        l.numberOfLines = 1
        l.textAlignment = .left
        l.text = "No new requests"
        
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 40)).isActive = true
        
        return l
        
    }()
    
    lazy var requestCount : ImageBubbleButton = {
        
        var i = ImageBubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronRight, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)).withTintColor(.white).withRenderingMode(.alwaysOriginal))
        i.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 1), left: .getPercentageWidth(percentage: 1), bottom: .getPercentageWidth(percentage: 1), right: .getPercentageWidth(percentage: 1))
        i.backgroundColor = .mainDARKPURPLE
        
        i.translatesAutoresizingMaskIntoConstraints = false
        i.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 5.5)).isActive = true
        i.heightAnchor.constraint(equalTo: i.widthAnchor).isActive = true
        
        return i
        
    }()
    
    lazy var rStackView : UIStackView = {
        
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .equalCentering
        
        s.addArrangedSubview(requestLabel)
        s.addArrangedSubview(requestCount)
        
        s.setCustomSpacing(.getPercentageWidth(percentage: 33), after: requestLabel)
    
        return s
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainDARKPURPLE
        
        self.contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        self.contentView.layer.cornerRadius = 10
        
        self.contentView.addSubview(rStackView)
        rStackView.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: self.contentView.bottomAnchor, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset))
        
     }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
       
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: xInset/5, left: yInset/2, bottom: xInset/5, right: yInset/2))
    }
    
}


