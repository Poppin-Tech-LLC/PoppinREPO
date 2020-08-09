//
//  UniversityModel.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/5/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import Foundation

enum UniversityError: String, Error {
    
    case invalidParameter = "Parameter passed is invalid."
    
}

struct UniversityModel: Identifiable {
    
    let id: ID
    private(set) var domain: String
    private(set) var radius: Double
    private(set) var latitude: Double
    private(set) var longitude: Double
    
    init(name: ID, domain: String, radius: Double, latitude: Double, longitude: Double) throws {
        
        if name.rawValue.isEmpty { throw UniversityError.invalidParameter } else { self.id = name } // Name (id) Validation
        
        if domain.isEmpty || domain.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw UniversityError.invalidParameter } else { self.domain = domain } // Domain Validation
        
        if radius <= 0.0 { throw UniversityError.invalidParameter } else { self.radius = radius } // Radius Validation
        
        self.latitude = latitude // Latitude Validation
        
        self.longitude = longitude // Longitude Validation
        
    }
    
    mutating func update(domain: String) throws {
        
        if domain.isEmpty || domain.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw UniversityError.invalidParameter } else { self.domain = domain } // Domain Validation
        
    }
    
    mutating func update(radius: Double) throws {
        
        if radius <= 0.0 { throw UniversityError.invalidParameter } else { self.radius = radius } // Radius Validation
        
    }
    
    mutating func update(latitude: Double) {
        
        self.latitude = latitude // Latitude Validation
        
    }
    
    mutating func update(longitude: Double) {
        
        self.longitude = longitude // Longitude Validation
        
    }
    
}

