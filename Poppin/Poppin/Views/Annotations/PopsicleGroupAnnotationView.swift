//
//  PopsicleGroupAnnotationView.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/29/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import MapKit
import SwiftUI

final class EventGroupAnnotationView: MKAnnotationView {
    
    static let defaultReuseIdentifier = "EventGroupAnnotationView"
    
    lazy private var containerView: UIView = {
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        _ = [groupPopsicleContainerView, groupCountContainerView].map { containerView.addSubview($0) }
        
        groupPopsicleContainerView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, size: CGSize(width: groupPopsicleIcon.intrinsicContentSize.width, height: 0.0))
        
        groupCountContainerView.anchor(top: containerView.topAnchor, leading: groupPopsicleContainerView.centerXAnchor, trailing: containerView.trailingAnchor)
        
        return containerView
        
    }()
    
    lazy private var groupPopsicleContainerView: UIView = {
        
        let groupPopsicleContainerView = UIView()
        groupPopsicleContainerView.backgroundColor = .clear
        
        _ = [groupPopsicleShadowIcon, groupPopsicleIcon].map { groupPopsicleContainerView.addSubview($0) }
        
        groupPopsicleIcon.anchor(top: groupPopsicleContainerView.topAnchor, leading: groupPopsicleContainerView.leadingAnchor, trailing: groupPopsicleContainerView.trailingAnchor)
        
        groupPopsicleShadowIcon.anchor(leading: groupPopsicleContainerView.leadingAnchor, bottom: groupPopsicleContainerView.bottomAnchor, trailing: groupPopsicleContainerView.trailingAnchor, centerY: groupPopsicleIcon.bottomAnchor, centerOffset: CGSize(width: 0.0, height: -1.5))
        
        return groupPopsicleContainerView
        
    }()
    
    lazy private var groupPopsicleIcon = UIImageView(image: UIImage.popsicleGroupIcon256.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0))))
    
    lazy private var groupPopsicleShadowIcon: UIImageView = {
        
        let groupPopsicleShadowIcon = UIImageView(image: UIImage.defaultPopsicleIconShadow256.scalePreservingAspectRatio(targetSize: CGSize(width: .width(percent: 12.0), height: .width(percent: 12.0))))
        groupPopsicleShadowIcon.alpha = 0.6
        return groupPopsicleShadowIcon
        
    }()
    
    lazy private var groupCountContainerView: CardView = {
        
        let groupCountContainerView = CardView(bgColor: .mainDARKPURPLE, padding: UIEdgeInsets(top: .width(percent: 0.77), left: .width(percent: 0.77), bottom: .width(percent: 0.77), right: .width(percent: 0.77)), cornerRadius: .width(percent: 2.0))
        
        groupCountContainerView.addSubview(groupCountLabel)
        
        groupCountLabel.anchor(top: groupCountContainerView.layoutMarginsGuide.topAnchor, leading: groupCountContainerView.layoutMarginsGuide.leadingAnchor, bottom: groupCountContainerView.layoutMarginsGuide.bottomAnchor, trailing: groupCountContainerView.layoutMarginsGuide.trailingAnchor)
        
        return groupCountContainerView
        
    }()
    
    lazy private var groupCountLabel = OctarineLabel(text: "2", color: .white, bold: true, style: .caption2, alignment: .center, lineLimit: 1)
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        
        frame = CGRect(x: 0.0, y: 0.0, width: groupPopsicleIcon.intrinsicContentSize.width + .width(percent: 1.0) + groupCountLabel.intrinsicContentSize.width, height: groupPopsicleIcon.intrinsicContentSize.height + (groupPopsicleShadowIcon.intrinsicContentSize.height*0.5) - 1.5)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        addSubview(containerView)
        containerView.frame = bounds
        
    }
    
    func setGroupCount(count: Int) {
        
        canShowCallout = false
        displayPriority = .required
        collisionMode = .rectangle
        
        if count < 2 {
            
            groupCountLabel.text = "2"
            
        } else if count > 99 {
            
            groupCountLabel.text = "99+"
            
        } else {
            
            groupCountLabel.text = String(count)
            
        }
        
        frame = CGRect(x: 0.0, y: 0.0, width: groupPopsicleIcon.intrinsicContentSize.width + .width(percent: 1.0) + groupCountLabel.intrinsicContentSize.width, height: groupPopsicleIcon.intrinsicContentSize.height + (groupPopsicleShadowIcon.intrinsicContentSize.height*0.5) - 1.5)
        
        containerView.frame = bounds
        
    }
    
}

