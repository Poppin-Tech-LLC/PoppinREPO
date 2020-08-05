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
    var username: String?
    var fullName: String?
    var email: String?
    var dateOfBirth: Date?
    var university: UniversityController?
    var bio: String?
    var picture: UIImage?
    var followingIds: [String: Bool]
    var followersIds: [String: Bool]
    var eventsIds: [String]
    var activitiesIds: [String]
    var isPublic: Bool
    
    init(id: String? = nil, username: String? = nil, fullName: String? = nil, email: String? = nil, dateOfBirth: Date? = nil, university: UniversityController? = nil, bio: String? = nil, picture: UIImage? = nil, followingIds: [String: Bool] = [:], followersIds: [String: Bool] = [:], eventsIds: [String] = [], activitiesIds: [String] = [], isPublic: Bool = false) {
        
        self.id = id
        self.username = username
        self.fullName = fullName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.university = university
        self.bio = bio
        self.picture = picture
        self.followingIds = followingIds
        self.followersIds = followersIds
        self.eventsIds = eventsIds
        self.activitiesIds = activitiesIds
        self.isPublic = isPublic
        
    }
    
}

