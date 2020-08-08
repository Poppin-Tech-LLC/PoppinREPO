//
//  ActivityModel.swift
//  Poppin
//
//  Created by Josiah Aklilu on 8/6/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import CoreLocation

struct ActivityModel {
    
    var id: String?
    var inducedById: String?
    var details: String?
    
    init(id: String? = nil, inducedBy: String? = nil, details: String? = nil) {
        
        self.id = id
        self.inducedById = inducedBy
        self.details = details
        
    }
    
}

