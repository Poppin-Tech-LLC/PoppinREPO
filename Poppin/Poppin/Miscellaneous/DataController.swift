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
    
    static func addUser(bio: String? = nil, username: String? = nil, fullName: String? = nil, uid: String? = nil){
        
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
        
        //managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if(bio == nil || username == nil || fullName == nil || uid == nil){
            do {

            
            let ref = Firestore.firestore().collection("users")
                ref.document(Auth.auth().currentUser?.uid ?? "").getDocument{ (document, error) in
                        if let document = document, document.exists {

                            let data = document.data()
                            let username2 = data!["username"] as! String
                            let fullName2 = data!["fullName"] as! String
                            let bio2 = data!["bio"] as! String
                            
                            self.removeWithID(uid: Auth.auth().currentUser?.uid ?? "")
                            
                            userData.setValue(Auth.auth().currentUser?.uid ?? "", forKey: "uid")
                            userData.setValue(username2, forKey: "username")
                            userData.setValue(fullName2, forKey: "fullName")
                            userData.setValue(bio2, forKey: "bio")
                            
                            
                            
                }
                do{
                    try managedContext.save()
                    NotificationCenter.default.post(name: .userSignedIn, object: nil)
                }catch let error as NSError {
                  print("Could not fetch. \(error), \(error.userInfo)")
                }
            }
            }
            
        }else{
            self.removeWithID(uid: uid!)
            
            userData.setValue(uid, forKey: "uid")
            userData.setValue(username, forKey: "username")
            userData.setValue(fullName, forKey: "fullName")
            userData.setValue(bio, forKey: "bio")
            
            do{
                try managedContext.save()
                NotificationCenter.default.post(name: .userSignedIn, object: nil)

            }catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    static func removeWithID(uid: String){
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
         let fetchRequest =
                        NSFetchRequest<NSManagedObject>(entityName: "User")
        
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
                        NSFetchRequest<NSManagedObject>(entityName: "User")
        
        let uid = Auth.auth().currentUser?.uid
        
        fetchRequest.predicate = NSPredicate(format: "uid != %@", uid!)
        do{
            let user = try managedContext.fetch(fetchRequest)
            for data in user{
                print(data.value(forKey: "username"))
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
                   return [NSManagedObject()]
               }
               
               let managedContext =
                 appDelegate.persistentContainer.viewContext
               
               //2
               let fetchRequest =
                 NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do {
          let user = try managedContext.fetch(fetchRequest)
            if(user.count > 0){
                return Array(user.dropFirst())
            }
           
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return [NSManagedObject()]
    }
    
    
}
