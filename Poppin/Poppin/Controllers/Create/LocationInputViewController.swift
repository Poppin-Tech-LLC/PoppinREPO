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

/// Event Location Input Page UI Controller.
final class LocationInputViewController: UIViewController {
    
    // Holds the event input.
    private var eventInput: EventModel?
    
    // Closure called when transitioning to the previous page.
    private var completionHandler: ((CLLocationCoordinate2D?, String?) -> Void)?
    
    // Locations to show according to the search query.
    private var searchResults: [MKLocalSearchCompletion]?
    
    // Autocomplete searching controller.
    private var searchController: MKLocalSearchCompleter?
    
    // Campus region. It is used for location searching.
    private let mapBoundary = MKCoordinateRegion(center: MapViewController.defaultMapViewCenterLocation, latitudinalMeters: MapViewController.defaultMapViewRegionRadius, longitudinalMeters: MapViewController.defaultMapViewRegionRadius)
    
    /**
    Custom class init to set the modal presentation and transition style, update the location input field for the current event, and assign a completion handler.

    - Parameters:
        - eventInput: Input entered so far for the current event being created.
        - completionHandler: Closure called when transitioning to the previous section.
    */
    init(eventInput: EventModel?, completionHandler: ((CLLocationCoordinate2D?, String?) -> Void)?) {
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
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
        
        self.view = LocationInputView()
        
    }
    
    /// Overrides superclass method to connect UI elements to the controller.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 2. Setting targets and delegation.
        view.mapView.delegate = self
        view.searchBarView.searchBar.delegate = self
        view.searchView.tableView.delegate = self
        view.searchView.tableView.dataSource = self
        
        view.backButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        view.searchBarView.cancelButton.addTarget(self, action: #selector(closeSearchView), for: .touchUpInside)
        
    }
    
    /// Overrides superclass method to update UI.
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 2. Updating input field UI with event input passed.
        view.updateUI(eventInput: eventInput)
        
    }
    
    // Close the input field without saving changes.
    @objc private func cancel() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 2. If the user has made any changes, show an alert reminding the user that any changes will be lost.
        if view.mapView.annotations.count == 0 {
            
            dismiss(animated: true, completion: nil)
            
        } else if let latitude = eventInput?.location?.latitude, let longitude = eventInput?.location?.longitude, latitude == view.eventAnnotation.coordinate.latitude, longitude == view.eventAnnotation.coordinate.longitude {
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            let alertVC = AlertViewController(alertTitle: "Are you sure you wisth to exit?", alertMessage: "Any edits will be lost.", leftActionTitle: "Exit", leftAction: { [weak self] in
                
                guard let self = self else { return }
                
                self.dismiss(animated: true, completion: nil)
            
            }, rightActionTitle: "Stay")
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    // Close the input field and save changes by calling the return closure.
    @objc private func save() {
    
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 2. If no location has been selected show an error. Else, if changes have been made call the return closure.
        if view.mapView.annotations.count == 0 {
            
            let alertVC = AlertViewController(alertTitle: "No location selected", alertMessage: "Please select a location on the map or search for one.")
            
            self.present(alertVC, animated: true, completion: nil)
            
        } else if let latitude = eventInput?.location?.latitude, let longitude = eventInput?.location?.longitude, latitude == view.eventAnnotation.coordinate.latitude, longitude == view.eventAnnotation.coordinate.longitude {
            
            dismiss(animated: true, completion: nil)
            
        } else {
            
            completionHandler?(view.eventAnnotation.coordinate, view.locationTextView.text)
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    // Stops searching and hides the search view.
    @objc private func closeSearchView() {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 2. Stops the search controller.
        searchController?.cancel()
        searchController = nil
        
        // 3. Hides search view.
        view.hideSearch()
        
    }
    
}

extension LocationInputViewController: MKMapViewDelegate {
    
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
    
    /// Delegate function called after viewFor. It animates the appearance of the annotations on the map.
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        for annotationView in views {
            
            annotationView.alpha = 0.0
            annotationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.825, initialSpringVelocity: 1.0,
                           options: .curveEaseInOut, animations: {
                            
                            annotationView.transform = .identity
                            annotationView.alpha = 1.0
                            
            }, completion: nil)
            
        }
        
    }
    
}

extension LocationInputViewController: UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    
    /// Delegate function called when the search bar is about to begin editing. If hidden, It displays the search view and initializes the search controller.
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return false }
        
        if view.dimOverlayView.isHidden {
            
            // 2. Show the search view.
            view.showSearch()
            
            // 3. Initialize the search controller.
            searchController = MKLocalSearchCompleter()
            searchController?.delegate = self
            searchController?.region = mapBoundary
            searchController?.resultTypes = [.address, .pointOfInterest]
        
        }
        
        return true
        
    }
    
    /// Delegate function called after new text has been entered on the search bar. Sends a new search query to the search controller.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchController?.queryFragment = searchBar.text ?? ""
        
    }
    
    /// Delegate function called once the search controller has finished with the search query. Updates the results table with the new locations.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 2. Populates the results array with all locations returned from the search query.
        searchResults = completer.results
        
        // 3. Updates results table with new locations.
        view.searchView.tableView.reloadData()
        
    }
    
    /// Delegate function called if the search controller fails while handling a query. It empties the results table and prints an error.
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
        // 1. Prints error.
        print("Location Search Error: ", error.localizedDescription)
        
        // 2. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 3. Empties the results table.
        searchResults = []
        view.searchView.tableView.reloadData()
        
    }
    
}

