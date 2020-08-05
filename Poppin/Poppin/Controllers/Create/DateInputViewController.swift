//
//  DateInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/31/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import Kronos
import SwiftDate

struct PreviewDateInputViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(startDate: nil, endDate: nil, category: nil)
        
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = DateInputViewController
    
}

struct TestPreviewDateInputViewController: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewDateInputViewController
    
}

final class DateInputViewController: UIViewController {
    
    private var startDate: Date?
    private var endDate: Date?
    private var category: EventCategory?
    
    weak var delegate: DateInputDelegate?
    
    lazy private var minimumDate: Date = { return Date().dateRoundedAt(at: .toCeil5Mins) + 15.minutes }()
    lazy private var maximumDate: Date = { return minimumDate + 7.days }()
    
    lazy private var startDatePicker: UIDatePicker = {
        
        var startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .dateAndTime
        startDatePicker.minuteInterval = 5
        startDatePicker.minimumDate = minimumDate
        startDatePicker.maximumDate = maximumDate
        startDatePicker.addTarget(self, action: #selector(setDate(from:)), for: .valueChanged)
        return startDatePicker
        
    }()
    
    lazy private var endDatePicker: UIDatePicker = {
        
        var endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.minuteInterval = 5
        endDatePicker.minimumDate = minimumDate
        endDatePicker.maximumDate = maximumDate
        endDatePicker.addTarget(self, action: #selector(setDate(from:)), for: .valueChanged)
        return endDatePicker
        
    }()
    
    init(startDate: Date?, endDate: Date?, category: EventCategory?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
        self.startDate = startDate
        self.endDate = endDate
        self.category = category
        
        if let startDate = startDate {
            
            startDatePicker.setDate(startDate, animated: false)
            
        } else {
            
            startDatePicker.setDate(minimumDate, animated: false)
            
        }
        
        if let endDate = endDate {
            
            endDatePicker.setDate(endDate, animated: false)
            
        } else {
            
            endDatePicker.setDate(startDatePicker.date + 30.minutes, animated: false)
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        
    }
    
    override func loadView() {
        
        var duration: String?
        
        if let endDate = endDate {
            
            duration = "Duration: "
            
            if let hours = (endDate - startDatePicker.date).hour {
                
                duration = duration! + String(hours) + "h "
                
            }
            
            if let minutes = (endDate - startDatePicker.date).minute {
                
                duration = duration! + String(minutes) + "m "
                
            }
            
        }
        
        self.view = DateInputView(formattedStartDate: startDatePicker.date.getFormattedDate(), formattedEndDate: endDate?.getFormattedDate(), formattedDuration: duration, category: category)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? DateInputView else { return }
        
        view.delegate = self
        view.startDateTextField.inputView = startDatePicker
        view.endDateTextField.inputView = endDatePicker
        view.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        view.startDateTextField.becomeFirstResponder()
        
    }
    
    @objc private func setDate(from picker: UIDatePicker) {
        
        guard let view = view as? DateInputView else { return }
        
        if picker == startDatePicker {
            
            if view.endDateTextField.isEmpty() {
                
                view.startDateTextField.text = picker.date.getFormattedDate()
                endDatePicker.date = picker.date + 30.minutes
                
            } else {
                
                if (picker.date + 30.minutes) > endDatePicker.date {
                
                    picker.date = endDatePicker.date - 30.minutes
                    
                    return
                
                }
                
                if (picker.date + 8.hours) < endDatePicker.date {
                
                    picker.date = endDatePicker.date - 8.hours
                    
                    return
                
                }
                
                var duration: String = "Duration: "
                
                if let hours = (endDatePicker.date - picker.date).hour {
                    
                    duration = duration + String(hours) + "h "
                    
                }
                
                if let minutes = (endDatePicker.date - picker.date).minute {
                    
                    duration = duration + String(minutes) + "m "
                    
                }
                
                view.durantionTitleLabel.text = duration
                view.startDateTextField.text = picker.date.getFormattedDate()
                
            }
            
        } else if picker == endDatePicker {
            
            if (startDatePicker.date + 30.minutes) > picker.date {
            
                picker.date = startDatePicker.date + 30.minutes
                
                return
            
            }
            
            if (startDatePicker.date + 8.hours) < picker.date {
            
                picker.date = startDatePicker.date + 8.hours
                
                return
            
            }
            
            var duration: String = "Duration: "
            
            if let hours = (picker.date - startDatePicker.date).hour {
                
                duration = duration + String(hours) + "h "
                
            }
            
            if let minutes = (picker.date - startDatePicker.date).minute {
                
                duration = duration + String(minutes) + "m "
                
            }
            
            view.durantionTitleLabel.text = duration
            view.endDateTextField.text = picker.date.getFormattedDate()
            
        }
        
    }
    
    @objc private func cancel() {
        
        guard let view = view as? DateInputView else { return }
        
        if view.startDateTextField.isEmpty() || view.endDateTextField.isEmpty() {
            
            dismiss(animated: true, completion: nil)
            
        } else if let startDate = startDate, let endDate = endDate, startDate == startDatePicker.date, endDate == endDatePicker.date {
            
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
    
        guard let view = view as? DateInputView else { return }
        
        if view.startDateTextField.isEmpty() && view.endDateTextField.isEmpty() {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Dates missing", alertMessage: "Please select a start and end date.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if view.startDateTextField.isEmpty() {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Start date missing", alertMessage: "Please select a start date.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if view.endDateTextField.isEmpty() {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "End date missing", alertMessage: "Please enter an end date.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if startDatePicker.date.isAfterDate(endDatePicker.date, granularity: .minute) {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Invalid date", alertMessage: "Start date should be prior to end date.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
        
        } else if (startDatePicker.date + 30.minutes) > endDatePicker.date {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Ivalid duration", alertMessage: "The event has to be at least 30 minutes long.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if (startDatePicker.date + 8.hours) < endDatePicker.date {
            
            let button1 = AlertButton(alertTitle: "Ok", alertButtonAction: nil)
            
            let alertVC = AlertViewController(alertTitle: "Ivalid duration", alertMessage: "The event has to be at most 8 hours long.", alertButtons: [button1])
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if let startDate = startDate, let endDate = endDate, startDate == startDatePicker.date, endDate == endDatePicker.date {
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            delegate?.setDate(startDate: startDatePicker.date, endDate: endDatePicker.date)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

extension DateInputViewController: DateInputDelegate {
    
    func closeDatePicker() {
        
        guard let view = view as? DateInputView else { return }
        
        if view.startDateTextField.isFirstResponder {
            
            setDate(from: startDatePicker)
            view.endDateTextField.becomeFirstResponder()
            
        } else if view.endDateTextField.isFirstResponder {
            
            setDate(from: endDatePicker)
            view.startDateTextField.becomeFirstResponder()
            
        }
        
    }
    
}
