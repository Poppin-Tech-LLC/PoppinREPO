//
//  NewPopsicleAnnotation.swift - Abstraction of a popsicle annotation.
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/28/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit
import MapKit

enum PopsicleCategory: String {
    
    case Education = "Education"
    case Food = "Food"
    case Social = "Social"
    case Sports = "Sports"
    case Culture = "Culture"
    case Poppin = "Poppin"
    case Default = "Default"
    
}

struct PopsicleAnnotationData {
    
    var eventTitle: String
    var eventDetails: String? = ""
    var eventStartDate: String
    var eventEndDate: String? = "11:59p"
    var eventCategory: PopsicleCategory
    var eventHashtags: String
    var eventLocation: CLLocationCoordinate2D
    var eventAttendees: [String]? = []
    
}

class PopsicleAnnotation: MKPointAnnotation {
    
    public static let defaultPopsicleAnnotationData: PopsicleAnnotationData = PopsicleAnnotationData(eventTitle: "Default Event", eventDetails: "Today", eventStartDate: PopsicleCategory.Default.rawValue, eventEndDate: "", eventCategory: PopsicleCategory.Default, eventHashtags: "", eventLocation: CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619))
    
    private(set) var popsicleAnnotationData: PopsicleAnnotationData = PopsicleAnnotation.defaultPopsicleAnnotationData
    
    convenience init(eventTitle: String, eventDetails: String?, eventStartDate: String, eventEndDate: String?, eventCategory: PopsicleCategory, eventHashtags: String, eventLocation: CLLocationCoordinate2D, eventAttendees: [String]?) {
        
        self.init(popsicleAnnotationData: PopsicleAnnotationData(eventTitle: eventTitle, eventDetails: eventDetails, eventStartDate: eventStartDate, eventEndDate: eventEndDate, eventCategory: eventCategory, eventHashtags: eventHashtags, eventLocation: eventLocation, eventAttendees: eventAttendees))
        
    }
    
    init(popsicleAnnotationData: PopsicleAnnotationData?) {
        
        super.init()
        
        if let newPopsicleAnnotationData = popsicleAnnotationData { self.popsicleAnnotationData = newPopsicleAnnotationData }
        
        self.coordinate = self.popsicleAnnotationData.eventLocation
        
    }
    
    public func getPopsicleAnnotationImage() -> UIImage {
        
        switch popsicleAnnotationData.eventCategory {
            
        case .Education: return .educationPopsicleIcon64
        case .Food: return .foodPopsicleIcon64
        case .Social: return .socialPopsicleIcon64
        case .Sports: return .sportsPopsicleIcon64
        case .Culture: return .culturePopsicleIcon64
        case .Poppin: return .poppinEventPopsicleIcon64
        case .Default: return .defaultPopsicleIcon256
            
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
