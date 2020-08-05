//
//  UserController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/5/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import UIKit
import SwiftDate
import CoreLocation

enum UserError: String, Error {
    
    case attributeHasBeenSet = "Attribute has already been set and cannot be set again."
    case invalidParameter = "Parameter passed is invalid."
    case unableToRemoveParameter = "Unable to remove value with the id passed."
    case attributeHasNotBeenSet = "Attribute not been set yet (nil)."
    
}

final class UserController: NSObject {
    
    private var user: UserModel = UserModel()
    
    override init() {
        
        super.init()
        
    }
    
    init(userModel: UserModel) {
        
        super.init()
        
        merge(with: userModel)
        
    }
    
    init(userController: UserController) {
        
        super.init()
        
        merge(with: userController)
        
    }
    
    static func == (lhs: UserController, rhs: UserController) -> Bool {
        
        var lhsId: String? = nil
        var rhsId: String? = nil
        
        var errorLog: String = "User Error log: \n"
        
        do { try lhsId = lhs.getId() } catch let error as UserError { errorLog.append("lhs id: " + error.rawValue + "\n") } catch { errorLog.append("lhs id: " + error.localizedDescription + "\n") }
        do { try rhsId = rhs.getId() } catch let error as UserError { errorLog.append("rhs id: " + error.rawValue + "\n") } catch { errorLog.append("rhs id: " + error.localizedDescription + "\n") }
        
        print(errorLog)
        
        if lhsId == nil || rhsId == nil { return false }
        
        return lhsId == rhsId
        
    }
    
    override func isEqual(_ object: Any?) -> Bool {
    
        if let other = object as? UserController {
         
            var id: String? = nil
            var otherId: String? = nil
            
            var errorLog: String = "User Error log: \n"
            
            do { try id = self.getId() } catch let error as UserError { errorLog.append("self id: " + error.rawValue + "\n") } catch { errorLog.append("self id: " + error.localizedDescription + "\n") }
            do { try otherId = other.getId() } catch let error as UserError { errorLog.append("other id: " + error.rawValue + "\n") } catch { errorLog.append("other id: " + error.localizedDescription + "\n") }
            
            print(errorLog)
            
            if id == nil || otherId == nil { return false }
            
            return id == otherId
            
        } else {
            
            return false
            
        }
        
    }
    
    func merge(with userController: UserController) {
        
        var errorLog: String = "User error log: \n"
        
        do { try setId(id: try userController.getId()) } catch let error as UserError { errorLog.append("id: " + error.rawValue + "\n") } catch { errorLog.append("id: " + error.localizedDescription + "\n") }
        do { try setUsername(username: try userController.getUsername()) } catch let error as UserError { errorLog.append("username: " + error.rawValue + "\n") } catch { errorLog.append("username: " + error.localizedDescription + "\n") }
        do { try setFullName(fullName: try userController.getFullName()) } catch let error as UserError { errorLog.append("fullName: " + error.rawValue + "\n") } catch { errorLog.append("fullName: " + error.localizedDescription + "\n") }
        do { try setDateOfBirth(dateOfBirth: try userController.getDateOfBirth()) } catch let error as UserError { errorLog.append("dateOfBirth: " + error.rawValue + "\n") } catch { errorLog.append("dateOfBirth: " + error.localizedDescription + "\n") }
        do { try setUniversity(university: try userController.getUniversity()) } catch let error as UserError { errorLog.append("university: " + error.rawValue + "\n") } catch { errorLog.append("university: " + error.localizedDescription + "\n") }
        do { try setEmail(email: try userController.getEmail()) } catch let error as UserError { errorLog.append("email: " + error.rawValue + "\n") } catch { errorLog.append("email: " + error.localizedDescription + "\n") }
        do { try setBio(bio: try userController.getBio()) } catch let error as UserError { errorLog.append("bio: " + error.rawValue + "\n") } catch { errorLog.append("bio: " + error.localizedDescription + "\n") }
        do { try setPicture(picture: try userController.getPicture()) } catch let error as UserError { errorLog.append("picture: " + error.rawValue + "\n") } catch { errorLog.append("picture: " + error.localizedDescription + "\n") }
        do { try setFollowingIds(followingIds: userController.getFollowingIds()) } catch let error as UserError { errorLog.append("followingIds: " + error.rawValue + "\n") } catch { errorLog.append("followingIds: " + error.localizedDescription + "\n") }
        do { try setFollowersIds(followersIds: userController.getFollowersIds()) } catch let error as UserError { errorLog.append("followersIds: " + error.rawValue + "\n") } catch { errorLog.append("followersIds: " + error.localizedDescription + "\n") }
        do { try setEventsIds(eventsIds: userController.getEventsIds()) } catch let error as UserError { errorLog.append("eventsIds: " + error.rawValue + "\n") } catch { errorLog.append("eventsIds: " + error.localizedDescription + "\n") }
        do { try setActivitiesIds(activitiesIds: userController.getActivitiesIds()) } catch let error as UserError { errorLog.append("activitiesIds: " + error.rawValue + "\n") } catch { errorLog.append("activitiesIds: " + error.localizedDescription + "\n") }
        do { try setPublic(isPublic: userController.isPublic()) } catch let error as UserError { errorLog.append("isPublic: " + error.rawValue + "\n") } catch { errorLog.append("isPublic: " + error.localizedDescription + "\n") }
        
        if errorLog == "User error log: \n" { errorLog.append("No errors.") }
        
        print(errorLog)
        
    }
    
