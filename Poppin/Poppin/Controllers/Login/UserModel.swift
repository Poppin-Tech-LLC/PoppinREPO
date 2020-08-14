//
//  UserModel.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/5/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import Foundation
import SwiftDate

enum UserError: String, Error {
    
    case invalidParameter = "Parameter passed is invalid."
    case duplicatedId = "Trying to add a duplicated id."
    case idNotFound = "Unable to remove the id passed (not found)."
    case unableToRemoveId = "Unable to remove the id passed."
    
}

struct UserModel: Identifiable {
    
    let id: ID
    private(set) var university: UniversityModel
    private(set) var dateOfBirth: TimeInterval
    private(set) var fullName: String
    private(set) var email: String
    private(set) var username: String
    private(set) var bio: String?
    private(set) var picture: Data?
    private(set) var isPublic: Bool
    private(set) var followingIds: [ID: Bool]
    private(set) var followersIds: [ID: Bool]
    //var events: [EventModel]
    //var activitiesIds: [String]
    //var reportsIds: [String]
    private(set) var orgsIds: [ID: Bool]
    
    init(id: ID, university: UniversityModel, dateOfBirth: TimeInterval, fullName: String, email: String, username: String, bio: String? = nil, picture: Data? = nil, isPublic: Bool = true, followingIds: [ID: Bool] = [:], followersIds: [ID: Bool] = [:], orgsIds: [ID: Bool] = [:]) throws {
        
        if id.rawValue.isEmpty { throw UserError.invalidParameter } else { self.id = id } // ID Validation
        
        self.university = university // University Validation
        
        if Date(timeIntervalSince1970: dateOfBirth).year < 13 { throw UserError.invalidParameter } else { self.dateOfBirth = dateOfBirth } // Date of Birth Validation
        
        if fullName.isEmpty || fullName.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw UserError.invalidParameter } else { self.fullName = fullName } // Full Name Validation
        
        if !email.hasSuffix("@" + university.domain) { throw UserError.invalidParameter } else { self.email = email } // Email Validation
        
        if !NSPredicate(format:"SELF MATCHES %@", "\\w{3,15}").evaluate(with: username) || username.range(of: "poppin", options: .caseInsensitive) != nil || username.range(of: "admin", options: .caseInsensitive) != nil { throw UserError.invalidParameter } else { self.username = username } // Username Validation
        
        self.bio = bio // Bio Validation
        
        self.picture = picture // Picture Validation
        
        self.isPublic = isPublic // isPublic Validation
        
        if followingIds.isEmpty || !followingIds.keys.contains(id) { // Following Validation
            
            self.followingIds = followingIds
            self.followingIds[id] = false
            
        } else if let value = followingIds[id], value {
            
            throw UserError.invalidParameter
            
        } else {
            
            self.followingIds = followingIds
            
        }
        
        if followersIds.isEmpty || !followersIds.keys.contains(id) { // Followers Validation
            
            self.followersIds = followersIds
            self.followersIds[id] = false
            
        } else if let value = followersIds[id], value {
            
            throw UserError.invalidParameter
            
        } else {
            
            self.followersIds = followersIds
            
        }
        
        if orgsIds.isEmpty || !orgsIds.keys.contains(id) { // Orgs Validation
            
            self.orgsIds = orgsIds
            self.orgsIds[id] = false
            
        } else if let value = orgsIds[id], value {
            
            throw UserError.invalidParameter
            
        } else {
            
            self.orgsIds = orgsIds
            
        }
        
    }
    
    mutating func update(university: UniversityModel) {
        
        self.university = university // University Validation
        
    }
    
    mutating func update(dateOfBirth: TimeInterval) throws {
        
        if Date(timeIntervalSince1970: dateOfBirth).year < 13 { throw UserError.invalidParameter } else { self.dateOfBirth = dateOfBirth } // Date of Birth Validation
        
    }
    
    mutating func update(fullName: String) throws {
        
        if fullName.isEmpty || fullName.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw UserError.invalidParameter } else { self.fullName = fullName } // Full Name Validation
        
    }
    
    mutating func update(email: String) throws {
        
        if !email.hasSuffix("@" + university.domain) { throw UserError.invalidParameter } else { self.email = email } // Email Validation
        
    }
    
    mutating func update(username: String) throws {
        
        if !NSPredicate(format:"SELF MATCHES %@", "\\w{3,15}").evaluate(with: username) || username.range(of: "poppin", options: .caseInsensitive) != nil || username.range(of: "admin", options: .caseInsensitive) != nil { throw UserError.invalidParameter } else { self.username = username } // Username Validation
        
    }
    
    mutating func update(bio: String?) {
        
        self.bio = bio // Bio Validation
        
    }
    
    mutating func update(picture: Data?) {
        
        self.picture = picture // Picture Validation
        
    }
    
    mutating func update(isPublic: Bool) {
        
        self.isPublic = isPublic // isPublic Validation
        
    }

    mutating func add(followingId: ID) throws {
        
        if followingId.rawValue.isEmpty { throw UserError.invalidParameter } // followingId Validation
        
        if followingIds.keys.contains(followingId) { throw UserError.duplicatedId }

        followingIds[followingId] = true
        
    }
    
    mutating func add(followerId: ID) throws {
        
        if followerId.rawValue.isEmpty { throw UserError.invalidParameter } // followerId Validation
        
        if followersIds.keys.contains(followerId) { throw UserError.duplicatedId }

        followersIds[followerId] = true
        
    }
    
    mutating func add(orgId: ID) throws {
        
        if orgId.rawValue.isEmpty { throw UserError.invalidParameter } // orgId Validation
        
        if orgsIds.keys.contains(orgId) { throw UserError.duplicatedId }

        orgsIds[orgId] = true
        
    }
    
    mutating func remove(followingId: ID) throws {
        
        if followingId.rawValue.isEmpty || followingId == id { throw UserError.invalidParameter } // followingId Validation
        
        if !followingIds.keys.contains(followingId) { throw UserError.idNotFound }

        guard let success = followingIds.removeValue(forKey: followingId) else { throw UserError.unableToRemoveId }
        
        if !success { throw UserError.unableToRemoveId }
        
    }
    
    mutating func remove(followerId: ID) throws {
        
        if followerId.rawValue.isEmpty || followerId == id { throw UserError.invalidParameter } // followerId Validation
        
        if !followersIds.keys.contains(followerId) { throw UserError.idNotFound }

        guard let success = followersIds.removeValue(forKey: followerId) else { throw UserError.unableToRemoveId }
        
        if !success { throw UserError.unableToRemoveId }
        
    }
    
    mutating func remove(orgId: ID) throws {
        
        if orgId.rawValue.isEmpty || orgId == id { throw UserError.invalidParameter } // orgId Validation
        
        if !orgsIds.keys.contains(orgId) { throw UserError.idNotFound }

        guard let success = orgsIds.removeValue(forKey: orgId) else { throw UserError.unableToRemoveId }
        
        if !success { throw UserError.unableToRemoveId }
        
    }
    
}