struct PreviewEventGroupAnnotationView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIViewType {
        
        return UIViewType()
        
    }
    
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    typealias UIViewType = EventGroupAnnotationView
    
}

struct TestPreviewEventGroupAnnotationView: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewEventGroupAnnotationView
    
}


final class PopsicleGroupAnnotationView: MKAnnotationView {
    
    public static let defaultPopsicleGroupAnnotationViewReuseIdentifier = "PopsicleGroupAnnotationView"
    
    private let popsicleHeight: CGFloat = .getPercentageWidth(percentage: 12.5)
    private let popsicleWidth: CGFloat = .getPercentageWidth(percentage: 12.0)
    
    private let innerInsetX: CGFloat = .getPercentageWidth(percentage: 3)
    private let innerInsetY: CGFloat = .getPercentageWidth(percentage: 2.5)
    
    private(set) var popsicleGroupCount: Int = 0
    
    lazy private var bubbleViewWidthConstraint: NSLayoutConstraint = {
        
        var bubbleViewWidthConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)
        return bubbleViewWidthConstraint
        
    }()
    
    lazy private var bubbleViewHeightConstraint: NSLayoutConstraint = {
        
        var bubbleViewHeightConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .height, relatedBy: .equal, toItem: popsicleGroupCountBubbleView, attribute: .width, multiplier: 1.0, constant: 0.0)
        return bubbleViewHeightConstraint
        
    }()
    
    lazy private var popsicleGroupContainerView: UIView = {
        
        var popsicleGroupContainerView = UIView()
        popsicleGroupContainerView.backgroundColor = .clear
        
        popsicleGroupContainerView.addSubview(popsicleGroupIconImageView)
        popsicleGroupIconImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupIconImageView.centerYAnchor.constraint(equalTo: popsicleGroupContainerView.centerYAnchor).isActive = true
        popsicleGroupIconImageView.leadingAnchor.constraint(equalTo: popsicleGroupContainerView.leadingAnchor).isActive = true
        popsicleGroupIconImageView.heightAnchor.constraint(equalToConstant: popsicleHeight).isActive = true
        popsicleGroupIconImageView.widthAnchor.constraint(equalToConstant: popsicleWidth).isActive = true
        
        popsicleGroupContainerView.addSubview(popsicleGroupCountBubbleView)
        popsicleGroupCountBubbleView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupCountBubbleView.topAnchor.constraint(equalTo: popsicleGroupIconImageView.topAnchor).isActive = true
        popsicleGroupCountBubbleView.centerXAnchor.constraint(equalTo: popsicleGroupIconImageView.trailingAnchor).isActive = true
        bubbleViewWidthConstraint.isActive = true
        bubbleViewHeightConstraint.isActive = true
        
        popsicleGroupContainerView.addSubview(popsicleGroupIconShadowImageView)
        popsicleGroupContainerView.sendSubviewToBack(popsicleGroupIconShadowImageView)
        popsicleGroupIconShadowImageView.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupIconShadowImageView.centerYAnchor.constraint(equalTo: popsicleGroupIconImageView.bottomAnchor, constant: -1.5).isActive = true
        popsicleGroupIconShadowImageView.centerXAnchor.constraint(equalTo: popsicleGroupIconImageView.centerXAnchor).isActive = true
        popsicleGroupIconShadowImageView.widthAnchor.constraint(equalTo: popsicleGroupIconImageView.widthAnchor, multiplier: 0.87).isActive = true
        popsicleGroupIconShadowImageView.heightAnchor.constraint(equalTo: popsicleGroupIconImageView.heightAnchor, multiplier: 0.27).isActive = true
        
        return popsicleGroupContainerView
        
    }()
    
    lazy private var popsicleGroupIconImageView: UIImageView = {
        
        var popsicleGroupIconImageView = UIImageView()
        popsicleGroupIconImageView.image = .popsicleGroupIcon256
        popsicleGroupIconImageView.contentMode = .scaleAspectFit
        return popsicleGroupIconImageView
        
    }()
    
    lazy private var popsicleGroupCountBubbleView: BubbleView = {
        
        var popsicleGroupCountBubbleView = BubbleView()
        popsicleGroupCountBubbleView.backgroundColor = .mainDARKPURPLE
        popsicleGroupCountBubbleView.clipsToBounds = true
        
        popsicleGroupCountBubbleView.addSubview(popsicleGroupCountLabel)
        popsicleGroupCountLabel.translatesAutoresizingMaskIntoConstraints = false
        popsicleGroupCountLabel.centerYAnchor.constraint(equalTo: popsicleGroupCountBubbleView.centerYAnchor).isActive = true
        popsicleGroupCountLabel.centerXAnchor.constraint(equalTo: popsicleGroupCountBubbleView.centerXAnchor).isActive = true
        
        return popsicleGroupCountBubbleView
        
    }()
    
    lazy private var popsicleGroupCountLabel: UILabel = {
        
        var popsicleGroupCountLabel = UILabel()
        popsicleGroupCountLabel.textAlignment = .center
        popsicleGroupCountLabel.text = "0"
        popsicleGroupCountLabel.numberOfLines = 1
        popsicleGroupCountLabel.textColor = .white
        popsicleGroupCountLabel.backgroundColor = .mainDARKPURPLE
        popsicleGroupCountLabel.font = .dynamicFont(with: "Octarine-Bold", style: .caption2)
        return popsicleGroupCountLabel
        
    }()
    
    lazy private var popsicleGroupIconShadowImageView: UIImageView = {
        
        var popsicleGroupIconShadowImageView = UIImageView()
        popsicleGroupIconShadowImageView.image = .defaultPopsicleIconShadow256
        popsicleGroupIconShadowImageView.alpha = 0.6
        popsicleGroupIconShadowImageView.contentMode = .scaleToFill
        return popsicleGroupIconShadowImageView
        
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureView()
        
    }

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        configureView()
        
    }
    
    private func configureView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        frame = CGRect(x: 0.0, y: 0.0, width: popsicleWidth + ((popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)/2), height: popsicleHeight)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        addSubview(popsicleGroupContainerView)
        popsicleGroupContainerView.frame = bounds
        
    }
    
    func setGroupCount(count: Int) {
        
        canShowCallout = false
        displayPriority = .required
        collisionMode = .rectangle
        
        if count < 0 {
            
            popsicleGroupCount = 0
            popsicleGroupCountLabel.text = "0"
            
        } else if count > 99 {
            
            popsicleGroupCount = count
            popsicleGroupCountLabel.text = "99+"
            
        } else {
            
            popsicleGroupCount = count
            popsicleGroupCountLabel.text = String(count)
            
        }
        
        bubbleViewWidthConstraint.isActive = false
        bubbleViewWidthConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)
        bubbleViewWidthConstraint.isActive = true
        
        if popsicleGroupCount >= 0 && popsicleGroupCount < 10 {
            
            bubbleViewHeightConstraint.isActive = false
            bubbleViewHeightConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .height, relatedBy: .equal, toItem: popsicleGroupCountBubbleView, attribute: .width, multiplier: 1.0, constant: 0.0)
            bubbleViewHeightConstraint.isActive = true
            
        } else if popsicleGroupCount >= 10 {
            
            bubbleViewHeightConstraint.isActive = false
            bubbleViewHeightConstraint = NSLayoutConstraint(item: popsicleGroupCountBubbleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: popsicleGroupCountLabel.intrinsicContentSize.height + innerInsetY)
            bubbleViewHeightConstraint.isActive = true
            
        }
        
        frame = CGRect(x: 0.0, y: 0.0, width: popsicleWidth + ((popsicleGroupCountLabel.intrinsicContentSize.width + innerInsetX)/2), height: popsicleHeight)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
        popsicleGroupContainerView.frame = bounds
        
    }
    
}

final class BubbleView: UIView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerCurve = .continuous
        layer.cornerRadius = min(frame.width, frame.height)/2
        
    }
    
}

