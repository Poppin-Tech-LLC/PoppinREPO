//
//  TitleInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/3/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI

struct PreviewTitleInputViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(title: nil, category: nil)
        
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = TitleInputViewController
    
}

struct TestPreviewTitleInputViewController: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewTitleInputViewController
    
}

final class TitleInputViewController: UIViewController {
    
    private var eventTitle: String?
    private var category: EventCategory?
    
    weak var delegate: TitleInputDelegate?
    
    init(title: String?, category: EventCategory?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
        self.eventTitle = title
        self.category = category
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    override func loadView() {
        
        self.view = TitleInputView(title: eventTitle, category: category)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? TitleInputView else { return }
        
        view.titleTextView.delegate = self
        view.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        view.titleTextView.becomeFirstResponder()
        
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
        guard let view = view as? TitleInputView else { return }

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
        
        guard let view = view as? TitleInputView else { return }
        
        if let eventTitle = eventTitle, eventTitle == view.titleTextView.text {
            
            dismiss(animated: true, completion: nil)
            
        } else if view.titleTextView.isEmpty() {
            
            dismiss(animated: true, completion: nil)
            
        } else if let font = view.titleTextView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
            
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
    
        guard let view = view as? TitleInputView else { return }
        
        if view.titleTextView.isEmpty() {
            
            delegate?.setTitle(title: nil)
            dismiss(animated: true, completion: nil)
            
        } else if let font = view.titleTextView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
            
            delegate?.setTitle(title: nil)
            dismiss(animated: true, completion: nil)
            
        } else if view.titleTextView.text.count > 50 {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Title is too long", alertMessage: "Please shorten the title.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if let eventTitle = eventTitle, eventTitle == view.titleTextView.text {
            
            delegate?.setTitle(title: nil)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            delegate?.setTitle(title: view.titleTextView.text)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

extension TitleInputViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard let view = view as? TitleInputView else { return }
        
        if textView == view.titleTextView {
            
            if let font = textView.font, font.isEqual(UIFont.dynamicFont(with: "Octarine-Light", style: .subheadline)) {
                
                textView.font = .dynamicFont(with: "Octarine-Bold", style: .subheadline)
                textView.text = ""
                view.characterCountLabel.text = "0 / 50"
                
            } else {
                
                view.characterCountLabel.text = String(textView.text.count) + " / 50"
                
            }
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let view = view as? TitleInputView else { return }
        
        if textView == view.titleTextView, (textView.text == "" || textView.isEmpty()) {
            
            textView.font = .dynamicFont(with: "Octarine-Light", style: .subheadline)
            textView.text = "Title"
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let view = view as? TitleInputView else { return false }
        
        if textView == view.titleTextView {
            
            if text == "\n" {
                
                textView.resignFirstResponder()
                save()
                
                return false
                
            }
            
            let newText = NSString(string: textView.text).replacingCharacters(in: range, with: text)
            
            if newText.count <= 50 {
                
                view.characterCountLabel.text = String(newText.count) + " / 50"
                
            }
            
            return newText.count <= 50
            
        } else {
            
            return false
            
        }
        
    }
    
}

