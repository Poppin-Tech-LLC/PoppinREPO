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

struct PreviewCreateEventSecondSectionViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(eventController: EventController())
        
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = CreateEventSecondSectionViewController
    
}

struct TestPreviewCreateEventSecondSectionViewController: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewCreateEventSecondSectionViewController
    
}

protocol TitleInputDelegate: NSObject {
    
    func setTitle(title: String?)
    
}

extension TitleInputDelegate {
    
    func setTitle(title: String?) {}
    
}

protocol DateInputDelegate: NSObject {
    
    func closeDatePicker()
    func setDate(startDate: Date?, endDate: Date?)
    
}

extension DateInputDelegate {
    
    func closeDatePicker() {}
    func setDate(startDate: Date?, endDate: Date?) {}
    
}

protocol LocationInputDelegate: NSObject {
    
    func dropPopsicle(at point: CGPoint)
    func setLocation(location: CLLocationCoordinate2D?)
    
}

extension LocationInputDelegate {
    
    func dropPopsicle(at point: CGPoint) {}
    func setLocation(location: CLLocationCoordinate2D?) {}
    
}

protocol DetailsInputDelegate: NSObject {
    
    func setDetails(details: String?)
    
}

extension DetailsInputDelegate {
    
    func setDetails(details: String?) {}
    
}

protocol OnlineLinkInputDelegate: NSObject {
    
    func setOnlineLink(onlineLink: URL?)
    
}

extension OnlineLinkInputDelegate {
    
    func setOnlineLink(onlineLink: URL?) {}
    
}

final class CreateEventSecondSectionViewController: UIViewController {
    
    private var eventController = EventController()
    private var eventPlaceholder = EventModel()
    
    weak var delegate: CreateEventDelegate?
    
    lazy private var eventAnnotation: EventAnnotation = {
        
        var eventAnnotation = EventAnnotation(id: eventPlaceholder.id, location: eventPlaceholder.location, category: eventPlaceholder.category)
        return eventAnnotation
        
    }()
    
    init(eventController: EventController) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.eventController.merge(with: eventController)
        eventPlaceholder = self.eventController.rawValue()
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    override func loadView() {
        
        self.view = CreateEventSecondSectionView(eventModel: eventPlaceholder)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? CreateEventSecondSectionView else { return }
        
        view.cardScrollView.delegate = self
        view.titleTextView.delegate = self
        view.dateTextView.delegate = self
        view.detailsTextView.delegate = self
        view.onlineURLTextView.delegate = self
        view.locationMapView.delegate = self
        view.backButton.addTarget(self, action: #selector(segueBack), for: .touchUpInside)
        view.editLocationButton.addTarget(self, action: #selector(segueToLocationInput), for: .touchUpInside)
        view.editOnlineURLButton.addTarget(self, action: #selector(segueToOnlineURLInput), for: .touchUpInside)
        view.createButton.addTarget(self, action: #selector(create(sender:)), for: .touchUpInside)
        
        if eventPlaceholder.location != nil {
            
            view.locationMapView.addAnnotation(eventAnnotation)
            
        }
        
        view.locationMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200.0, longitudinalMeters: 200.0)), animated: true)
        view.locationMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200.0, longitudinalMeters: 200.0), animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        delegate?.saveProgress(eventController: eventController)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    private func setVisibility(isPublic: Bool) {
        
        guard let view = view as? CreateEventSecondSectionView else { return }
        
        if isPublic {
            
            UIView.transition(with: view.visibilityLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                view.visibilityLabel.text = "Public"
                
            }, completion: nil)
            
            UIView.transition(with: view.visibilityIconImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                view.visibilityIconImageView.image = UIImage(systemSymbol: .globe).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                
            }, completion: nil)
            
        } else {
            
            UIView.transition(with: view.visibilityLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                view.visibilityLabel.text = "Private"
                
            }, completion: nil)
            
