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

fileprivate var activities : [ActivityModel] = []
fileprivate var requests: [ActivityModel] = []

final class ActivityView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    weak var delegate: ActivityDelegate?
    
    
    
    private var ro: Bool = false
    
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
    
    lazy var avFeed: UITableView = {
        
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
        avFeed.register(RequestCell.self, forCellReuseIdentifier: "rCell")
        avFeed.register(RequestsCell.self, forCellReuseIdentifier: "rsCell")
        
    }
    
    private func populateActivities() {
        
        activities = []
        requests = []
        
        let ref = Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).collection("activities")

        ref.getDocuments(completion: { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if((((document.data()["details"] as? String)?.contains("requested")))!) {
                            requests.append(ActivityModel(rId: document.documentID, requesterId: document.data()["requesterId"] as? String, inducedBy: document.data()["inducedBy"] as? String, details: document.data()["details"] as? String, dateInduced: document.data()["dateInduced"] as? String))
                        } else {
                            activities.append(ActivityModel(inducedBy: document.data()["inducedBy"] as? String, details: document.data()["details"] as? String, dateInduced: document.data()["dateInduced"] as? String))
                        }
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "rsCell", for: indexPath) as! RequestsCell
            
            if(requests.count == 1) { cell.requestLabel.text = "\(requests.count) new request"} else { cell.requestLabel.text = "\(requests.count) new requests" }
            
            let gesture = UITapGestureRecognizer(target: self, action: #selector(showRequests(sender:)))
            gesture.addTarget(cell, action: #selector(RequestsCell.openRequests))
            cell.addGestureRecognizer(gesture)
            
            return cell
            
        } else {
            
            let ac = activities[indexPath.row - 1]
            
            if(ac.details!.contains("requested")) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "rCell", for: indexPath) as! RequestCell
                
                let username = ac.inducedBy!
                cell.username = username
                cell.reqId = ac.rId!
                
                //TO-DO: ff request functionality
                //cell.requesterId = ac.requesterId!
                
                let attributedString = NSMutableAttributedString(string: "@" + username, attributes:[NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1), NSAttributedString.Key.attachment: URL(string: "http://www.google.com")!])
                
                attributedString.append(NSAttributedString(string: ac.details!, attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .caption1)]))
                
                cell.requestDetails.attributedText = attributedString
                
                cell.requestPic.setImage(.defaultUserPicture128, for: .normal)
                cell.requestPic.contentEdgeInsets = UIEdgeInsets()

                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "avCell", for: indexPath) as! ActivityCell
                
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
        if let interval = Calendar.current.dateComponents([.second], from: fromDate!, to: toDate).second, interval > 0 {
    
            if(interval >= 1) {
                return "\(interval)" + "s"
            }
        }
    
        return "now"
    }
    
    @objc func showRequests(sender: RequestsCell) {
        if(requests.count > 0) {
            if(ro) {
            //            sender.requestChevron.setImage(UIImage(systemSymbol: .chevronDown, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)).withTintColor(.white).withRenderingMode(.alwaysOriginal), for: .normal)
                        var rc = 0
                        avFeed.beginUpdates()
                        for i in (1...requests.count) {
                            avFeed.deleteRows(at: [IndexPath(row: i, section: 0)], with: .top)
                            activities.remove(at: i-1)
                            if(requests[i-1-rc].details!.contains("-")) {
                                requests.remove(at: i-1)
                                avFeed.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                                rc = rc + 1
                            }
                        }
                        avFeed.endUpdates()
                    } else {
            //            sender.requestChevron.setImage(UIImage(systemSymbol: .chevronUp, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)).withTintColor(.white).withRenderingMode(.alwaysOriginal), for: .normal)
                        avFeed.beginUpdates()
                        for i in (1...requests.count) {
                            avFeed.insertRows(at: [IndexPath(row: i, section: 0)], with: .top)
                            activities.insert(requests[i-1], at: i-1)
                        }
                        avFeed.endUpdates()
                    }
                    
                    ro = !ro
        }
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




class RequestCell : UITableViewCell {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    fileprivate var username: String = ""
    fileprivate var reqId: String = ""
    fileprivate var requesterId: String = ""
        
    lazy var requestPic : ImageBubbleButton = {
            
        var i = ImageBubbleButton(bouncyButtonImage: .culturePopsicleIcon128)
        i.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        i.contentEdgeInsets = UIEdgeInsets(top: .getPercentageWidth(percentage: 1), left: .getPercentageWidth(percentage: 1), bottom: .getPercentageWidth(percentage: 1), right: .getPercentageWidth(percentage: 1))
            
        i.translatesAutoresizingMaskIntoConstraints = false
        i.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 8)).isActive = true
        i.heightAnchor.constraint(equalTo: i.widthAnchor).isActive = true
            
        return i
            
    }()
        
    lazy var requestDetails : UILabel = {
            
        let l = UILabel()
        l.font = .dynamicFont(with: "Octarine-Light", style: .caption1)
        l.adjustsFontSizeToFitWidth = false
        l.textColor = .white
        l.numberOfLines = 2
        l.textAlignment = .left
            
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 46)).isActive = true
            
        return l
            
    }()
        
    lazy var acceptButton : UIButton = {
            
        let b = UIButton()
        b.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font =  .dynamicFont(with: "Octarine-Bold", style: .caption1)
        b.setTitle("Accept", for: .normal)
        b.layer.cornerRadius = 7
            
        b.translatesAutoresizingMaskIntoConstraints = false
        b.widthAnchor.constraint(equalToConstant: .getPercentageWidth(percentage: 18)).isActive = true
        
        b.addTarget(self, action: #selector(acceptRequest), for: .touchUpInside)
            
        return b
            
    }()
        
    lazy var rStackView : UIStackView = {
            
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .fill
            
        s.addArrangedSubview(requestPic)
        s.addArrangedSubview(requestDetails)
        s.addArrangedSubview(acceptButton)
            
        s.setCustomSpacing(.getPercentageWidth(percentage: 3), after: requestPic)
        s.setCustomSpacing(.getPercentageWidth(percentage: 6), after: requestDetails)
            
        return s
            
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
            
        backgroundColor = .mainDARKPURPLE
        
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        self.contentView.layer.cornerRadius = 10
            
        self.contentView.addSubview(rStackView)
        rStackView.anchor(top: self.contentView.topAnchor, leading: self.contentView.leadingAnchor, bottom: self.contentView.bottomAnchor, trailing: self.contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: xInset, bottom: 0, right: xInset/1.5))
        
        acceptButton.isHidden = false
            
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
           
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: xInset/4, left: yInset/2, bottom: xInset/4, right: yInset/2))
    }
    
    @objc func acceptRequest() {
        
        acceptButton.isHidden = true
        
        let attributedString = NSMutableAttributedString(string: "You've accepted " , attributes:[NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .caption1)])
        
        attributedString.append(NSAttributedString(string: "@\(username)'s", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Bold", style: .caption1)]))
        
        attributedString.append(NSAttributedString(string: " follow request.", attributes: [NSAttributedString.Key.font: UIFont.dynamicFont(with: "Octarine-Light", style: .caption1)]))
        
        for i in (0...requests.count-1) {
            if(requests[i].inducedBy == username) {
                requests[i].details = "-"
            }
        }
        
        requestDetails.attributedText = attributedString
        
        // create activity for following someone
        Firestore.firestore().collection("users").document( Auth.auth().currentUser!.uid).collection("activities").addDocument(data: [
                    "inducedBy" : username,
                    "details" : " started following you.",
                    "dateInduced" : Date().toString(.custom("yyyy'-'MM'-'dd' 'HH':'mm'"))])
                { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added.")
                    }
                }
        
        // delete the request to follow
        Firestore.firestore().collection("users").document( Auth.auth().currentUser!.uid).collection("activities").document(reqId).delete()
            { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        
        //TO-DO: ff request functionality
        // update the requester's following list and the current user's followers list
//        Firestore.firestore().collection("users").document(requesterId).updateData(["following.\(Auth.auth().currentUser!.uid)" : true,
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
//
//        Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).updateData(["followers.\(requesterId)" : true,
//        ]) { err in
//            if let err = err {
//                print("Error updating document: \(err)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
    
    }
        
}


    

class RequestsCell : UITableViewCell {
    
    private let xInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let yInset: CGFloat = .getPercentageWidth(percentage: 4)
    
    private var ro: Bool = false
    
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
    
    lazy var requestChevron : ImageBubbleButton = {
        
        var i = ImageBubbleButton(bouncyButtonImage: UIImage(systemSymbol: .chevronDown, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)).withTintColor(.white).withRenderingMode(.alwaysOriginal))
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
        s.addArrangedSubview(requestChevron)
        
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
       
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: xInset/3, left: yInset/2, bottom: xInset/3, right: yInset/2))
    }
    
    @objc func openRequests() {
        
        if(ro) {
            requestChevron.setImage(UIImage(systemSymbol: .chevronDown, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)).withTintColor(.white).withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            requestChevron.setImage(UIImage(systemSymbol: .chevronUp, withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .medium)).withTintColor(.white).withRenderingMode(.alwaysOriginal), for: .normal)
        }
                
        ro = !ro
    }
    
}


