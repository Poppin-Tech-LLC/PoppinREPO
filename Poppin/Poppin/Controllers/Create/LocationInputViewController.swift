//
//  LocationInputViewController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/1/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftUI
import CoreLocation
import MapKit
import Contacts

struct PreviewLocationInputViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(location: nil, mapBoundry: nil, category: nil)
        
    }
    
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    typealias UIViewControllerType = LocationInputViewController
    
}

struct TestPreviewLocationInputViewController: PreviewProvider {
    
    static var previews: Previews {
        
        return Previews()
        
    }
    
    typealias Previews = PreviewLocationInputViewController
    
}

final class LocationInputViewController: UIViewController {
    
    private var location: CLLocationCoordinate2D?
    private var mapBoundry: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619), latitudinalMeters: 3000.0, longitudinalMeters: 3000.0)
    private var category: EventCategory?
    private var searchResults: [MKLocalSearchCompletion]?
    
    weak var delegate: LocationInputDelegate?
    private var firstTimeLoading = true
    private var hasBeenTapped = false
    private var isOutOfBounds = false
    
    private var locationSearchController: MKLocalSearchCompleter?
    
    lazy private var eventAnnotation: EventAnnotation = {
        
        var eventAnnotation = EventAnnotation(id: nil, location: location, category: category)
        return eventAnnotation
        
    }()
    
    init(location: CLLocationCoordinate2D?, mapBoundry: MKCoordinateRegion?, category: EventCategory?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        self.location = location
        if let mapBoundry = mapBoundry { self.mapBoundry = mapBoundry }
        self.category = category
        
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
    }
    
    override func loadView() {
        
        self.view = LocationInputView(category: category, mapBoundry: mapBoundry, location: location)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = view as? LocationInputView else { return }
        
        view.delegate = self
        view.mapView.delegate = self
        view.searchBar.delegate = self
        view.searchTableView.delegate = self
        view.searchTableView.dataSource = self
        view.backButton.addTarget(self, action: #selector(segueBack), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        view.searchBarCancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        if let location = location {
            
            hasBeenTapped = true
            view.mapView.addAnnotation(eventAnnotation)
            view.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), latitudinalMeters: 200.0, longitudinalMeters: 200.0), animated: false)
            
        } else {
            
            view.mapView.setRegion(mapBoundry, animated: false)
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        if !firstTimeLoading { return }
        
        guard let view = view as? LocationInputView else { return }
        
        if hasBeenTapped {
            
            view.helpTitleView.transform = CGAffineTransform(translationX: 0.0, y: view.helpTitleView.frame.height + (view.yInset*2) + view.safeAreaInsets.bottom)
            
        } else {
            
            view.confirmLocationView.transform = CGAffineTransform(translationX: 0.0, y: view.confirmLocationView.frame.height)
            
        }
        
        firstTimeLoading = false
        
    }
    
    @objc private func segueBack() {
        
        if let location = location, (location.latitude != eventAnnotation.coordinate.latitude || location.longitude != eventAnnotation.coordinate.longitude) {
            
            let alertVC = AlertViewController(alertTitle: "Are you sure you wish to exit?", alertMessage: "Any changes will be lost.", leftActionTitle: "Exit", leftAction: { [weak self] in
                
                guard let self = self else { return }
                
                self.dismiss(animated: true, completion: nil)
            
            }, rightActionTitle: "Stay")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func save() {
        
        if isOutOfBounds {
            
            let alertVC = AlertViewController(alertTitle: "Location is out of campus bounds", alertMessage: "Please try a different one.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if let location = location, location.latitude == eventAnnotation.coordinate.latitude, location.longitude == eventAnnotation.coordinate.longitude {
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            delegate?.setLocation(location: eventAnnotation.coordinate)
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc private func cancel() {
        
        guard let view = view as? LocationInputView else { return }
        
        view.searchBar.endEditing(true)
        locationSearchController?.cancel()
        locationSearchController = nil
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            view.searchBarShowingConstraints[0].isActive = false
            view.searchBarShowingConstraints[1].isActive = false
            view.searchBarHiddenConstraints[0].isActive = true
            view.searchBarHiddenConstraints[1].isActive = true
            view.searchBarCancelButton.alpha = 0.0
            view.backButton.alpha = 1.0
            view.blurOverlayView.alpha = 0.0
            view.searchScrollView.alpha = 0.0
            view.layoutIfNeeded()
            
        }, completion: { finished in
        
            view.blurOverlayView.isHidden = true
            view.searchScrollView.isHidden = true
        
        })
        
    }
    
    private func dropPopsicle(at placemark: MKPlacemark) {
        
        guard let view = view as? LocationInputView else { return }
        
        eventAnnotation.coordinate = placemark.coordinate
        view.mapView.removeAnnotations(view.mapView.annotations)
        view.mapView.addAnnotation(eventAnnotation)
        
        if let postalAddress = placemark.postalAddress {
            
            let address = CNPostalAddressFormatter.string(from: postalAddress, style: .mailingAddress)
            view.locationTextView.text = String(address.split(separator: "\n")[0])
            
        } else {
            
            view.locationTextView.text = "Address unavailable"
            
        }
        
        if !self.hasBeenTapped {
            
            view.confirmLocationView.transform = CGAffineTransform(translationX: 0.0, y: view.confirmLocationView.frame.height)
            
            UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.85, initialSpringVelocity: 1,
                           options: .curveEaseOut, animations: {
                            
                            view.helpTitleView.transform = CGAffineTransform(translationX: 0.0, y: view.helpTitleView.frame.height + (view.yInset*2) + view.safeAreaInsets.bottom)
                            view.confirmLocationView.transform = .identity
                            
            }, completion: { finished in
                
                self.hasBeenTapped = true
            
            })
            
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: {
                        
                        view.mapView.setRegion(MKCoordinateRegion(center: self.eventAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
                        
        }, completion: nil)
        
    }
    
}

extension LocationInputViewController: MKMapViewDelegate {
    
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

extension LocationInputViewController: LocationInputDelegate {
    
    func dropPopsicle(at point: CGPoint) {
        
        guard let view = view as? LocationInputView else { return }
        
        let touchCoordinate = view.mapView.convert(point, toCoordinateFrom: view.mapView)
        
        eventAnnotation.coordinate = touchCoordinate
        isOutOfBounds = false
        view.mapView.removeAnnotations(view.mapView.annotations)
        view.mapView.addAnnotation(self.eventAnnotation)
        
        touchCoordinate.lookUpLocationAddress { (address) in
            
            if let address = address {
                
                view.locationTextView.text = String(address.split(separator: "\n")[0])
                
            } else {
                
                view.locationTextView.text = "Address unavailable"
                
            }
            
        }
        
        if !hasBeenTapped {
            
            view.confirmLocationView.transform = CGAffineTransform(translationX: 0.0, y: view.confirmLocationView.frame.height)
            
            UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.85, initialSpringVelocity: 1,
                           options: .curveEaseOut, animations: {
                            
                            view.helpTitleView.transform = CGAffineTransform(translationX: 0.0, y: view.helpTitleView.frame.height + (view.yInset*2) + view.safeAreaInsets.bottom)
                            view.confirmLocationView.transform = .identity
                            
            }, completion: { finished in
        
                self.hasBeenTapped = true
            
            })
            
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: {
                        
                        view.mapView.setRegion(MKCoordinateRegion(center: self.eventAnnotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
                        
        }, completion: nil)
        
    }
    
}

extension LocationInputViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        guard let view = view as? LocationInputView else { return false }
        
        if searchBar == view.searchBar {
         
            if view.blurOverlayView.isHidden {
                
                locationSearchController = MKLocalSearchCompleter()
                locationSearchController?.delegate = self
                locationSearchController?.region = mapBoundry
                locationSearchController?.resultTypes = [.address, .pointOfInterest]
                
                view.blurOverlayView.isHidden = false
                view.searchScrollView.isHidden = false
                
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    view.searchBarHiddenConstraints[0].isActive = false
                    view.searchBarHiddenConstraints[1].isActive = false
                    view.searchBarShowingConstraints[0].isActive = true
                    view.searchBarShowingConstraints[1].isActive = true
                    view.searchBarCancelButton.alpha = 1.0
                    view.backButton.alpha = 0.0
                    view.blurOverlayView.alpha = 1.0
                    view.searchScrollView.alpha = 1.0
                    view.layoutIfNeeded()
                    
                }, completion: nil)
                
            }
            
            return true
            
        } else {
            
            return false
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let view = view as? LocationInputView else { return }
        
        if searchBar == view.searchBar {
            
            locationSearchController?.queryFragment = searchBar.text ?? ""
            
        }
        
    }
    
}

extension LocationInputViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let searchResults = searchResults, searchResults.count > 0 {
            
            return searchResults.count
            
        } else {
            
            return 1
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let view = view as? LocationInputView else { return UITableViewCell() }
        
        if tableView == view.searchTableView, let locationCell = tableView.dequeueReusableCell(withIdentifier: LocationSearchCell.cellIdentifier, for: indexPath) as? LocationSearchCell {
            
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                
                locationCell.separatorInset = UIEdgeInsets(top: 0.0, left: view.frame.size.width, bottom: 0.0, right: 0.0)
                
            } else {
                
                locationCell.separatorInset = .zero
                
            }
            
            locationCell.selectionStyle = .none
            
            if let searchResults = searchResults, searchResults.count > 0 {
                
                locationCell.title = searchResults[indexPath.row].title
                locationCell.subtitle = searchResults[indexPath.row].subtitle
                
            } else if let searchText = view.searchBar.text, !searchText.isEmpty  {
                
                locationCell.title = "No results found..."
                locationCell.subtitle = ""
                
            } else {
                
                locationCell.title = "Search for locations around you."
                locationCell.subtitle = ""
                
            }
            
            return locationCell
            
        } else {
            
            return UITableViewCell()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let view = view as? LocationInputView else { return }
        
        if tableView == view.searchTableView, let searchResults = searchResults, searchResults.count > 0, let locationCell = tableView.dequeueReusableCell(withIdentifier: LocationSearchCell.cellIdentifier, for: indexPath) as? LocationSearchCell {
            
            locationCell.startLoading()
            view.searchTableView.isUserInteractionEnabled = false
            
            let localSearch = MKLocalSearch(request: MKLocalSearch.Request(completion: searchResults[indexPath.row]))
            
            localSearch.start { [weak self] (response, error) in
                
                guard let self = self else { return }
                
                if let error = error {
                    
                    print("Local search error: ", error.localizedDescription)
                    
                    let alertVC = AlertViewController(alertTitle: "An error occurred", alertMessage: "Please try again.")
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    locationCell.stopLoading()
                    view.searchTableView.isUserInteractionEnabled = true
                    
                } else if let response = response {
                    
                    for mapItem in response.mapItems {
                        
                        if mapItem.placemark.coordinate.isInRegion(region: CLCircularRegion(center: self.mapBoundry.center, radius: self.mapBoundry.span.latitudeDelta*111000*0.5, identifier: "mapBoundry")) {
                            
                            locationCell.stopLoading()
                            view.searchTableView.isUserInteractionEnabled = true
                            self.isOutOfBounds = false
                            self.dropPopsicle(at: mapItem.placemark)
                            self.cancel()
                            
                            return
                            
                        } else {
                            
                            continue
                            
                        }
                        
                    }
                    
                    let alertVC = AlertViewController(alertTitle: "Location is out of bounds", alertMessage: "If you continue the location could be innacurate.", leftActionTitle: "Continue", leftAction: { [weak self] in
                        
                        guard let self = self else { return }
                        
                        locationCell.stopLoading()
                        view.searchTableView.isUserInteractionEnabled = true
                        self.isOutOfBounds = true
                        self.dropPopsicle(at: response.mapItems[0].placemark)
                        self.cancel()
                        
                        }, rightActionTitle: "Cancel")
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    locationCell.stopLoading()
                    view.searchTableView.isUserInteractionEnabled = true
                    
                } else {
                    
                    let alertVC = AlertViewController(alertTitle: "Location not found", alertMessage: "The selected location was not found. Please try again.")
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    locationCell.stopLoading()
                    view.searchTableView.isUserInteractionEnabled = true
                    
                }
                
            }
            
        }
        
    }
    
}

extension LocationInputViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        guard let view = view as? LocationInputView else { return }
        
        if completer == locationSearchController {
            
            searchResults = completer.results.filter({ (result) -> Bool in
                
                return result.subtitle.lowercased().contains("denver") || result.title.lowercased().contains("denver")
                
            })
            
            view.searchTableView.reloadData()
            
        }
        
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        print("Location Search Error: ", error.localizedDescription)
        
        guard let view = view as? LocationInputView else { return }
        
        searchResults = []
        view.searchTableView.reloadData()
        
    }
    
}
