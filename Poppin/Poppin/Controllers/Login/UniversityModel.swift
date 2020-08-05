//
//  UniversityModel.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/5/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import CoreLocation

struct UniversityModel {
    
    var id: String?
    var name: String?
    var domain: String?
    var radius: CGFloat?
    var location: CLLocationCoordinate2D?
    
    init(id: String? = nil, name: String? = nil, domain: String? = nil, radius: CGFloat? = nil, location: CLLocationCoordinate2D? = nil) {
        
        self.id = id
        self.name = name
        self.domain = domain
        self.radius = radius
        self.location = location
        
    }
    
}
