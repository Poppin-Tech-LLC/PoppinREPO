//
//  OnlineLinkInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/4/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct PreviewOnlineLinkInputViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(onlineLink: nil, category: nil)
        
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = OnlineLinkInputViewController
    
}

struct TestPreviewOnlineLinkInputViewController: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewOnlineLinkInputViewController
    
}

final class OnlineLinkInputViewController: UIViewController {
    
    private var onlineLink: URL?
    private var category: EventCategory?
    
    weak var delegate: OnlineLinkInputDelegate?
    
    init(onlineLink: URL?, category: EventCategory?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
        self.onlineLink = onlineLink
        self.category = category
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    override func loadView() {
        
        self.view = OnlineLinkInputView(onlineLink: onlineLink, category: category)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? OnlineLinkInputView else { return }
        
        view.onlineLinkTextView.delegate = self
        view.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        view.removeLinkButton.addTarget(self, action: #selector(remove), for: .touchUpInside)
        
        view.onlineLinkTextView.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let view = view as? OnlineLinkInputView else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            
            var contentInset = view.cardScrollView.contentInset
            contentInset.bottom = view.yInset
            view.cardScrollView.contentInset = contentInset
            
        } else {
            
            var contentInset = view.cardScrollView.contentInset
            contentInset.bottom = keyboardViewEndFrame.height + view.removeOnlineLinkView.intrinsicContentSize.height + view.yInset
            view.cardScrollView.contentInset = contentInset
            
        }
        
        view.cardScrollView.scrollIndicatorInsets = view.cardScrollView.contentInset

    }
    
    @objc private func cancel() {
        
        guard let view = view as? OnlineLinkInputView else { return }
        
        if let onlineLink = onlineLink, onlineLink.absoluteString == view.onlineLinkTextView.text {
            
            dismiss(animated: true, completion: nil)
            
        } else if view.onlineLinkTextView.isEmpty() {
            
            dismiss(animated: true, completion: nil)
            
        } else if let font = view.onlineLinkTextView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Exit", alertButtonAction: { [weak self] in
                
                guard let self = self else { return }
                
                self.dismiss(animated: true, completion: nil)
            
            })
            
            let button2 = AlertButton(alertTitle: "Stay", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Are you sure you wisth to exit?", alertMessage: "Any edits will be lost.", alertButtons: [button1, button2])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func save() {
    
        guard let view = view as? OnlineLinkInputView else { return }
        
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        if view.onlineLinkTextView.isEmpty() {
            
            delegate?.setOnlineLink(onlineLink: nil)
            dismiss(animated: true, completion: nil)
            
        } else if let font = view.onlineLinkTextView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
            
            delegate?.setOnlineLink(onlineLink: nil)
            dismiss(animated: true, completion: nil)
            
        } else if let match = detector.firstMatch(in: view.onlineLinkTextView.text, options: [], range: NSRange(location: 0, length: view.onlineLinkTextView.text.utf16.count)), match.range.length == view.onlineLinkTextView.text.utf16.count {
            
            delegate?.setOnlineLink(onlineLink: URL(string: view.onlineLinkTextView.text))
            dismiss(animated: true, completion: nil)
            
        } else if let onlineLink = onlineLink, onlineLink.absoluteString == view.onlineLinkTextView.text {
            
            delegate?.setOnlineLink(onlineLink: nil)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Link is invalid", alertMessage: "Please enter a valid link.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func remove() {
        
        delegate?.setOnlineLink(onlineLink: nil)
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension OnlineLinkInputViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard let view = view as? OnlineLinkInputView else { return }
        
        if textView == view.onlineLinkTextView {
            
            if let font = textView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
                
                textView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
                textView.text = ""
                
            }
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let view = view as? OnlineLinkInputView else { return }
        
        if textView == view.onlineLinkTextView, (textView.text == "" || textView.isEmpty()) {
            
            textView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
            textView.text = "Online Link"
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let view = view as? OnlineLinkInputView else { return false }
        
        if textView == view.onlineLinkTextView {
            
            if text == "\n" {
                
                textView.resignFirstResponder()
                save()
                
                return false
                
            } else {
                
                return true
                
            }
        
        } else {
            
            return false
            
        }
        
    }
    
}


