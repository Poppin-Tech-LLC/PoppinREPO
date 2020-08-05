//
//  UserModel.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/5/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import CoreLocation

struct UserModel {
    
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
    
    init(id: String? = nil, title: String? = nil, details: String? = nil, onlineURL: URL? = nil, startDate: Date? = nil, endDate: Date? = nil, location: CLLocationCoordinate2D? = nil, authorId: String? = nil, category: EventCategory? = nil, attendeesIds: [String] = [], isPublic: Bool = false, isPoppin: Bool = false, isEditable: Bool = true) {
        
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
        self.isPublic = isPublic
        self.isPoppin = isPoppin
        self.isEditable = isEditable
        
    }
    
}

