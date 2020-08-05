//
//  DetailsInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct PreviewDetailsInputViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(details: nil, category: nil)
        
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = DetailsInputViewController
    
}

struct TestPreviewDetailsInputViewController: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewDetailsInputViewController
    
}

final class DetailsInputViewController: UIViewController {
    
    private var details: String?
    private var category: EventCategory?
    
    weak var delegate: DetailsInputDelegate?
    
    init(details: String?, category: EventCategory?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
        self.details = details
        self.category = category
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    override func loadView() {
        
        self.view = DetailsInputView(details: details, category: category)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? DetailsInputView else { return }
        
        view.detailsTextView.delegate = self
        view.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        view.detailsTextView.becomeFirstResponder()
        
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
        guard let view = view as? DetailsInputView else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            
            var contentInset = view.cardScrollView.contentInset
            contentInset.bottom = view.yInset
            view.cardScrollView.contentInset = contentInset
            
        } else {
            
            var contentInset = view.cardScrollView.contentInset
            contentInset.bottom = keyboardViewEndFrame.height + view.characterCountLabel.intrinsicContentSize.height + view.yInset
            view.cardScrollView.contentInset = contentInset
            
        }
        
        view.cardScrollView.scrollIndicatorInsets = view.cardScrollView.contentInset

    }
    
    @objc private func cancel() {
        
        guard let view = view as? DetailsInputView else { return }
        
        if let details = details, details == view.detailsTextView.text {
            
            dismiss(animated: true, completion: nil)
            
        } else if view.detailsTextView.isEmpty() {
            
            dismiss(animated: true, completion: nil)
            
        } else if let font = view.detailsTextView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
            
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
    
        guard let view = view as? DetailsInputView else { return }
        
        if view.detailsTextView.isEmpty() {
            
            delegate?.setDetails(details: nil)
            dismiss(animated: true, completion: nil)
            
        } else if let font = view.detailsTextView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
            
            delegate?.setDetails(details: nil)
            dismiss(animated: true, completion: nil)
            
        } else if view.detailsTextView.text.count > 500 {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Details are too long", alertMessage: "Please shorten the details.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if let details = details, details == view.detailsTextView.text {
            
            delegate?.setDetails(details: nil)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            delegate?.setDetails(details: view.detailsTextView.text)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

extension DetailsInputViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard let view = view as? DetailsInputView else { return }
        
        if textView == view.detailsTextView {
            
            if let font = textView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
                
                textView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
                textView.text = ""
                view.characterCountLabel.text = "0 / 500"
                
            } else {
                
                view.characterCountLabel.text = String(textView.text.count) + " / 500"
                
            }
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let view = view as? DetailsInputView else { return }
        
        if textView == view.detailsTextView, (textView.text == "" || textView.isEmpty()) {
            
            textView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
            textView.text = "Details"
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let view = view as? DetailsInputView else { return false }
        
        if textView == view.detailsTextView {
            
            let newText = NSString(string: textView.text).replacingCharacters(in: range, with: text)
            
            if newText.count <= 500 {
                
                view.characterCountLabel.text = String(newText.count) + " / 500"
                
            }
            
            return newText.count <= 500
            
        } else {
            
            return false
            
        }
        
    }
    
}


