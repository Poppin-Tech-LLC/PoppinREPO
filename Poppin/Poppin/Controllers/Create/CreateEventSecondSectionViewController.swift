//
//  CreateEventSecondSectionViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/30/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation
import Firebase
import GeoFire
import Geofirestore
import SafariServices

/// Second Section of the Create Event Page (Title, Date, Location, Online Link, and Details) UI Controller.
final class CreateEventSecondSectionViewController: UIViewController {
    
    // Holds the event input.
    private var eventInput: EventModel?
    
    // Closure called when transitioning to the previous page.
    private var completionHandler: ((EventModel?) -> Void)?
    
    /**
    Custom class init that initializes or updates the input for the current event, and assigns a completion handler.

    - Parameters:
        - eventInput: Input entered so far for the current event being created.
        - completionHandler: Closure called when transitioning to the previous section.
    */
    init(eventInput: EventModel?, completionHandler: ((EventModel?) -> Void)?) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.eventInput = eventInput
        self.completionHandler = completionHandler
        
    }
    
    /**
    Required init?(coder:) not implemented (storyboard not available). WIll throw a fatal error.

    - Parameter coder: NSCoder from storyboard.
    */
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Overrides superclass method to initialize the root view with a custom UI.
    override func loadView() {
        
        self.view = CreateEventSecondSectionView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? CreateEventSecondSectionView else { return }
        
        // 2. Setting targets and delegation.
        view.onlineURLTextView.delegate = self
        view.locationMapView.delegate = self
        
        view.backButton.addTarget(self, action: #selector(transitionToPreviousPage), for: .touchUpInside)
        view.titleButton.addTarget(self, action: #selector(transitionToTitleInputPage(sender:)), for: .touchUpInside)
        view.dateButton.addTarget(self, action: #selector(transitionToDateInputPage(sender:)), for: .touchUpInside)
        view.locationButton.addTarget(self, action: #selector(transitionToLocationInputPage(sender:)), for: .touchUpInside)
        view.onlineURLButton.addTarget(self, action: #selector(transitionToOnlineURLInputPage(sender:)), for: .touchUpInside)
        view.detailsButton.addTarget(self, action: #selector(transitionToDetailsInputPage(sender:)), for: .touchUpInside)
        view.createButton.addTarget(self, action: #selector(create(sender:)), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to update UI.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? CreateEventSecondSectionView else { return }
        
        // 2. Update UI with event input.
        view.updateUI(eventInput: eventInput)
        
        // 3. Enables swipe to transition back.
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // 4. Notify of input changes.
        self.inputDidChange()
        
    }
    
    /// Overrides superclass method to disable swipe back.
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        // 1. Disables swipe to transition back.
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    // Transition to the previous section of the create event page.
    @objc private func transitionToPreviousPage() {
        
        // 1. Calls the return closure and updates the event input.
        completionHandler?(eventInput)
        
        // 2. Transition to the previous section.
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func transitionToTitleInputPage(sender: OctarineButton) {
        
        present(TitleInputViewController(eventInput: eventInput, completionHandler: { [weak self] (title) in
            
            guard let self = self else { return }
            
            self.eventInput?.title = title
            
            // 1. Safe casting root view to custom view.
            guard let view = self.view as? CreateEventSecondSectionView else { return }
            
            view.update(title: self.eventInput?.title)
            
            self.inputDidChange()
            
        }), animated: true, completion: nil)
        
    }
    
    @objc private func transitionToDateInputPage(sender: OctarineButton) {
     
        present(DateInputViewController(eventInput: eventInput, completionHandler: { [weak self] (startDate, endDate) in
            
            guard let self = self else { return }
            
            self.eventInput?.startDate = startDate
            self.eventInput?.endDate = endDate
            
            // 1. Safe casting root view to custom view.
            guard let view = self.view as? CreateEventSecondSectionView else { return }
            
            view.update(startDate: self.eventInput?.startDate, endDate: self.eventInput?.endDate)
            
            self.inputDidChange()
            
        }), animated: true, completion: nil)
        
    }
    
    @objc private func transitionToLocationInputPage(sender: OctarineButton) {
     
        present(LocationInputViewController(eventInput: eventInput, completionHandler: { [weak self] (location, address) in
            
            guard let self = self else { return }
            
            self.eventInput?.location = location
            
            // 1. Safe casting root view to custom view.
            guard let view = self.view as? CreateEventSecondSectionView else { return }
            
            view.update(location: location, address: address)
            
            self.inputDidChange()
            
        }), animated: true, completion: nil)
        
    }
    
    @objc private func transitionToOnlineURLInputPage(sender: OctarineButton) {
        
        present(OnlineLinkInputViewController(eventInput: eventInput, completionHandler: { [weak self] (onlineURL) in
            
            guard let self = self else { return }
            
            self.eventInput?.onlineURL = onlineURL
            
            // 1. Safe casting root view to custom view.
            guard let view = self.view as? CreateEventSecondSectionView else { return }
            
            view.update(onlineURL: self.eventInput?.onlineURL)
            
        }), animated: true, completion: nil)
        
    }
    
    @objc private func transitionToDetailsInputPage(sender: OctarineButton) {
        
        present(DetailsInputViewController(eventInput: eventInput, completionHandler: { [weak self] (details) in
            
            guard let self = self else { return }
            
            self.eventInput?.details = details
            
            // 1. Safe casting root view to custom view.
            guard let view = self.view as? CreateEventSecondSectionView else { return }
            
            view.update(details: self.eventInput?.details)
            
        }), animated: true, completion: nil)
        
    }
    
    /// Called when changes occur to the current event input. Enables or disables the create button according to the input content.
    private func inputDidChange() {
        
        // 1. Safe casting root view to custom view.
        guard let view = self.view as? CreateEventSecondSectionView else { return }
        
        // 2. Once all event input has been entered, enable the create button.
        if eventInput != nil && eventInput?.category != nil && eventInput?.title != nil && eventInput?.startDate != nil && eventInput?.endDate != nil && eventInput?.location != nil && view.createButton.isDisabled {
            
            view.createButton.isDisabled = false
            
        } else if eventInput == nil || eventInput?.category == nil || eventInput?.title == nil || eventInput?.startDate == nil || eventInput?.endDate == nil || eventInput?.location == nil && !view.createButton.isDisabled {
            
            view.createButton.isDisabled = true
            
        }
        
    }
    
    // Once all required input has been entered, it creates a new event on the database and stores the information entered.
    @objc private func create(sender: LoadingButton) {
        
        // 1. Safe casting root view to custom view.
        guard let _ = self.view as? CreateEventSecondSectionView else { return }
        
        // 2. Empty input safe check. If fails, show error.
        if let eventInput = eventInput, let category = eventInput.category, let title = eventInput.title, let startDate = eventInput.startDate, let endDate = eventInput.endDate, let location = eventInput.location {
            
            // 3. Create button shows loading indicator.
            sender.startLoading()
            
            // 4. Creates a date formatter readable for the database.
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            // 5. Adds newly created event to the database (Firebase).
            var newEventRef: DocumentReference? = nil
            
            newEventRef = Firestore.firestore().collection(eventInput.isPublic ? "publicPopsicles" : "privatePopsicles").addDocument(data: ["longitude": location.longitude,
                "latitude": location.latitude,
                "eventName": title,
                "eventDetails": eventInput.details != nil ? eventInput.details! : "",
                "startDate": dateFormatter.string(from: startDate),
                "endDate": dateFormatter.string(from: endDate),
                "createdBy": MapViewController.uid,
                "category": category.rawValue]) { [weak self] error in
                    
                    guard let self = self else { return }
                    
                    // 6. If an error is found, stop loading and show it.
                    if error != nil {
                        
                        sender.stopLoading()
                        
                        let alertVC = AlertViewController()
                        
                        self.present(alertVC, animated: true, completion: nil)
                        
                    } else if let newEventRef = newEventRef {
                        
                        print("First Step Success!")
                        
                        // 7. Adds newly created event to the user's event list.
                        Firestore.firestore().collection("users").document(MapViewController.uid).collection("userPopsicles").document(newEventRef.documentID).setData(["longitude": location.longitude,
                        "latitude": location.latitude,
                        "eventName": title,
                        "eventDetails": eventInput.details != nil ? eventInput.details! : "",
                        "startDate": dateFormatter.string(from: startDate),
                        "endDate": dateFormatter.string(from: endDate),
                        "createdBy": MapViewController.uid,
                        "category": category.rawValue]) { [weak self] error in
                            
                            guard let self = self else { return }
                            
                            // 8. If an error is found, remove newly created event from the database, stop loading and show error message.
                            if error != nil {
                                
                                newEventRef.delete()
                                
                                sender.stopLoading()
                                
                                print("HEREEE")
                                print(MapViewController.uid)
                                
                                let alertVC = AlertViewController()
                                
                                self.present(alertVC, animated: true, completion: nil)
                                
                            } else {
                                
                                print("Second Step Success!")
                                
                                // 9. Add newly created event to the geo location list for location querying.
                                GeoFirestore(collectionRef: Firestore.firestore().collection(eventInput.isPublic ? "publicPopsicleLocs" : "privatePopsicleLocs")).setLocation(location: CLLocation(latitude: location.latitude, longitude: location.longitude), forDocumentWithID: newEventRef.documentID) { [weak self] (error) in
                                    
                                    guard let self = self else { return }
                                    
                                    // 10. If an error is found, remove newly created event, stop loading and show error message.
                                    if error != nil {
                                        
                                        newEventRef.delete()
                                        
                                        Firestore.firestore().collection("users").document(MapViewController.uid).collection("userPopsicles").document(newEventRef.documentID).delete()
                                        
                                        sender.stopLoading()
                                        
                                        let alertVC = AlertViewController()
                                        
                                        self.present(alertVC, animated: true, completion: nil)
                                        
                                    }
                                    
                                    // 11. Stop loading and show a success message. Transition back to the map.
                                    else {
                                        
                                        sender.stopLoading()
                                        
                                        let alertVC = AlertViewController(alertTitle: "All Done!", alertMessage: "Your new event was created successfully.", leftActionTitle: "Back to the map", leftAction: { [weak self] in
                                            
                                            guard let self = self else { return }
                                            
                                            NotificationCenter.default.post(name: .eventCreated, object: nil)
                                            self.navigationController?.dismiss(animated: true, completion: nil)
                                            
                                        })
                                        
                                        self.present(alertVC, animated: true, completion: nil)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                    } else {
                        
                        sender.stopLoading()
                        
                        let alertVC = AlertViewController()
                        
                        self.present(alertVC, animated: true, completion: nil)
                        
                    }
                    
                    
            }
            
        } else {
            
            let alertVC = AlertViewController()
            
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }

}

extension CreateEventSecondSectionViewController: UIGestureRecognizerDelegate {
    
    /// REQUIRED: Fails other gesture recognizers when swiping to transition back.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}

extension CreateEventSecondSectionViewController: UITextViewDelegate, SFSafariViewControllerDelegate {
 
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let vc = SFSafariViewController(url: URL)
        vc.modalPresentationStyle = .pageSheet
        vc.modalTransitionStyle = .coverVertical
        vc.delegate = self
        present(vc, animated: true)
        return false
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        controller.dismiss(animated: true)
        
    }
    
}

extension CreateEventSecondSectionViewController: MKMapViewDelegate {
    
    /// Delegate function called when the map needs to update its annotations. It returns a view for each annotation on the map.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let userAnnotation = annotation as? MKUserLocation {
            
            if let userAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: UserAnnotationView.defaultReuseIdentifier) as? UserAnnotationView {

                userAnnotationView.setUserIcon(icon: nil)
                return userAnnotationView

            } else {

                let userAnnotationView = UserAnnotationView(annotation: userAnnotation, reuseIdentifier: UserAnnotationView.defaultReuseIdentifier)
                userAnnotationView.setUserIcon(icon: nil)
                return userAnnotationView

            }

        } else if let eventAnnotation = annotation as? EventAnnotation {

            if let eventAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: EventAnnotationView.defaultReuseIdentifier) as? EventAnnotationView {

                eventAnnotationView.setEventAnnotation(eventAnnotation: eventAnnotation)
                return eventAnnotationView

            } else {

                let eventAnnotationView = EventAnnotationView(annotation: annotation, reuseIdentifier: EventAnnotationView.defaultReuseIdentifier)
                eventAnnotationView.setEventAnnotation(eventAnnotation: eventAnnotation)
                return eventAnnotationView

            }

        } else if let eventGroupAnnotation = annotation as? MKClusterAnnotation {

            if let eventGroupAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: EventGroupAnnotationView.defaultReuseIdentifier) as? EventGroupAnnotationView {

                eventGroupAnnotationView.setGroupCount(count: eventGroupAnnotation.memberAnnotations.count)
                return eventGroupAnnotationView

            } else {

                let eventGroupAnnotationView = EventGroupAnnotationView(annotation: annotation, reuseIdentifier: EventGroupAnnotationView.defaultReuseIdentifier)
                eventGroupAnnotationView.setGroupCount(count: eventGroupAnnotation.memberAnnotations.count)
                return eventGroupAnnotationView

            }

        } else {
            
            return nil
            
        }
        
    }
    
}
    
//    private func setVisibility(isPublic: Bool) {
//
////        guard let view = view as? CreateEventSecondSectionView else { return }
////
////        if isPublic {
////
////            UIView.transition(with: view.visibilityLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
////
////                view.visibilityLabel.text = "Public"
////
////            }, completion: nil)
////
////            UIView.transition(with: view.visibilityIconImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
////
////                view.visibilityIconImageView.image = UIImage(systemSymbol: .globe).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
////
////            }, completion: nil)
////
////        } else {
////
////            UIView.transition(with: view.visibilityLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
////
////                view.visibilityLabel.text = "Private"
////
////            }, completion: nil)
////
////            UIView.transition(with: view.visibilityIconImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
////
////                view.visibilityIconImageView.image = UIImage(systemSymbol: .lockFill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
////
////            }, completion: nil)
////
////        }
//
//    }
//
//    @objc private func segueBack() {
//
//        navigationController?.popViewController(animated: true)
//
//    }
//
//    @objc private func segueToLocationInput() {
//
////        var location = eventPlaceholder.location
////
////        do { location = try eventController.getLocation() } catch let error as EventError { print("location: " + error.rawValue + "\n") } catch { print("location: " + error.localizedDescription + "\n") }
////
////        let locationVC = LocationInputViewController(location: location, mapBoundry: nil, category: eventPlaceholder.category)
////        locationVC.delegate = self
////
////        present(locationVC, animated: true, completion: nil)
//
//    }
//
//    @objc private func segueToOnlineURLInput() {
//
////        var onlineURL = eventPlaceholder.onlineURL
////
////        do { onlineURL = try eventController.getOnlineURL() } catch let error as EventError { print("onlineURL: " + error.rawValue + "\n") } catch { print("onlineURL: " + error.localizedDescription + "\n") }
////
////        let onlineURLVC = OnlineLinkInputViewController(onlineLink: onlineURL, category: eventPlaceholder.category)
////        onlineURLVC.delegate = self
////
////        present(onlineURLVC, animated: true, completion: nil)
//
//    }
//

//extension CreateEventSecondSectionViewController: UITextViewDelegate {
//
//    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//
////        guard let view = view as? CreateEventSecondSectionView else { return false }
////
////        if textView == view.detailsTextView {
////
////            textView.alpha = 0.7
////
////            let detailsVC = DetailsInputViewController(details: eventPlaceholder.details, category: eventPlaceholder.category)
////            detailsVC.delegate = self
////
////            present(detailsVC, animated: true, completion: {
////
////                textView.alpha = 1.0
////
////            })
////
////            return false
////
////        } else if textView == view.titleTextView {
////
////            textView.alpha = 0.7
////
////            let titleVC = TitleInputViewController(title: eventPlaceholder.title, category: eventPlaceholder.category)
////            titleVC.delegate = self
////
////            present(titleVC, animated: true, completion: {
////
////                textView.alpha = 1.0
////
////            })
////
////            return false
////
////        } else if textView == view.dateTextView {
////
////            textView.alpha = 0.7
////
////            let dateVC = DateInputViewController(startDate: eventPlaceholder.startDate, endDate: eventPlaceholder.endDate, category: eventPlaceholder.category)
////            dateVC.delegate = self
////
////            present(dateVC, animated: true, completion: {
////
////                textView.alpha = 1.0
////
////            })
////
////            return false
////
////        } else {
////
////            return false
////
////        }
//
//        return true
//
//    }
//
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        let vc = SFSafariViewController(url: URL)
//        vc.modalPresentationStyle = .pageSheet
//        vc.modalTransitionStyle = .coverVertical
//        vc.delegate = self
//        present(vc, animated: true)
//
//        return false
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: SFSafariViewControllerDelegate {
//
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//
//        controller.dismiss(animated: true)
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        if let eventAnnotation = annotation as? EventAnnotation {
//
//            if let eventAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: EventAnnotationView.defaultEventAnnotationViewReuseIdentifier) as? EventAnnotationView {
//
//                eventAnnotationView.setEventAnnotation(eventAnnotation: eventAnnotation)
//                return eventAnnotationView
//
//            } else {
//
//                let eventAnnotationView = EventAnnotationView(annotation: eventAnnotation, reuseIdentifier: EventAnnotationView.defaultEventAnnotationViewReuseIdentifier)
//                eventAnnotationView.setEventAnnotation(eventAnnotation: eventAnnotation)
//                return eventAnnotationView
//
//            }
//
//        } else {
//
//            return nil
//
//        }
//
//    }
//
//    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
//
//        if views.count == 1, let eventAnnotationView = views[0] as? EventAnnotationView {
//
//            eventAnnotationView.alpha = 0.0
//            eventAnnotationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//
//            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1,
//                           options: .curveEaseOut, animations: {
//
//                            eventAnnotationView.transform = .identity
//                            eventAnnotationView.alpha = 1.0
//
//            }, completion: nil)
//
//        } else {
//
//            return
//
//        }
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: UIScrollViewDelegate {
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        scrollView.contentOffset.x = 0
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        return true
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: TitleInputDelegate {
//
//    func setTitle(title: String?) {
//
//        guard let view = view as? CreateEventSecondSectionView else { return }
//
//        if let title = title {
//
//            eventPlaceholder.title = title
//
//            do { try eventController.setTitle(title: title) } catch let error as EventError { print("title: " + error.rawValue + "\n") } catch { print("title: " + error.localizedDescription + "\n") }
//
//            //view.titleTextView.text = title
//
//        }
//
//        if eventPlaceholder.title != nil && eventPlaceholder.startDate != nil && eventPlaceholder.endDate != nil && eventPlaceholder.location != nil {
//
//            view.createButton.isUserInteractionEnabled = true
//            view.createButton.alpha = 1.0
//
//        } else {
//
//            view.createButton.isUserInteractionEnabled = false
//            view.createButton.alpha = 0.6
//
//        }
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: DateInputDelegate {
//
//    func setDate(startDate: Date?, endDate: Date?) {
//
//        guard let view = view as? CreateEventSecondSectionView else { return }
//
//        if let startDate = startDate, let endDate = endDate, let formattedDate = Date.getFormattedDateInterval(start: startDate, end: endDate) {
//
//            eventPlaceholder.startDate = startDate
//            eventPlaceholder.endDate = endDate
//
//            do { try eventController.setStartDate(startDate: startDate) } catch let error as EventError { print("startDate: " + error.rawValue + "\n") } catch { print("startDate: " + error.localizedDescription + "\n") }
//            do { try eventController.setEndDate(endDate: endDate) } catch let error as EventError { print("endDate: " + error.rawValue + "\n") } catch { print("endDate: " + error.localizedDescription + "\n") }
//
//            //view.dateTextView.text = formattedDate
//
//        }
//
//        if eventPlaceholder.title != nil && eventPlaceholder.startDate != nil && eventPlaceholder.endDate != nil && eventPlaceholder.location != nil {
//
//            view.createButton.isUserInteractionEnabled = true
//            view.createButton.alpha = 1.0
//
//        } else {
//
//            view.createButton.isUserInteractionEnabled = false
//            view.createButton.alpha = 0.6
//
//        }
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: LocationInputDelegate {
//
//    func setLocation(location: CLLocationCoordinate2D?) {
//
//        guard let view = view as? CreateEventSecondSectionView else { return }
//
//        if let location = location {
//
//            eventPlaceholder.location = location
//            eventAnnotation.coordinate = location
//
//            do { try eventController.setLocation(location: location) } catch let error as EventError { print("location: " + error.rawValue + "\n") } catch { print("location: " + error.localizedDescription + "\n") }
//
//            if view.locationButton.titleLabel?.text == "Add" {
//
//                view.locationButton.setTitle("Edit", for: .normal)
//
//            }
//
//            location.lookUpLocationAddress { (address) in
//
//                if let address = address {
//
//                    view.locationLabel.text = String(address.split(separator: "\n")[0])
//
//                } else {
//
//                    view.locationLabel.text = "Address unavailable"
//
//                }
//
//            }
//
//            view.locationMapView.removeAnnotations(view.locationMapView.annotations)
//            view.locationMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: eventAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)), animated: false)
//            view.locationMapView.addAnnotation(eventAnnotation)
//
//            view.locationMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
//
//        }
//
//        if eventPlaceholder.title != nil && eventPlaceholder.startDate != nil && eventPlaceholder.endDate != nil && eventPlaceholder.location != nil {
//
//            view.createButton.isUserInteractionEnabled = true
//            view.createButton.alpha = 1.0
//
//        } else {
//
//            view.createButton.isUserInteractionEnabled = false
//            view.createButton.alpha = 0.6
//
//        }
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: DetailsInputDelegate {
//
//    func setDetails(details: String?) {
//
//        if let details = details {
//
//            eventPlaceholder.details = details
//
//            do { try eventController.setDetails(details: details) } catch let error as EventError { print("details: " + error.rawValue + "\n") } catch { print("details: " + error.localizedDescription + "\n") }
//
//            guard let view = view as? CreateEventSecondSectionView else { return }
//
//            //view.detailsTextView.text = details
//
//        }
//
//    }
//
//}
//
//extension CreateEventSecondSectionViewController: OnlineLinkInputDelegate {
//
//    func setOnlineLink(onlineLink: URL?) {
//
//        if let onlineLink = onlineLink {
//
//            eventPlaceholder.onlineURL = onlineLink
//
//            do { try eventController.setOnlineURL(onlineURL: onlineLink.absoluteString) } catch let error as EventError { print("onlineURL: " + error.rawValue + "\n") } catch { print("onlineURL: " + error.localizedDescription + "\n") }
//
//            guard let view = view as? CreateEventSecondSectionView else { return }
//
//            //view.editOnlineURLButton.setTitle("Edit", for: .normal)
//            view.onlineURLTextView.text = onlineLink.absoluteString
//            view.formatLabel.text = "Online"
////            view.formatIconImageView.image = UIImage(systemSymbol: .personCropRectangle).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
//
//        } else {
//
//            eventPlaceholder.onlineURL = nil
//            eventController.removeOnlineURL()
//
//            guard let view = view as? CreateEventSecondSectionView else { return }
//
//            //view.editOnlineURLButton.setTitle("Add", for: .normal)
//            view.onlineURLTextView.text = "Your event can take place online by adding a link. The physical location you enter will only be informative and help people find your event."
//            view.formatLabel.text = "Live"
////            view.formatIconImageView.image = UIImage(systemSymbol: .person3Fill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
//
//        }
//
//    }
//
//}
