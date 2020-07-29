//
//  writeDetailsViewController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 6/25/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit

final class EventDetailsInputViewController: UIViewController, UITextViewDelegate {
    
    private let createEventVerticalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let createEventHorizontalEdgeInset: CGFloat = .getPercentageWidth(percentage: 5)
    private let createEventInnerInset: CGFloat = .getPercentageWidth(percentage: 7)
    
    private var color: UIColor = .defaultGRAY
    
    lazy private var cardContainerView: UIView = {
        
        var cardContainerView = UIView()
        cardContainerView.backgroundColor = color
        cardContainerView.clipsToBounds = true
        cardContainerView.layer.cornerRadius = .getWidthFitSize(minSize: 14.0, maxSize: 16.0)
        
        cardContainerView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: createEventVerticalEdgeInset).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: createEventHorizontalEdgeInset).isActive = true
        
        cardContainerView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: createEventVerticalEdgeInset).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -createEventHorizontalEdgeInset).isActive = true
        
        cardContainerView.addSubview(eventDetailsTextView)
        eventDetailsTextView.translatesAutoresizingMaskIntoConstraints = false
        eventDetailsTextView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: createEventVerticalEdgeInset*0.5).isActive = true
        eventDetailsTextView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: createEventHorizontalEdgeInset).isActive = true
        eventDetailsTextView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -createEventHorizontalEdgeInset).isActive = true
        
        cardContainerView.addSubview(characterCountLabel)
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.topAnchor.constraint(equalTo: eventDetailsTextView.bottomAnchor, constant: createEventVerticalEdgeInset*0.3).isActive = true
        characterCountLabel.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -createEventHorizontalEdgeInset).isActive = true
        
        cardContainerView.addSubview(detailsLabel)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.topAnchor.constraint(equalTo: eventDetailsTextView.bottomAnchor, constant: createEventVerticalEdgeInset*0.3).isActive = true
        detailsLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: createEventHorizontalEdgeInset).isActive = true
        
        return cardContainerView
        
    }()
    
    lazy private var cancelButton: BouncyButton = {
        
        var cancelButton = BouncyButton(bouncyButtonImage: nil)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        cancelButton.addTarget(self, action: #selector(cancelInput), for: .touchUpInside)
        return cancelButton
        
    }()
    
    lazy private var doneButton: BouncyButton = {
        
        var doneButton = BouncyButton(bouncyButtonImage: nil)
        doneButton.setTitle("Save", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
        doneButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return doneButton
        
    }()
    
    lazy private var detailsLabel: UILabel = {
        
        var detailsLabel = UILabel()
        detailsLabel.text = "Event Details"
        detailsLabel.textColor = .white
        detailsLabel.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        detailsLabel.numberOfLines = 1
        detailsLabel.textAlignment = .center
        return detailsLabel
        
    }()
    
    lazy private(set) var eventDetailsTextView: UITextView = {
        
        var eventDetailsTextView = UITextView()
        eventDetailsTextView.backgroundColor = color
        eventDetailsTextView.textColor = .white
        eventDetailsTextView.textContainerInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: createEventVerticalEdgeInset*0.3, right: 0.0)
        eventDetailsTextView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
        eventDetailsTextView.delegate = self
        eventDetailsTextView.textAlignment = .left
        eventDetailsTextView.sizeToFit()
        eventDetailsTextView.isScrollEnabled = false
        //eventNameTextField.clearButtonMode = .whileEditing
        //eventNameTextField.returnKeyType = .next
        //eventNameTextField.autocapitalizationType = .none
        //eventNameTextField.autocorrectionType = .no
        eventDetailsTextView.setBottomBorder(color: UIColor.white, height: 1.0)
        return eventDetailsTextView
    }()
    
    lazy private var characterCountLabel: UILabel = {
        
        var characterCountLabel = UILabel()
        characterCountLabel.font = .dynamicFont(with: "Octarine-Bold", style: .footnote)
        characterCountLabel.textColor = .white
        characterCountLabel.backgroundColor = .clear
        characterCountLabel.text = "0/250"
        return characterCountLabel
        
    }()
    
    init(with color: UIColor?, text: String?) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let color = color { self.color = color }
        
        eventDetailsTextView.text = text
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.addSubview(cardContainerView)
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: createEventVerticalEdgeInset).isActive = true
        cardContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -createEventVerticalEdgeInset).isActive = true
        cardContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: createEventHorizontalEdgeInset).isActive = true
        cardContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -createEventHorizontalEdgeInset).isActive = true
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        eventDetailsTextView.becomeFirstResponder()
        
    }
    
    @objc private func cancelInput() {
        
        if !eventDetailsTextView.isEmpty() {
            
            let button1 = AlertButton(alertTitle: "Yes", alertButtonAction: { [weak self] in
                
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
                
            })
            
            let button2 = AlertButton(alertTitle: "No", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Discard changes", alertMessage: "Are you sure you want to discard any changes?", alertButtons: [button1, button2])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc func saveChanges() {
        self.dismiss(animated: true, completion: nil)
        if(eventDetailsTextView.text.trimmingCharacters(in: .whitespaces).isEmpty){
            let textInfo = [ "text" : "Add details..." ]
            NotificationCenter.default.post(name: .detailsWritten, object: nil, userInfo: textInfo as [AnyHashable : Any])
        }else{
            let textInfo = [ "text" : eventDetailsTextView.text ]
            NotificationCenter.default.post(name: .detailsWritten, object: nil, userInfo: textInfo as [AnyHashable : Any])
        }
    }
    
    func textViewDidBeginEditing (_ textView: UITextView) {
        if  eventDetailsTextView.text == "Add details..." && eventDetailsTextView.isFirstResponder {
            eventDetailsTextView.text = nil
            //eventNameTextField.textColor = .white
        }
        let newPosition = eventDetailsTextView.endOfDocument
        eventDetailsTextView.selectedTextRange = eventDetailsTextView.textRange(from: newPosition, to: newPosition)
    }
    
    func textViewDidEndEditing (_ textView: UITextView) {
        if eventDetailsTextView.text.isEmpty || eventDetailsTextView.text == "" {
            eventDetailsTextView.textColor = .mainDARKPURPLE
            eventDetailsTextView.text = "Add details..."
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            return false
        }
        
        
        let newText = (eventDetailsTextView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        characterCountLabel.text = String(numberOfChars) + "/250"
        
        
        return numberOfChars < 250
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
