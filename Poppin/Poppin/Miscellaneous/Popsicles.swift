//
//  NewPopsicleAnnotation.swift - Abstraction of a popsicle annotation.
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 4/28/20.
//  Copyright © 2020 whatspoppinREPO. All rights reserved.
//

import UIKit
import MapKit
import SwiftDate

enum PopsicleCategory: String {
    
    case Education = "Education"
    case Food = "Food"
    case Social = "Social"
    case Sports = "Sports"
    case Culture = "Culture"
    case Poppin = "Poppin"
    case Default = "Default"
    
    func getPopsicleCategoryIcon() -> UIImage {
        
        switch self {
            
        case .Education: return .educationPopsicleIcon256
        case .Food: return .foodPopsicleIcon256
        case .Social: return .socialPopsicleIcon256
        case .Sports: return .sportsPopsicleIcon256
        case .Culture: return .culturePopsicleIcon256
        case .Poppin: return .poppinEventPopsicleIcon256
        case .Default: return .defaultPopsicleIcon256
            
        }
        
    }
    
    func getPopsicleCategoryGradientColors() -> [UIColor] {
        
        switch self {
            
        case .Education: return [.educationLIGHTBLUE, .educationDARKBLUE]
        case .Food: return [.foodLIGHTORANGE, .foodDARKORANGE]
        case .Social: return [.socialLIGHTRED, .socialDARKRED]
        case .Sports: return [.sportsLIGHTGREEN, .sportsDARKGREEN]
        case .Culture: return [.cultureLIGHTPURPLE, .cultureDARKPURPLE]
        case .Poppin: return [.poppinLIGHTGOLD, .poppinDARKGOLD]
        case .Default: return [.defaultGRAY, .defaultGRAY]
            
        }
        
    }
    
    func getPopsicleCategoryShadow() -> UIImage {
        
        switch self {
            
        case .Education: return .educationPopsicleIconShadow256
        case .Food: return .foodPopsicleIconShadow256
        case .Social: return .socialPopsicleIconShadow256
        case .Sports: return .sportsPopsicleIconShadow256
        case .Culture: return .culturePopsicleIconShadow256
        case .Poppin: return .poppinPopsicleIconShadow256
        case .Default: return .defaultPopsicleIconShadow256
            
        }
        
    }
    
    func getPopsicleCategoryGradient() -> UIImage {
        
        switch self {
            
        case .Education: return .educationBLUEBackground
        case .Food: return .foodORANGEBackground
        case .Social: return .socialREDBackground
        case .Sports: return .sportsGREENBackground
        case .Culture: return .culturePURPLEBackground
        case .Poppin: return .appBackground
        case .Default: return .appBackground
            
        }
        
    }
    
}

struct PopsicleAnnotationData {
    
    var eventTitle: String
    var eventDetails: String?
    var eventStartDate: Date
    var eventEndDate: Date
    var eventCategory: PopsicleCategory
    var eventHashtags: String?
    var eventLocation: CLLocationCoordinate2D
    var eventAttendees: [String]
    
    init() {
        
        eventTitle = ""
        eventDetails = ""
        eventStartDate = Region.current.nowInThisRegion().date.dateRoundedAt(at: .toCeil5Mins)
        eventEndDate = Region.current.nowInThisRegion().date.dateRoundedAt(at: .toCeil5Mins) + 15.minutes
        eventCategory = .Default
        eventHashtags = ""
        eventLocation = CLLocationCoordinate2D(latitude: 39.6766, longitude: -104.9619) // DU Campus
        eventAttendees = []
        
    }
    
    init(eventTitle: String, eventDetails: String?, eventStartDate: Date, eventEndDate: Date, eventCategory: PopsicleCategory, eventHashtags: String?, eventLocation: CLLocationCoordinate2D, eventAttendees: [String]) {
        
        self.eventTitle = eventTitle
        self.eventDetails = eventDetails
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
        self.eventCategory = eventCategory
        self.eventHashtags = eventHashtags
        self.eventLocation = eventLocation
        self.eventAttendees = eventAttendees
        
    }
    
}

class PopsicleAnnotation: MKPointAnnotation {
    
    public static let defaultPopsicleAnnotationData: PopsicleAnnotationData = PopsicleAnnotationData()
    
    lazy private(set) var popsicleAnnotationData: PopsicleAnnotationData = PopsicleAnnotation.defaultPopsicleAnnotationData
    
    convenience init(eventTitle: String, eventDetails: String?, eventStartDate: Date, eventEndDate: Date, eventCategory: PopsicleCategory, eventHashtags: String?, eventLocation: CLLocationCoordinate2D, eventAttendees: [String]) {
        
        self.init(popsicleAnnotationData: PopsicleAnnotationData(eventTitle: eventTitle, eventDetails: eventDetails, eventStartDate: eventStartDate, eventEndDate: eventEndDate, eventCategory: eventCategory, eventHashtags: eventHashtags, eventLocation: eventLocation, eventAttendees: eventAttendees))
        
    }
    
    init(popsicleAnnotationData: PopsicleAnnotationData?) {
        
        super.init()
        
        if let popsicleAnnotationData = popsicleAnnotationData {
            
            self.popsicleAnnotationData = popsicleAnnotationData
            
        } else {
            
            self.popsicleAnnotationData = PopsicleAnnotation.defaultPopsicleAnnotationData
            
        }
        
        self.coordinate = self.popsicleAnnotationData.eventLocation
        
    }
    
    public func getPopsicleAnnotationImage() -> UIImage {
        
        switch popsicleAnnotationData.eventCategory {
            
        case .Education: return .educationPopsicleIcon256
        case .Food: return .foodPopsicleIcon256
        case .Social: return .socialPopsicleIcon256
        case .Sports: return .sportsPopsicleIcon256
        case .Culture: return .culturePopsicleIcon256
        case .Poppin: return .poppinEventPopsicleIcon256
        case .Default: return .defaultPopsicleIcon256
            
        }
        
    }
    
    public func getPopsicleColor() -> UIColor {
        
        switch popsicleAnnotationData.eventCategory {
            
        case .Education: return .educationDARKBLUE
        case .Food: return .foodDARKORANGE
        case .Social: return .socialDARKRED
        case .Sports: return .sportsDARKGREEN
        case .Culture: return .cultureDARKPURPLE
        case .Poppin: return .poppinDARKGOLD
        case .Default: return .defaultGRAY
            
        }
        
    }
    
    public func getPopsicleShadowImage() -> UIImage {
        
        switch popsicleAnnotationData.eventCategory {
            
        case .Education: return .educationPopsicleIconShadow256
        case .Food: return .foodPopsicleIconShadow256
        case .Social: return .socialPopsicleIconShadow256
        case .Sports: return .sportsPopsicleIconShadow256
        case .Culture: return .culturePopsicleIconShadow256
        case .Poppin: return .poppinPopsicleIconShadow256
        case .Default: return .defaultPopsicleIconShadow256
            
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