    func merge(with userModel: UserModel) {
        
        var errorLog: String = "User error log: \n"
        
        do { if let id = userModel.id { try setId(id: id) } } catch let error as UserError { errorLog.append("id: " + error.rawValue + "\n") } catch { errorLog.append("id: " + error.localizedDescription + "\n") }
        do { if let username = userModel.username { try setUsername(username: username) } } catch let error as UserError { errorLog.append("username: " + error.rawValue + "\n") } catch { errorLog.append("username: " + error.localizedDescription + "\n") }
        do { if let fullName = userModel.fullName { try setFullName(fullName: fullName) } } catch let error as UserError { errorLog.append("fullName: " + error.rawValue + "\n") } catch { errorLog.append("fullName: " + error.localizedDescription + "\n") }
        do { if let dateOfBirth = userModel.dateOfBirth { try setDateOfBirth(dateOfBirth: dateOfBirth) } } catch let error as UserError { errorLog.append("dateOfBirth: " + error.rawValue + "\n") } catch { errorLog.append("dateOfBirth: " + error.localizedDescription + "\n") }
        do { if let university = userModel.university { try setUniversity(university: university) } } catch let error as UserError { errorLog.append("university: " + error.rawValue + "\n") } catch { errorLog.append("university: " + error.localizedDescription + "\n") }
        do { if let email = userModel.email { try setEmail(email: email) } } catch let error as UserError { errorLog.append("email: " + error.rawValue + "\n") } catch { errorLog.append("email: " + error.localizedDescription + "\n") }
        do { if let bio = userModel.bio { try setBio(bio: bio) } } catch let error as UserError { errorLog.append("bio: " + error.rawValue + "\n") } catch { errorLog.append("bio: " + error.localizedDescription + "\n") }
        do { if let picture = userModel.picture { try setPicture(picture: picture) } } catch let error as UserError { errorLog.append("picture: " + error.rawValue + "\n") } catch { errorLog.append("picture: " + error.localizedDescription + "\n") }
        do { try setFollowingIds(followingIds: userModel.followingIds) } catch let error as UserError { errorLog.append("followingIds: " + error.rawValue + "\n") } catch { errorLog.append("followingIds: " + error.localizedDescription + "\n") }
        do { try setFollowersIds(followersIds: userModel.followersIds) } catch let error as UserError { errorLog.append("followersIds: " + error.rawValue + "\n") } catch { errorLog.append("followersIds: " + error.localizedDescription + "\n") }
        do { try setEventsIds(eventsIds: userModel.eventsIds) } catch let error as UserError { errorLog.append("eventsIds: " + error.rawValue + "\n") } catch { errorLog.append("eventsIds: " + error.localizedDescription + "\n") }
        do { try setActivitiesIds(activitiesIds: userModel.activitiesIds) } catch let error as UserError { errorLog.append("activitiesIds: " + error.rawValue + "\n") } catch { errorLog.append("activitiesIds: " + error.localizedDescription + "\n") }
        do { try setPublic(isPublic: userModel.isPublic) } catch let error as UserError { errorLog.append("isPublic: " + error.rawValue + "\n") } catch { errorLog.append("isPublic: " + error.localizedDescription + "\n") }
        
        if errorLog == "User error log: \n" { errorLog.append("No errors.") }
        
        print(errorLog)
        
    }
    
