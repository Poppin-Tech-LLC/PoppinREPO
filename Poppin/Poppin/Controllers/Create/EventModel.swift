//
//  EventModel.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 7/27/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftDate

enum EventCategory: String, CaseIterable {
    
    case Culture = "Culture"
    case Social = "Social"
    case Food = "Food"
    case Sports = "Sports"
    case Education = "Education"
    
    func getPopsicleIcon64() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIcon64
        case .Social: return .socialPopsicleIcon64
        case .Food: return .foodPopsicleIcon64
        case .Sports: return .sportsPopsicleIcon64
        case .Education: return .educationPopsicleIcon64
            
        }
        
    }
    
    func getPopsicleIcon128() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIcon128
        case .Social: return .socialPopsicleIcon128
        case .Food: return .foodPopsicleIcon128
        case .Sports: return .sportsPopsicleIcon128
        case .Education: return .educationPopsicleIcon128
            
        }
        
    }
    
    func getPopsicleIcon256() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIcon256
        case .Social: return .socialPopsicleIcon256
        case .Food: return .foodPopsicleIcon256
        case .Sports: return .sportsPopsicleIcon256
        case .Education: return .educationPopsicleIcon256
            
        }
        
    }
    
    func getPopsicleIcon1024() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIcon1024
        case .Social: return .socialPopsicleIcon1024
        case .Food: return .foodPopsicleIcon1024
        case .Sports: return .sportsPopsicleIcon1024
        case .Education: return .educationPopsicleIcon1024
            
        }
        
    }
    
    func getPopsicleShadow64() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIconShadow64
        case .Social: return .socialPopsicleIconShadow64
        case .Food: return .foodPopsicleIconShadow64
        case .Sports: return .sportsPopsicleIconShadow64
        case .Education: return .educationPopsicleIconShadow64
            
        }
        
    }
    
    func getPopsicleShadow128() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIconShadow128
        case .Social: return .socialPopsicleIconShadow128
        case .Food: return .foodPopsicleIconShadow128
        case .Sports: return .sportsPopsicleIconShadow128
        case .Education: return .educationPopsicleIconShadow128
            
        }
        
    }
    
    func getPopsicleShadow256() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIconShadow256
        case .Social: return .socialPopsicleIconShadow256
        case .Food: return .foodPopsicleIconShadow256
        case .Sports: return .sportsPopsicleIconShadow256
        case .Education: return .educationPopsicleIconShadow256
            
        }
        
    }
    
    func getPopsicleShadow1024() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePopsicleIconShadow1024
        case .Social: return .socialPopsicleIconShadow1024
        case .Food: return .foodPopsicleIconShadow1024
        case .Sports: return .sportsPopsicleIconShadow1024
        case .Education: return .educationPopsicleIconShadow1024
            
        }
        
    }
    
    func getGradientBackground() -> UIImage {
        
        switch self {
            
        case .Culture: return .culturePURPLEBackground
        case .Social: return .socialREDBackground
        case .Food: return .foodORANGEBackground
        case .Sports: return .sportsGREENBackground
        case .Education: return .educationBLUEBackground
            
        }
        
    }
    
    func getGradientColors() -> [UIColor] {
        
        switch self {
        
        case .Culture: return [.cultureLIGHTPURPLE, .cultureDARKPURPLE]
        case .Social: return [.socialLIGHTRED, .socialDARKRED]
        case .Food: return [.foodLIGHTORANGE, .foodDARKORANGE]
        case .Sports: return [.sportsLIGHTGREEN, .sportsDARKGREEN]
        case .Education: return [.educationLIGHTBLUE, .educationDARKBLUE]
            
        }
        
    }
    
    func getDescription() -> String {
        
        switch self {
        
        case .Culture: return "You're doing it for the culture! Let everyone know that this is a cultural event that you wish to share."
        case .Social: return "The core of any event, grab a group of people and go have yourselves some fun!"
        case .Food: return "Food is the fastest way to someones heart! No one shall leave your event on an empty stomach."
        case .Sports: return "Sports? E-Sports? It's going to be competitive regardless, may the best competitor win!"
        case .Education: return "There's always time to learn new things! Everyone who leaves your event will learn something new from it."
            
        }
        
    }
    
}

struct EventModel {
    
    static let maxTitleLength: Int = 50
    static let maxDetailsLength: Int = 500
    static let minEventDuration: DateComponents = 30.minutes
    static let maxEventDuration: DateComponents = 8.hours
    
    var id: String?
    var title: String?
    var details: String?
    var onlineURL: URL?
    var startDate: Date?
    var endDate: Date?
    var location: CLLocationCoordinate2D?
    var authorId: String?
    var category: EventCategory?
    var attendeesIds: [String]
    var isPublic: Bool
    var isPoppin: Bool
    var isEditable: Bool
    
    init(id: String? = nil, title: String? = nil, details: String? = nil, onlineURL: URL? = nil, startDate: Date? = nil, endDate: Date? = nil, location: CLLocationCoordinate2D? = nil, authorId: String? = nil, category: EventCategory? = nil, attendeesIds: [String] = [], isPublic: Bool? = true, isPoppin: Bool = false, isEditable: Bool = true) {
        
        self.id = id
        self.title = title
        self.details = details
        self.onlineURL = onlineURL
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.authorId = authorId
        self.category = category
        self.attendeesIds = attendeesIds
        self.isPublic = isPublic ?? false
        self.isPoppin = isPoppin
        self.isEditable = isEditable
        
    }
    
}