            UIView.transition(with: view.visibilityIconImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                
                view.visibilityIconImageView.image = UIImage(systemSymbol: .lockFill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
                
            }, completion: nil)
            
        }
        
    }
    
    @objc private func segueBack() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func segueToLocationInput() {
        
        var location = eventPlaceholder.location
        
        do { location = try eventController.getLocation() } catch let error as EventError { print("location: " + error.rawValue + "\n") } catch { print("location: " + error.localizedDescription + "\n") }
        
        let locationVC = LocationInputViewController(location: location, mapBoundry: nil, category: eventPlaceholder.category)
        locationVC.delegate = self
        
        present(locationVC, animated: true, completion: nil)
        
    }
    
    @objc private func segueToOnlineURLInput() {
        
        var onlineURL = eventPlaceholder.onlineURL
        
        do { onlineURL = try eventController.getOnlineURL() } catch let error as EventError { print("onlineURL: " + error.rawValue + "\n") } catch { print("onlineURL: " + error.localizedDescription + "\n") }
        
        let onlineURLVC = OnlineLinkInputViewController(onlineLink: onlineURL, category: eventPlaceholder.category)
        onlineURLVC.delegate = self
        
        present(onlineURLVC, animated: true, completion: nil)
        
    }
    
    @objc private func create(sender: LoadingButton) {
        
        sender.startLoading()
        
        let db = Firestore.firestore()
        
        let geoFirestore = GeoFirestore(collectionRef: db.collection("geolocs"))
        
        var ref2: DocumentReference? = nil
        
        let eventData = eventController.rawValue()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        ref2 = db.collection("privatePopsicles").addDocument(data: [
            "longitude": eventData.location!.longitude as Any,
            "latitude": eventData.location!.latitude as Any,
            "eventName": eventData.title as Any,
            "eventDetails": eventData.details as Any,
            "startDate": dateFormatter.string(from: eventData.startDate!),
            "endDate": dateFormatter.string(from: eventData.endDate!),
            "hashtags": "",
            "createdBy": MapViewController.uid,
            "category": eventData.category?.rawValue as Any
        ]) { err in
            
            if let err = err {
                
                sender.stopLoading()
                print("Error adding document: \(err)")
                
            } else {
                
                print("Document added with ID: \(ref2!.documentID)")
                geoFirestore.setLocation(location: CLLocation(latitude: eventData.location!.latitude, longitude: eventData.location!.longitude), forDocumentWithID: ref2!.documentID) { [weak self] (error) in
                    
                    guard let self = self else { return }
                    
                    if let error = error {
                        
                        sender.stopLoading()
                        print("An error occured: \(error)")
                        
                    } else {
                        
                        sender.stopLoading()
                        print("Saved location successfully!")
                        
                        self.navigationController?.dismiss(animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

extension CreateEventSecondSectionViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        guard let view = view as? CreateEventSecondSectionView else { return false }
        
        if textView == view.detailsTextView {
            
            textView.alpha = 0.7
            
            let detailsVC = DetailsInputViewController(details: eventPlaceholder.details, category: eventPlaceholder.category)
            detailsVC.delegate = self
            
            present(detailsVC, animated: true, completion: {
                
                textView.alpha = 1.0
            
            })
            
            return false
            
        } else if textView == view.titleTextView {
            
            textView.alpha = 0.7
            
            let titleVC = TitleInputViewController(title: eventPlaceholder.title, category: eventPlaceholder.category)
            titleVC.delegate = self
            
            present(titleVC, animated: true, completion: {
            
                textView.alpha = 1.0
            
            })
            
            return false
            
        } else if textView == view.dateTextView {
            
            textView.alpha = 0.7
            
            let dateVC = DateInputViewController(startDate: eventPlaceholder.startDate, endDate: eventPlaceholder.endDate, category: eventPlaceholder.category)
            dateVC.delegate = self
            
            present(dateVC, animated: true, completion: {
                
                textView.alpha = 1.0
            
            })
            
            return false
            
        } else {
            
            return false
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let vc = SFSafariViewController(url: URL)
        vc.modalPresentationStyle = .pageSheet
        vc.modalTransitionStyle = .coverVertical
        vc.delegate = self
        present(vc, animated: true)
        
        return false
        
    }
    
}

extension CreateEventSecondSectionViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
        controller.dismiss(animated: true)
        
    }
    
}

extension CreateEventSecondSectionViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let eventAnnotation = annotation as? EventAnnotation {
            
            if let eventAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: EventAnnotationView.defaultEventAnnotationViewReuseIdentifier) as? EventAnnotationView {
                
                eventAnnotationView.setEventAnnotation(eventAnnotation: eventAnnotation)
                return eventAnnotationView
                
            } else {
                
                let eventAnnotationView = EventAnnotationView(annotation: eventAnnotation, reuseIdentifier: EventAnnotationView.defaultEventAnnotationViewReuseIdentifier)
                eventAnnotationView.setEventAnnotation(eventAnnotation: eventAnnotation)
                return eventAnnotationView
                
            }
            
        } else {
            
            return nil
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        if views.count == 1, let eventAnnotationView = views[0] as? EventAnnotationView {
            
            eventAnnotationView.alpha = 0.0
            eventAnnotationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1,
                           options: .curveEaseOut, animations: {
                            
                            eventAnnotationView.transform = .identity
                            eventAnnotationView.alpha = 1.0
                            
            }, completion: nil)
            
        } else {
            
            return
            
        }
        
    }
    
}

extension CreateEventSecondSectionViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.contentOffset.x = 0
        
    }
    
}

extension CreateEventSecondSectionViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}

extension CreateEventSecondSectionViewController: TitleInputDelegate {
    
    func setTitle(title: String?) {
        
        guard let view = view as? CreateEventSecondSectionView else { return }
        
        if let title = title {
            
            eventPlaceholder.title = title
            
            do { try eventController.setTitle(title: title) } catch let error as EventError { print("title: " + error.rawValue + "\n") } catch { print("title: " + error.localizedDescription + "\n") }
            
            view.titleTextView.text = title
            
        }
        
        if eventPlaceholder.title != nil && eventPlaceholder.startDate != nil && eventPlaceholder.endDate != nil && eventPlaceholder.location != nil {
            
            view.createButton.isUserInteractionEnabled = true
            view.createButton.alpha = 1.0
            
        } else {
            
            view.createButton.isUserInteractionEnabled = false
            view.createButton.alpha = 0.6
            
        }
        
    }
    
}