    func setId(id: String) throws {
        
        if id.isEmpty { throw UserError.invalidParameter }
            
        if user.id != nil { throw UserError.attributeHasBeenSet }
        
        user.id = id
        user.followingIds[id] = false
        user.followersIds[id] = false
        
    }
    
    func setUsername(username: String) throws {
        
        let usernameFormat = "\\w{3,15}"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernameFormat)
        
        //if user.username != nil { throw UserError.attributeHasBeenSet }
        
        if !usernamePredicate.evaluate(with: username) || username.range(of: "poppin", options: .caseInsensitive) != nil || username.range(of: "admin", options: .caseInsensitive) != nil { throw UserError.invalidParameter }
        
        user.username = username
        
    }
    
    func setFullName(fullName: String) throws {
        
        if fullName.isEmpty || fullName.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw UserError.invalidParameter }
        
        user.fullName = fullName
        
    }
    
    func setEmail(email: String) throws {
        
        //if user.email != nil { throw UserError.attributeHasBeenSet }
        
        guard let domain = try? user.university?.getDomain() else { throw UserError.attributeHasNotBeenSet }
        
        if !email.hasSuffix("@" + domain) { throw UserError.invalidParameter }
        
        user.email = email
        
    }
    
    func setDateOfBirth(dateOfBirth: Date) throws {
        
        //if user.dateOfBirth != nil { throw UserError.attributeHasBeenSet }
        
        guard let age = (Region.current.nowInThisRegion().date - dateOfBirth).year else { throw UserError.invalidParameter }
        
        if age < 13 { throw UserError.invalidParameter }
        
        user.dateOfBirth = dateOfBirth
        
    }
    
    func setUniversity(university: UniversityController) throws {
        
        //if user.university != nil { throw UserError.attributeHasBeenSet }
        
        //guard let _ = try? university.getId() else {}
        
        //guard let _ = try? university.getName() else {}
        
        guard let _ = try? university.getDomain() else { throw UserError.invalidParameter }
        
        guard let _ = try? university.getRadius() else { throw UserError.invalidParameter }
        
        guard let _ = try? university.getLocation() else { throw UserError.invalidParameter }
        
        user.university = university
        
    }
    
    func setBio(bio: String) throws {
        
        if bio.isEmpty || bio.count > 200 || bio.trimmingCharacters(in: .whitespacesAndNewlines) == "" { throw UserError.invalidParameter }
        
        user.bio = bio
        
    }
    
    func setPicture(picture: UIImage) throws {
        
        user.picture = picture
        
    }
    
    func addFollowing(followingId: String) throws {
        
        guard let id = user.id else { throw UserError.attributeHasNotBeenSet }
        
        if !user.followingIds.keys.contains(id) { user.followingIds[id] = false }
        
        if followingId.isEmpty || id == followingId { throw UserError.invalidParameter }
        
        user.followingIds[followingId] = true
        
    }
    
    func removeFollowing(followingId: String) throws {
        
        guard let id = user.id else { throw UserError.attributeHasNotBeenSet }
        
        if followingId.isEmpty || id == followingId { throw UserError.invalidParameter }
        
        if user.followingIds.count <= 1 { throw UserError.unableToRemoveParameter }
        
        if !(user.followingIds.removeValue(forKey: followingId) ?? false) { throw UserError.unableToRemoveParameter }
        
    }
    
    func setFollowingIds(followingIds: [String: Bool]) throws {
        
        if let id = user.id { user.followingIds.removeValue(forKey: id) }
        
        for followingId in followingIds { try addFollowing(followingId: followingId.key) }
        
    }
    
    func addFollower(followerId: String) throws {
        
        guard let id = user.id else { throw UserError.attributeHasNotBeenSet }
        
        if !user.followersIds.keys.contains(id) { user.followersIds[id] = false }
        
        if followerId.isEmpty || id == followerId { throw UserError.invalidParameter }
        
        user.followersIds[followerId] = true
        
    }
    
    func removeFollower(followerId: String) throws {
        
        guard let id = user.id else { throw UserError.attributeHasNotBeenSet }
        
        if followerId.isEmpty || id == followerId { throw UserError.invalidParameter }
        
        if user.followersIds.count <= 1 { throw UserError.unableToRemoveParameter }
        
        if !(user.followersIds.removeValue(forKey: followerId) ?? false) { throw UserError.unableToRemoveParameter }
        
    }
    
    func setFollowersIds(followersIds: [String: Bool]) throws {
        
        if let id = user.id { user.followersIds.removeValue(forKey: id) }
        
        for followerId in followersIds { try addFollower(followerId: followerId.key) }
        
    }
    
    func addEvent(eventId: String) throws {
        
        if eventId.isEmpty { throw UserError.invalidParameter }
        
        user.eventsIds.append(eventId)
        
    }
    
    func removeEvent(eventId: String) throws {
        
        if eventId.isEmpty { throw UserError.invalidParameter }
        
        if user.eventsIds.isEmpty { throw UserError.unableToRemoveParameter }
        
        if !user.eventsIds.remove(object: eventId) { throw UserError.unableToRemoveParameter }
        
    }
    
    func setEventsIds(eventsIds: [String]) throws {
        
        for eventId in eventsIds { try addEvent(eventId: eventId) }
        
    }
    
    func addActivity(activityId: String) throws {
        
        if activityId.isEmpty { throw UserError.invalidParameter }
        
        user.activitiesIds.append(activityId)
        
    }
    
    func removeActivity(activityId: String) throws {
        
        if activityId.isEmpty { throw UserError.invalidParameter }
        
        if user.activitiesIds.isEmpty { throw UserError.unableToRemoveParameter }
        
        if !user.activitiesIds.remove(object: activityId) { throw UserError.unableToRemoveParameter }
        
    }
    
    func setActivitiesIds(activitiesIds: [String]) throws {
        
        for activityId in activitiesIds { try addActivity(activityId: activityId) }
        
    }
    
    func setPublic(isPublic: Bool) throws {
        
        user.isPublic = isPublic
        
    }
    
    func getId() throws -> String {
        
        guard let id = user.id else { throw UserError.attributeHasNotBeenSet }
        
        return id
        
    }
    
    func getUsername() throws -> String {
        
        guard let username = user.username else { throw UserError.attributeHasNotBeenSet }
        
        return username
        
    }
    
    func getFullName() throws -> String {
        
        guard let fullName = user.fullName else { throw UserError.attributeHasNotBeenSet }
        
        return fullName
        
    }
    
    func getEmail() throws -> String {
        
        guard let email = user.email else { throw UserError.attributeHasNotBeenSet }
        
        return email
        
    }
    
    func getDateOfBirth() throws -> Date {
        
        guard let dateOfBirth = user.dateOfBirth else { throw UserError.attributeHasNotBeenSet }
        
        return dateOfBirth
        
    }
    
    func getUniversity() throws -> UniversityController {
        
        guard let university = user.university else { throw UserError.attributeHasNotBeenSet }
        
        return university
        
    }
    
    func getBio() throws -> String {
        
        guard let bio = user.bio else { throw UserError.attributeHasNotBeenSet }
        
        return bio
        
    }
    
    func getPicture() throws -> UIImage {
        
        guard let picture = user.picture else { throw UserError.attributeHasNotBeenSet }
        
        return picture
        
    }
    
    func getFollowingIds() -> [String : Bool] {
        
        return user.followingIds
        
    }
    
    func getFollowersIds() -> [String : Bool] {
        
        return user.followersIds
        
    }
    
    func getEventsIds() -> [String] {
        
        return user.eventsIds
        
    }
    
    func getActivitiesIds() -> [String] {
        
        return user.activitiesIds
        
    }
    
    func isPublic() -> Bool {
        
        return user.isPublic
        
    }
    
    func rawValue() -> UserModel {
        
        return user
        
    }
    
}