extension LocationInputViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Delegate function called when the table reloads. Returns the amount of rows to show according to the search results.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let searchResults = searchResults, searchResults.count > 0 {
            
            return searchResults.count
            
        } else {
            
            return 1
            
        }
        
    }
    
    /// Delegate function called for each row of the table when it reloads. Returns custom location cells initialized according to the
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return UITableViewCell() }
        
        // 2. Safe casting table view cell to custom location cell.
        if let locationCell = tableView.dequeueReusableCell(withIdentifier: LocationCell.defaultReuseIdentifier, for: indexPath) as? LocationCell {
            
            // 3. Adjust separator line depending on the table row (fixes bug where last table row cell also has a separator despite being the last cell).
            if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
                
                locationCell.separatorInset = UIEdgeInsets(top: 0.0, left: view.frame.size.width, bottom: 0.0, right: 0.0)
                locationCell.selectionStyle = .none
                
            } else {
                
                locationCell.separatorInset = .zero
                locationCell.selectionStyle = .none
                
            }
            
            // 4. Update cell with data from search results. If no results are found or nothing has been searched yet, show a placeholder cell.
            if let searchResults = searchResults, searchResults.count > 0 {
                
                locationCell.title = searchResults[indexPath.row].title
                locationCell.address = searchResults[indexPath.row].subtitle
                
            } else if let searchText = view.searchBarView.searchBar.text, !searchText.isEmpty  {
                
                locationCell.title = "No results found..."
                locationCell.address = nil
                
            } else {
                
                locationCell.title = "Search for locations around you."
                locationCell.address = nil
                
            }
            
            return locationCell
            
        } else { return UITableViewCell() }
        
    }
    
    /// Delegate function called when a cell has been selected. Zoom to the selected location if is within bounds.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 1. Safe casting root view to custom view.
        guard let view = view as? LocationInputView else { return }
        
        // 2. Safe casting search results and the selected cell as a custom location cell.
        if let searchResults = searchResults, searchResults.count > 0, let locationCell = tableView.dequeueReusableCell(withIdentifier: LocationCell.defaultReuseIdentifier, for: indexPath) as? LocationCell {
            
            // 3. Start loading and disable table view so other locations cannot be selected.
            locationCell.startLoading()
            view.searchView.tableView.isUserInteractionEnabled = false
            
            // 4. Fetch the location of the data passed from the search result.
            MKLocalSearch(request: MKLocalSearch.Request(completion: searchResults[indexPath.row])).start { [weak self] (response, error) in
                
                guard let self = self else { return }
                
                // 5. If an error is found, display it and enable the table view again.
                if let error = error {
                    
                    print("Local search error: ", error.localizedDescription)
                    
                    let alertVC = AlertViewController(alertTitle: "An error occurred", alertMessage: "Please try again.")
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    locationCell.stopLoading()
                    view.searchView.tableView.isUserInteractionEnabled = true
                    
                }
                
                // 6. A location is found.
                else if let response = response {
                    
                    // 7. Loop through the locations found. If a location is within bounds, enable the table view, close the search view and zoom to the selected location.
                    for mapItem in response.mapItems {
                        
                        if mapItem.placemark.coordinate.isIn(region: self.mapBoundary) {
                            
                            locationCell.stopLoading()
                            view.searchView.tableView.isUserInteractionEnabled = true
                            
                            view.dropAnnotation(at: mapItem.placemark)
                            view.searchBarView.cancelButton.sendActions(for: .touchUpInside)
                            
                            return
                            
                        } else {
                            
                            continue
                            
                        }
                        
                    }
                    
                    // 8. Location is out of bounds. Show an error, and enable the table view again.
                    let alertVC = AlertViewController(alertTitle: "Location is out of campus bounds", alertMessage: "Please choose a different one.")
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    locationCell.stopLoading()
                    view.searchView.tableView.isUserInteractionEnabled = true
                    
                }
                
                // 9. No locations were found. Show an error and enable the table view again.
                else {
                    
                    let alertVC = AlertViewController(alertTitle: "Location not found", alertMessage: "The selected location was not found. Please try again.")
                    
                    self.present(alertVC, animated: true, completion: nil)
                    
                    locationCell.stopLoading()
                    view.searchView.tableView.isUserInteractionEnabled = true
                    
                }
                
            }
            
        }
        
    }
    
}

struct PreviewLocationInputViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        
        return UIViewControllerType(eventInput: nil, completionHandler: nil)
        
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
