//
//  DataController.swift
//  Poppin
//
//  Created by Abdulrahman Ayad on 7/8/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseAuth

class DataController{
    
    
    
    static func eraseAll(forEntity: String){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: forEntity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
        } catch {
            print ("There was an error")
        }
        
    }
    
    static func save(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        do{
            try managedContext.save()

        }catch let error as NSError {
          print("Could not save, error: \(error)")
        }
    }
    
    static func addUser(bio: String? = nil, username: String? = nil, fullName: String? = nil, uid: String? = nil, radius: Double? = 0.0, latitude: Double? = 0.0, longitude: Double? = 0.0, notificationName: Notification.Name){
        
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        let entity =
        NSEntityDescription.entity(forEntityName: "User",
                           in: managedContext)!
        
        let userData = NSManagedObject(entity: entity, insertInto: managedContext)
                
        if(bio == nil || username == nil || fullName == nil || uid == nil){
            do {

            
            let ref = Firestore.firestore().collection("users")
                ref.document(Auth.auth().currentUser?.uid ?? "").getDocument{ (document, error) in
                        if let document = document, document.exists {

                            let data = document.data()
                            let username2 = data!["username"] as! String
                            let fullName2 = data!["fullName"] as! String
                            let bio2 = data!["bio"] as! String
                            let radius2 = data!["radius"] as! Double
                            let latitude2 = data!["latitude"] as! Double
                            let longitude2 = data!["longitude"] as! Double

                            userData.setValue(Auth.auth().currentUser?.uid ?? "", forKey: "uid")
                            userData.setValue(username2, forKey: "username")
                            userData.setValue(fullName2, forKey: "fullName")
                            userData.setValue(bio2, forKey: "bio")
                            userData.setValue(radius2, forKey: "radius")
                            userData.setValue(latitude2, forKey: "latitude")
                            userData.setValue(longitude2, forKey: "longitude")
                            
                            
                            
                            
                }
                do{
                    try managedContext.save()
                    NotificationCenter.default.post(name: notificationName, object: nil)
                }catch let error as NSError {
                  print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
            }
            
        }else{
            
            userData.setValue(uid, forKey: "uid")
            userData.setValue(username, forKey: "username")
            userData.setValue(fullName, forKey: "fullName")
            userData.setValue(bio, forKey: "bio")
            userData.setValue(radius, forKey: "radius")
            userData.setValue(latitude, forKey: "latitude")
            userData.setValue(longitude, forKey: "longitude")
            
            do{
                try managedContext.save()
                NotificationCenter.default.post(name: .userSignedIn, object: nil)

            }catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    static func addAccount(bio: String, username: String, fullName: String, uid: String){
             
             guard let appDelegate =
               UIApplication.shared.delegate as? AppDelegate else {
                 return
             }
             
             let managedContext =
               appDelegate.persistentContainer.viewContext
             
             let entity =
             NSEntityDescription.entity(forEntityName: "OtherAccounts",
                                in: managedContext)!
             
             let userData = NSManagedObject(entity: entity, insertInto: managedContext)
           
           DataController.removeWithID(uid: uid, entity: "OtherAccounts")
           
           userData.setValue(uid, forKey: "uid")
           userData.setValue(username, forKey: "username")
           userData.setValue(fullName, forKey: "fullName")
           userData.setValue(bio, forKey: "bio")
           
           do{
               try managedContext.save()

           }catch let error as NSError {
             print("Could not fetch. \(error), \(error.userInfo)")
           }
           
       }
    
    static func getOtherAccounts() -> [NSManagedObject]{
        //1
               guard let appDelegate =
                 UIApplication.shared.delegate as? AppDelegate else {
                   return []
               }
               
               let managedContext =
                 appDelegate.persistentContainer.viewContext
               
               //2
               let fetchRequest =
                 NSFetchRequest<NSManagedObject>(entityName: "OtherAccounts")
        
        do {
          let user = try managedContext.fetch(fetchRequest)
            if(user.count > 0){
                return Array(user)
            }
           
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    static func addRecentSearch(bio: String, username: String, fullName: String, uid: String){
          
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          let entity =
          NSEntityDescription.entity(forEntityName: "RecentSearches",
                             in: managedContext)!
          
          let userData = NSManagedObject(entity: entity, insertInto: managedContext)
        
        DataController.removeWithID(uid: uid, entity: "RecentSearches")
        
        userData.setValue(uid, forKey: "uid")
        userData.setValue(username, forKey: "username")
        userData.setValue(fullName, forKey: "fullName")
        userData.setValue(bio, forKey: "bio")
        
        do{
            try managedContext.save()

        }catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    static func removeWithID(uid: String, entity: String){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
         let fetchRequest =
                        NSFetchRequest<NSManagedObject>(entityName: entity)
        
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        do{
            let user = try managedContext.fetch(fetchRequest)
            for data in user{
                managedContext.delete(data)
            }
        }catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func getUser() -> NSManagedObject{
        //1
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return NSManagedObject()
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
            let user = try managedContext.fetch(fetchRequest)
            if(user.count > 0){
                return user[0]
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return NSManagedObject()
    }
    
    static func clearRecentSearches (){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
         let fetchRequest =
                        NSFetchRequest<NSManagedObject>(entityName: "RecentSearches")
        do{
            let user = try managedContext.fetch(fetchRequest)
            for data in user{
                managedContext.delete(data)
            }
            try managedContext.save()
            NotificationCenter.default.post(name: .clearedRecents, object: nil)
        }catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    static func getOtherUsers() -> [NSManagedObject]{
        //1
               guard let appDelegate =
                 UIApplication.shared.delegate as? AppDelegate else {
                   return []
               }
               
               let managedContext =
                 appDelegate.persistentContainer.viewContext
               
               //2
               let fetchRequest =
                 NSFetchRequest<NSManagedObject>(entityName: "RecentSearches")
        
        do {
          let user = try managedContext.fetch(fetchRequest)
            if(user.count > 0){
                print("MORE THAN ONE")
                return Array(user)
            }
           
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
}
