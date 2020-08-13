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
    
    var inducedBy: String?
    var details: String?
    var dateInduced: String?
    
    init(inducedBy: String? = nil, details: String? = nil, dateInduced: String? = nil) {
        
        self.inducedBy = inducedBy
        self.details = details
        self.dateInduced = dateInduced
        
    }
    
}