extension CreateEventSecondSectionViewController: DateInputDelegate {
    
    func setDate(startDate: Date?, endDate: Date?) {
        
        guard let view = view as? CreateEventSecondSectionView else { return }
        
        if let startDate = startDate, let endDate = endDate, let formattedDate = Date.getFormattedDateInterval(start: startDate, end: endDate) {
            
            eventPlaceholder.startDate = startDate
            eventPlaceholder.endDate = endDate
            
            do { try eventController.setStartDate(startDate: startDate) } catch let error as EventError { print("startDate: " + error.rawValue + "\n") } catch { print("startDate: " + error.localizedDescription + "\n") }
            do { try eventController.setEndDate(endDate: endDate) } catch let error as EventError { print("endDate: " + error.rawValue + "\n") } catch { print("endDate: " + error.localizedDescription + "\n") }
            
            view.dateTextView.text = formattedDate
            
        }
        
        if eventPlaceholder.title != nil && eventPlaceholder.startDate != nil && eventPlaceholder.endDate != nil && eventPlaceholder.location != nil {
            
            view.createButton.isUserInteractionEnabled = true
            view.createButton.alpha = 1.0
            
        } else {
            
            view.createButton.isUserInteractionEnabled = false
            view.createButton.alpha = 0.6
            
        }
        
    }
    
}

extension CreateEventSecondSectionViewController: LocationInputDelegate {
    
    func setLocation(location: CLLocationCoordinate2D?) {
        
        guard let view = view as? CreateEventSecondSectionView else { return }
        
        if let location = location {
            
            eventPlaceholder.location = location
            eventAnnotation.coordinate = location
            
            do { try eventController.setLocation(location: location) } catch let error as EventError { print("location: " + error.rawValue + "\n") } catch { print("location: " + error.localizedDescription + "\n") }
            
            if view.editLocationButton.titleLabel?.text == "Add" {
                                   
                view.editLocationButton.setTitle("Edit", for: .normal)
                                   
            }
            
            location.lookUpLocationAddress { (address) in
                
                if let address = address {
                    
                    view.locationLabel.text = String(address.split(separator: "\n")[0])
                    
                } else {
                    
                    view.locationLabel.text = "Address unavailable"
                    
                }
                
            }
            
            view.locationMapView.removeAnnotations(view.locationMapView.annotations)
            view.locationMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: eventAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)), animated: false)
            view.locationMapView.addAnnotation(eventAnnotation)
            
            view.locationMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
            
        }
        
        if eventPlaceholder.title != nil && eventPlaceholder.startDate != nil && eventPlaceholder.endDate != nil && eventPlaceholder.location != nil {
            
            view.createButton.isUserInteractionEnabled = true
            view.createButton.alpha = 1.0
            
        } else {
            
            view.createButton.isUserInteractionEnabled = false
            view.createButton.alpha = 0.6
            
        }
        
    }
    
}

extension CreateEventSecondSectionViewController: DetailsInputDelegate {
    
    func setDetails(details: String?) {
        
        if let details = details {
            
            eventPlaceholder.details = details
            
            do { try eventController.setDetails(details: details) } catch let error as EventError { print("details: " + error.rawValue + "\n") } catch { print("details: " + error.localizedDescription + "\n") }
            
            guard let view = view as? CreateEventSecondSectionView else { return }
            
            view.detailsTextView.text = details
            
        }
        
    }
    
}

extension CreateEventSecondSectionViewController: OnlineLinkInputDelegate {
    
    func setOnlineLink(onlineLink: URL?) {
        
        if let onlineLink = onlineLink {
            
            eventPlaceholder.onlineURL = onlineLink
            
            do { try eventController.setOnlineURL(onlineURL: onlineLink.absoluteString) } catch let error as EventError { print("onlineURL: " + error.rawValue + "\n") } catch { print("onlineURL: " + error.localizedDescription + "\n") }
            
            guard let view = view as? CreateEventSecondSectionView else { return }
            
            view.editOnlineURLButton.setTitle("Edit", for: .normal)
            view.onlineURLTextView.text = onlineLink.absoluteString
            view.formatLabel.text = "Online"
            view.formatIconImageView.image = UIImage(systemSymbol: .personCropRectangle).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            
        } else {
            
            eventPlaceholder.onlineURL = nil
            eventController.removeOnlineURL()
            
            guard let view = view as? CreateEventSecondSectionView else { return }
            
            view.editOnlineURLButton.setTitle("Add", for: .normal)
            view.onlineURLTextView.text = "Your event can take place online by adding a link. The physical location you enter will only be informative and help people find your event."
            view.formatLabel.text = "Live"
            view.formatIconImageView.image = UIImage(systemSymbol: .person3Fill).withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
            
        }
        
    }
    
}
