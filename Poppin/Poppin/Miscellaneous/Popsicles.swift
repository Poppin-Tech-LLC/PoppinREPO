//
//  Popsicles.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/28/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import MapKit

enum PopsicleCategory: String {
    
    case Default = "Default"
    case Poppin = "Poppin"
    case Culture = "Culture"
    case Social = "Social"
    case Food = "Food"
    case Sports = "Sports"
    case Education = "Education"
    
}

struct PopsicleAnnotationData {
    
    var eventTitle: String
    var eventDetails: String? = ""
    var eventDate: String
    var eventStartTime: String
    var eventEndTime: String? = "11:59p"
    var eventCategory: PopsicleCategory
    var eventSubcategory1: PopsicleCategory? = PopsicleCategory.Default
    var eventSubcategory2: PopsicleCategory? = PopsicleCategory.Default
    var eventLocation: CLLocationCoordinate2D
    var eventAttendees: [String]? = []
    
}

final class PopsicleAnnotation: MKPointAnnotation {
    
    public static let defaultPopsicleAnnotationData: PopsicleAnnotationData = PopsicleAnnotationData(eventTitle: "Default Event", eventDate: "Today", eventStartTime: "12:00a", eventCategory: PopsicleCategory.Default, eventLocation: CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619))
    
    private(set) var popsicleAnnotationData: PopsicleAnnotationData = PopsicleAnnotation.defaultPopsicleAnnotationData
    
    convenience init(eventTitle: String, eventDetails: String?, eventDate: String, eventStartTime: String, eventEndTime: String?, eventCategory: PopsicleCategory, eventSubcategory1: PopsicleCategory?, eventSubcategory2: PopsicleCategory?, eventLocation: CLLocationCoordinate2D, eventAttendees: [String]?) {
        
        self.init(popsicleAnnotationData: PopsicleAnnotationData(eventTitle: eventTitle, eventDetails: eventDetails, eventDate: eventDate, eventStartTime: eventStartTime, eventEndTime: eventEndTime, eventCategory: eventCategory, eventSubcategory1: eventSubcategory1, eventSubcategory2: eventSubcategory2, eventLocation: eventLocation, eventAttendees: eventAttendees))
        
    }
    
    init(popsicleAnnotationData: PopsicleAnnotationData?) {
        
        super.init()
        
        if let newPopsicleAnnotationData = popsicleAnnotationData { self.popsicleAnnotationData = newPopsicleAnnotationData }
        
        self.coordinate = self.popsicleAnnotationData.eventLocation
        
    }
    
    public func getPopsicleAnnotationImage() -> UIImage {
        
        switch popsicleAnnotationData.eventCategory {
            
        case .Default: return .defaultPopsicleIcon256
        case .Poppin: return .poppinEventPopsicleIcon64
        case .Culture: return .culturePopsicleIcon64
        case .Social: return .socialPopsicleIcon64
        case .Food: return .foodPopsicleIcon64
        case .Sports: return .sportsPopsicleIcon64
        case .Education: return .educationPopsicleIcon64
            
        }
        
    }
    
    static func == (lhs: PopsicleAnnotation, rhs: PopsicleAnnotation) -> Bool {
        
        return lhs.popsicleAnnotationData.eventTitle == rhs.popsicleAnnotationData.eventTitle && lhs.popsicleAnnotationData.eventLocation.latitude == rhs.popsicleAnnotationData.eventLocation.latitude && lhs.popsicleAnnotationData.eventLocation.longitude == rhs.popsicleAnnotationData.eventLocation.longitude
        
    }
    
    override func isEqual(_ object: Any?) -> Bool {
    
        if let popsicleAnnotation = object as? PopsicleAnnotation {
         
            return self.popsicleAnnotationData.eventTitle == popsicleAnnotation.popsicleAnnotationData.eventTitle && self.popsicleAnnotationData.eventLocation.latitude == popsicleAnnotation.popsicleAnnotationData.eventLocation.latitude && self.popsicleAnnotationData.eventLocation.longitude == popsicleAnnotation.popsicleAnnotationData.eventLocation.longitude
            
        } else {
            
            return false
            
        }
        
    }
    
}

