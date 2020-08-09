//
//  OrgModel.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/9/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import Foundation
import SwiftDate

enum OrgError: String, Error {
    
    case invalidParameter = "Parameter passed is invalid."
    case duplicatedId = "Trying to add a duplicated id."
    case idNotFound = "Unable to remove the id passed (not found)."
    case unableToRemoveId = "Unable to remove the id passed."
    
}

struct OrgModel: Identifiable {
    
    let id: ID
    private(set) var university: UniversityModel
    private(set) var fullName: String
    private(set) var username: String
    private(set) var bio: String?
    private(set) var picture: Data?
    private(set) var followingIds: [ID: Bool]
    private(set) var followersIds: [ID: Bool]
    //var events: [EventModel]
    //var activitiesIds: [String]
    //var reportsIds: [String]
    private(set) var adminsIds: [ID: Bool]
    
    init(id: ID, university: UniversityModel, fullName: String, username: String, bio: String? = nil, picture: Data? = nil, followingIds: [ID: Bool] = [:], followersIds: [ID: Bool] = [:], adminsIds: [ID: Bool] = [:]) throws {
        
        if id.rawValue.isEmpty { throw OrgError.invalidParameter } else { self.id = id } // ID Validation
        
        self.university = university // University Validation
        
        if fullName.isEmpty || fullName.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw OrgError.invalidParameter } else { self.fullName = fullName } // Full Name Validation
        
        if !NSPredicate(format:"SELF MATCHES %@", "\\w{3,15}").evaluate(with: username) || username.range(of: "poppin", options: .caseInsensitive) != nil || username.range(of: "admin", options: .caseInsensitive) != nil { throw OrgError.invalidParameter } else { self.username = username } // Username Validation
        
        self.bio = bio // Bio Validation
        
        self.picture = picture // Picture Validation
        
        if followingIds.isEmpty || !followingIds.keys.contains(id) { // Following Validation
            
            self.followingIds = followingIds
            self.followingIds[id] = false
            
        } else if let value = followingIds[id], value {
            
            throw OrgError.invalidParameter
            
        } else {
            
            self.followingIds = followingIds
            
        }
        
        if followersIds.isEmpty || !followersIds.keys.contains(id) { // Followers Validation
            
            self.followersIds = followersIds
            self.followersIds[id] = false
            
        } else if let value = followersIds[id], value {
            
            throw OrgError.invalidParameter
            
        } else {
            
            self.followersIds = followersIds
            
        }
        
        if adminsIds.isEmpty || !adminsIds.keys.contains(id) { // Admins Validation
            
            self.adminsIds = adminsIds
            self.adminsIds[id] = false
            
        } else if let value = adminsIds[id], value {
            
            throw OrgError.invalidParameter
            
        } else {
            
            self.adminsIds = adminsIds
            
        }
        
    }
    
    mutating func update(university: UniversityModel) {
        
        self.university = university // University Validation
        
    }
    
    mutating func update(fullName: String) throws {
        
        if fullName.isEmpty || fullName.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw OrgError.invalidParameter } else { self.fullName = fullName } // Full Name Validation
        
    }
    
    mutating func update(username: String) throws {
        
        if !NSPredicate(format:"SELF MATCHES %@", "\\w{3,15}").evaluate(with: username) || username.range(of: "poppin", options: .caseInsensitive) != nil || username.range(of: "admin", options: .caseInsensitive) != nil { throw OrgError.invalidParameter } else { self.username = username } // Username Validation
        
    }
    
    mutating func update(bio: String?) {
        
        self.bio = bio // Bio Validation
        
    }
    
    mutating func update(picture: Data?) {
        
        self.picture = picture // Picture Validation
        
    }

    mutating func add(followingId: ID) throws {
        
        if followingId.rawValue.isEmpty { throw OrgError.invalidParameter } // followingId Validation
        
        if followingIds.keys.contains(followingId) { throw OrgError.duplicatedId }

        followingIds[followingId] = true
        
    }
    
    mutating func add(followerId: ID) throws {
        
        if followerId.rawValue.isEmpty { throw OrgError.invalidParameter } // followerId Validation
        
        if followersIds.keys.contains(followerId) { throw OrgError.duplicatedId }

        followersIds[followerId] = true
        
    }
    
    mutating func add(adminId: ID) throws {
        
        if adminId.rawValue.isEmpty { throw OrgError.invalidParameter } // adminId Validation
        
        if adminsIds.keys.contains(adminId) { throw OrgError.duplicatedId }

        adminsIds[adminId] = true
        
    }
    
    mutating func remove(followingId: ID) throws {
        
        if followingId.rawValue.isEmpty || followingId == id { throw OrgError.invalidParameter } // followingId Validation
        
        if !followingIds.keys.contains(followingId) { throw OrgError.idNotFound }

        guard let success = followingIds.removeValue(forKey: followingId) else { throw OrgError.unableToRemoveId }
        
        if !success { throw OrgError.unableToRemoveId }
        
    }
    
    mutating func remove(followerId: ID) throws {
        
        if followerId.rawValue.isEmpty || followerId == id { throw OrgError.invalidParameter } // followerId Validation
        
        if !followersIds.keys.contains(followerId) { throw OrgError.idNotFound }

        guard let success = followersIds.removeValue(forKey: followerId) else { throw OrgError.unableToRemoveId }
        
        if !success { throw OrgError.unableToRemoveId }
        
    }
    
    mutating func remove(adminId: ID) throws {
        
        if adminId.rawValue.isEmpty || adminId == id { throw OrgError.invalidParameter } // adminId Validation
        
        if !adminsIds.keys.contains(adminId) { throw OrgError.idNotFound }

        guard let success = adminsIds.removeValue(forKey: adminId) else { throw OrgError.unableToRemoveId }
        
        if !success { throw OrgError.unableToRemoveId }
        
    }
    
}
