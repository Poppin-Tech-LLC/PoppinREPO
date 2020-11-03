//
//  CreateEventFirstSectionViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/27/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit

/// First Section of the Create Event Page (Category and Visibility) UI Controller.
final class CreateEventFirstSectionViewController: UIViewController {
    
    // Holds the event input.
    lazy private var eventInput: EventModel = EventModel()
    
    /// Overrides superclass method to initialize the root view with a custom UI.
    override func loadView() {
        
        self.view = CreateEventFirstSectionView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? CreateEventFirstSectionView else { return }
        
        // 2. Setting targets.
        view.closeButton.addTarget(self, action: #selector(dismissCreateEventPage), for: .touchUpInside)
        view.nextButton.addTarget(self, action: #selector(segueToNextPage), for: .touchUpInside)
        
    }
    
    // Closes the create event page. If input has already been entered and could be lost, an alert is shown.
    @objc private func dismissCreateEventPage() {
        
        // 1. Check if any input has already been entered to show an alert. If not, dismiss right away.
        if eventInput.title != nil || eventInput.startDate != nil || eventInput.endDate != nil || eventInput.location != nil || eventInput.details != nil || eventInput.onlineURL != nil {
            
            let alertVC = AlertViewController(alertTitle: "Are you sure you wisth to exit?", alertMessage: "Any progress will be lost.", leftActionTitle: "Exit", leftAction: { [weak self] in
                
                guard let self = self else { return }
                
                self.navigationController?.dismiss(animated: true, completion: nil)
            
            }, rightActionTitle: "Stay", rightAction: nil)
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    // Once a category and visibility has been picked, transition to the next section of the create event page.
    @objc private func segueToNextPage() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? CreateEventFirstSectionView else { return }
        
        // 2. Safe check the category picked. If fails, show an error.
        if view.currentPage >= 0, view.currentPage < EventCategory.allCases.count {
            
            eventInput.category = EventCategory.allCases[view.currentPage]
            
        } else {
            
            let alertVC = AlertViewController(alertTitle: "Unknown Category", alertMessage: "The category picked is unknown. Please try again", leftActionTitle: "Ok")
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
        // 3. Saving the visibility of the event.
        eventInput.isPublic = view.visibilitySwitch.isOn
        
        // 4. Transition to the next section of the create event page. A closure is passed, to update input fields if the user transitions back to this section.
        navigationController?.pushViewController(CreateEventSecondSectionViewController(eventInput: eventInput, completionHandler: { [weak self] (eventInput) in
            
            guard let self = self else { return }
            
            self.eventInput.title = eventInput?.title
            self.eventInput.startDate = eventInput?.startDate
            self.eventInput.endDate = eventInput?.endDate
            self.eventInput.location = eventInput?.location
            self.eventInput.onlineURL = eventInput?.onlineURL
            self.eventInput.details = eventInput?.details
            
        }), animated: true)
        
    }
    
}
