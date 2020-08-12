//
//  EventInfoViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/10/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation

struct PreviewEventInfoViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(eventModel: EventModel(), isModallyPresented: true)
        
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = EventInfoViewController
    
}

struct TestPreviewEventInfoViewController: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewEventInfoViewController
    
}

final class EventInfoViewController: UIViewController {
    
    private var eventModel = EventModel()
    private var isModallyPresented: Bool = true
    
    lazy private var eventAnnotation: EventAnnotation = {
        
        var eventAnnotation = EventAnnotation(id: eventModel.id, location: eventModel.location, category: eventModel.category)
        return eventAnnotation
        
    }()
    
    init(eventModel: EventModel, isModallyPresented: Bool) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.eventModel = eventModel
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
    }
    
    override func loadView() {
        
        self.view = EventInfoView(eventModel: eventModel, isModallyPresented: isModallyPresented)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? EventInfoView else { return }
        
        view.cardScrollView.delegate = self
        view.titleTextView.delegate = self
        view.dateTextView.delegate = self
        view.detailsTextView.delegate = self
        view.onlineURLTextView.delegate = self
        view.locationMapView.delegate = self
        
        if !isModallyPresented {
            
            view.backButton.addTarget(self, action: #selector(segueBack), for: .touchUpInside)
            
        } else {
            
            view.clipsToBounds = true
            view.addShadowAndRoundCorners(cornerRadius: .getWidthFitSize(minSize: 14.0, maxSize: 16.0), shadowColor: nil, shadowOffset: nil, shadowOpacity: 0.0, shadowRadius: nil, topRightMask: true, topLeftMask: true, bottomRightMask: false, bottomLeftMask: false)
            
        }
        
        if MapViewController.uid == eventModel.authorId {
            
            view.editButton.addTarget(self, action: #selector(segueToEdit(sender:)), for: .touchUpInside)
            
        } else {
            
            view.rsvpButton.addTarget(self, action: #selector(rsvp(sender:)), for: .touchUpInside)
            
        }
        
        if eventModel.location != nil {
            
            view.locationMapView.addAnnotation(eventAnnotation)
            
        }
        
        view.locationMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200.0, longitudinalMeters: 200.0)), animated: true)
        view.locationMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200.0, longitudinalMeters: 200.0), animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if !isModallyPresented {
            
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if !isModallyPresented {
            
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            
        }
        
    }
    
    @objc private func segueBack() {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func segueToEdit(sender: LoadingButton) {
        
        
        
    }
    
    @objc private func rsvp(sender: LoadingButton) {
        
        
        
    }
    
    func setEvent(eventModel: EventModel) {
        
        if !isModallyPresented { return }
        
        guard let view = view as? EventInfoView else { return }
        
        self.eventModel = eventModel
        
        view.resetView(with: self.eventModel)
        
        view.locationMapView.removeAnnotations(view.locationMapView.annotations)
        
        eventAnnotation.id = self.eventModel.id
        eventAnnotation.category = self.eventModel.category ?? EventCategory.Culture
        eventAnnotation.coordinate = self.eventModel.location ?? CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619)
        
        if self.eventModel.location != nil {
            
            view.locationMapView.addAnnotation(eventAnnotation)
            
        }
        
        view.locationMapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200.0, longitudinalMeters: 200.0)), animated: true)
        view.locationMapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: eventAnnotation.coordinate.latitude + 0.00015, longitude: eventAnnotation.coordinate.longitude), latitudinalMeters: 200.0, longitudinalMeters: 200.0), animated: true)
        
    }
    
}

extension EventInfoViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return false
        
    }
    
}

extension EventInfoViewController: MKMapViewDelegate {
    
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

extension EventInfoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollView.contentOffset.x = 0
        
    }
    
}

extension EventInfoViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
        
    }
    
}
