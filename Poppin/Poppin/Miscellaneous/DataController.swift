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
        
        if(bio == nil || username == nil || fullName == nil || uid == nil){
            do {

            
            let ref = Firestore.firestore().collection("users")
                ref.document(Auth.auth().currentUser?.uid ?? "").getDocument{ (document, error) in
                        if let document = document, document.exists {

                            let data = document.data()
                            let username2 = data!["username"] as! String
                            let fullName2 = data!["fullName"] as! String
                            let bio2 = data!["bio"] as! String
                            
                            userData.setValue(Auth.auth().currentUser?.uid ?? "", forKey: "uid")
                            userData.setValue(username2, forKey: "username")
                            userData.setValue(fullName2, forKey: "fullName")
                            userData.setValue(bio2, forKey: "bio")
                            
                            
                            
                }
                do{
                    try managedContext.save()

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
            
            do{
                try managedContext.save()

            }catch let error as NSError {
              print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    
    
    
}
