//
//  CoreDataController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/9/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

enum DataEntity: String {
    
    case User = "User"
    case University = "University"
    case RecentSearches = "RecentSearches"
    case OtherAccounts = "OtherAccounts"
    
}

final class CoreDataController: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) throws {
        
        let context = backgroundContext ?? viewContext
        
        guard context.hasChanges else { return }
        
        do { try context.save() } catch { throw error }
        
    }
    
    func deleteAll(of entity: DataEntity) throws {

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do { try viewContext.executeAndMergeChanges(using: deleteRequest) } catch { throw error }
        
    }
    
    /*func addUser(userController: UserController, notification: Notification.Name) throws {
        
        var userPlaceholder: UserModel
        
        do { userPlaceholder.id = try userController.getId() } catch { throw error }
        do { userPlaceholder = try userController.getId() } catch { throw error }
        do { userPlaceholder.id = try userController.getId() } catch { throw error }
        do { userPlaceholder.id = try userController.getId() } catch { throw error }
        
        do { try deleteAll(of: .User) } catch { throw error }
        
        let user = User(context: viewContext)
        
        user.id = id
        
        do { user.username = try userController.getUsername() } catch let error as UserError { print("username: " + error.rawValue + "\n") } catch { print("username: " + error.localizedDescription + "\n") }
        
        do { user.fullName = try userController.getFullName() } catch let error as UserError { print("fullName: " + error.rawValue + "\n") } catch { print("fullName: " + error.localizedDescription + "\n") }
        
        do { user.bio = try userController.getBio() } catch let error as UserError { print("bio: " + error.rawValue + "\n") } catch { print("bio: " + error.localizedDescription + "\n") }
        
        do { user.picture = try userController.getPicture().pngData() } catch let error as UserError { print("picture: " + error.rawValue + "\n") } catch { print("picture: " + error.localizedDescription + "\n") }
        
        do { user.universityName = try userController.getUniversity().getName() } catch let error as UserError { print("university: " + error.rawValue + "\n") } catch let error as UniversityError { print("name: " + error.rawValue + "\n") } catch { print("university: " + error.localizedDescription + "\n") }
        
        do { try saveContext() } catch { throw error }
        
        /*if (bio == nil || username == nil || fullName == nil || uid == nil) {
            
            guard let currentUser = Auth.auth().currentUser else { throw DataControllerError.currentUserNotFound }
            
            do {
            
                let ref = Firestore.firestore().collection("users")
                
                ref.document(currentUser.uid).getDocument{ (document, error) in
                    
                    if let error = error {
                        
                        print(error)
                        return
                        
                    }
                    
                    if let document = document, document.exists, let data = document.data() {
                        
                        userData.setValue(currentUser.uid, forKey: "uid")
                        userData.setValue(data["username"], forKey: "username")
                        userData.setValue(data["fullName"], forKey: "fullName")
                        userData.setValue(data["bio"], forKey: "bio")
                        userData.setValue(data["radius"], forKey: "radius")
                        userData.setValue(data["latitude"], forKey: "latitude")
                        userData.setValue(data["longitude"], forKey: "longitude")
                        
                    } else {
                        
                        print("Data Controller Error (addUser): ", DataControllerError.unableToRetrieveCloudDocument)
                        return
                        
                    }
                    
                    do { try DataController.saveContext() } catch { print(error) }
                    
                }
                
            }
            
        } else {
            
            user.uid = uid
            user.username = username
            user.fullName = fullName
            user.bio = bio
            user.radius = radius
            user.latitude = latitude
            user.longitude = longitude
            user.setValue(uid, forKey: "uid")
            user.setValue(username, forKey: "username")
            user.setValue(fullName, forKey: "fullName")
            user.setValue(bio, forKey: "bio")
            user.setValue(radius, forKey: "radius")
            user.setValue(latitude, forKey: "latitude")
            user.setValue(longitude, forKey: "longitude")
            
            do { try DataController.saveContext() } catch { print(error) }
            
        }*/
        
    }
    
    static func addAccount(bio: String, username: String, fullName: String, uid: String) throws {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw DataControllerError.appDelegateNotFound }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let otherAccountsEntity = NSEntityDescription.entity(forEntityName: DataEntity.OtherAccounts.rawValue, in: managedContext) else { throw DataControllerError.unableToRetrieveEntity }
        
        let userData = NSManagedObject(entity: otherAccountsEntity, insertInto: managedContext)
        
        do { try DataController.removeWithID(uid: uid, entity: DataEntity.OtherAccounts) } catch { throw error }
        
        userData.setValue(uid, forKey: "uid")
        userData.setValue(username, forKey: "username")
        userData.setValue(fullName, forKey: "fullName")
        userData.setValue(bio, forKey: "bio")
        
        do { try DataController.saveContext() } catch { throw error }
        
    }
    
    static func getOtherAccounts() throws -> [NSManagedObject] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw DataControllerError.appDelegateNotFound }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataEntity.OtherAccounts.rawValue)
        
        do {
            
            let user = try managedContext.fetch(fetchRequest)
            
            if user.count > 0 {
                
                return Array(user)
                
            } else {
                
                return []
                
            }
            
        } catch { throw error }
        
    }
    
    static func addRecentSearch(bio: String, username: String, fullName: String, uid: String) throws {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw DataControllerError.appDelegateNotFound }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let recentSearchesEntity = NSEntityDescription.entity(forEntityName: DataEntity.RecentSearches.rawValue, in: managedContext) else { throw DataControllerError.unableToRetrieveEntity }
        
        let userData = NSManagedObject(entity: recentSearchesEntity, insertInto: managedContext)
        
        do { try DataController.removeWithID(uid: uid, entity: DataEntity.RecentSearches) } catch { throw error }
        
        userData.setValue(uid, forKey: "uid")
        userData.setValue(username, forKey: "username")
        userData.setValue(fullName, forKey: "fullName")
        userData.setValue(bio, forKey: "bio")
        
        do { try DataController.saveContext() } catch { throw error }
        
    }
    
    static func removeWithID(uid: String, entity: DataEntity) throws {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw DataControllerError.appDelegateNotFound }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity.rawValue)
        
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        
        do {
            
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user{
                
                managedContext.delete(data)
                
            }
            
        } catch { throw error }
        
    }
    
    static func getUser() throws -> NSManagedObject {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw DataControllerError.appDelegateNotFound }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataEntity.User.rawValue)
        
        do {
            
            let user = try managedContext.fetch(fetchRequest)
            
            if(user.count > 0){
                
                return user[0]
                
            } else {
                
                return NSManagedObject()
                
            }
            
        } catch { throw error }
        
    }
    
    static func clearRecentSearches () throws {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw DataControllerError.appDelegateNotFound }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataEntity.RecentSearches.rawValue)
        
        do {
            
            let user = try managedContext.fetch(fetchRequest)
            
            for data in user {
                
                managedContext.delete(data)
                
            }
            
            try managedContext.save()
            
            NotificationCenter.default.post(name: .clearedRecents, object: nil)
            
        } catch { throw error }
        
    }
    
    static func getOtherUsers() throws -> [NSManagedObject] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { throw DataControllerError.appDelegateNotFound }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: DataEntity.RecentSearches.rawValue)
        
        do {
            
            let user = try managedContext.fetch(fetchRequest)
            
            if user.count > 0 {
                
                print("MORE THAN ONE")
                return Array(user)
                
            } else {
                
                return []
                
            }
            
        } catch { throw error }
        
    }*/
    
}

extension NSManagedObjectContext {
    
    /// Executes the given `NSBatchDeleteRequest` and directly merges the changes to bring the given managed object context up to date.
    ///
    /// - Parameter batchDeleteRequest: The `NSBatchDeleteRequest` to execute.
    /// - Throws: An error if anything went wrong executing the batch deletion.
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObjectID] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}

