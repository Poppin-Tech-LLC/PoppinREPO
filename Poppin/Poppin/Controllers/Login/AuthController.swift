//
//  AuthController.swift
//  Poppin
//
//  Created by Manuel Alejandro Martin Callejo on 8/19/20.
//  Copyright © 2020 Poppin Tech LLC. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import Geofirestore
import CoreLocation
import SwiftDate

enum AuthError: String, Error {
    
    case currentUserNotFound = "Auth current user is nil."
    
}

final class AuthController: NSObject {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func isUsernameAvailable(_ username: String, _ completion: ((Bool?, Error?) -> ())? = nil) {
        
        let usersRef = Firestore.firestore().collection("users")
        
        usersRef.whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            
            completion?(snapshot?.count == 0, error)
            
        }
        
    }
    
    func createUser(_ email: String, _ password: String, _ completion: ((AuthDataResult?, Error?, String?, String?) -> ())? = nil) {
        
        Auth.auth().createUser(withEmail: email.lowercased(), password: password) { (result, error) in
            
            var errorTitle: String?
            var errorMessage: String?
            
            if error != nil {
                
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    
                case .emailAlreadyInUse:
                    
                    errorTitle = "Email already in use"
                    errorMessage = "The email you entered is already registered with another account. Please try again."
                    
                case .invalidEmail:
                    
                    errorTitle = "Invalid email"
                    errorMessage = "The email you entered is invalid. Please try again."
                    
                case .weakPassword:
                    
                    errorTitle = "Password is too weak"
                    errorMessage = "The password you entered is too weak. Please try again."
                    
                case .networkError:
                    
                    errorTitle = "Network is unstable"
                    errorMessage = "Please check your internet connection and try again."
                    
                default:
                    
                    errorTitle = "Something went wrong"
                    errorMessage = "Please try again."
                    
                }
                
            }
            
            completion?(result, error, errorTitle, errorMessage)
            
        }
        
    }
    
    func addUser(_ user: User, _ username: String, fullName: String, dateOfBirth: Date, university: University, _ completion: ((Error?) -> ())? = nil) {
        
        let usersRef = Firestore.firestore().collection("users")
        let userLocs = GeoFirestore(collectionRef: Firestore.firestore().collection("userLocs"))
        
        let followersRef = Firestore.firestore().collection("followers").document(user.uid)
        let followingRef = Firestore.firestore().collection("following").document(user.uid)
        
        followersRef.setData([:]) { (error) in
            
            if error != nil {
            
                completion?(error)
                
            } else {
                
                followingRef.setData(["following" : [user.uid]]) { (error) in
                    
                    if error != nil {
                    
                        followersRef.delete()
                        completion?(error)
                        
                    } else {
                        
                        usersRef.document(user.uid).setData([
                            "username": username,
                            "bio": "",
                            "fullName": fullName,
                            "latitude": university.latitude,
                            "longitude": university.longitude,
                            "radius": university.radius,
                            "isPublic": true,
                            "dateOfBirth": dateOfBirth.timeIntervalSince1970
                        ]) { (error) in
                            
                            if error != nil {
                                
                                followersRef.delete()
                                followingRef.delete()
                                completion?(error)
                                
                            } else {
                                
                                userLocs.setLocation(location: CLLocation(latitude: university.latitude, longitude: university.longitude), forDocumentWithID: user.uid) { (error) in
                                    
                                    if error != nil {
                                        
                                        followersRef.delete()
                                        followingRef.delete()
                                        usersRef.document(user.uid).delete()
                                        completion?(error)
                                        
                                    } else {
                                        
                                        completion?(nil)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func deleteUser(_ user: User, _ completion: ((Error?) -> ())? = nil) {
        
        let usersRef = Firestore.firestore().collection("users")
        let userLocs = GeoFirestore(collectionRef: Firestore.firestore().collection("userLocs"))
        
        let followersRef = Firestore.firestore().collection("followers").document(user.uid)
        let followingRef = Firestore.firestore().collection("following").document(user.uid)
        
        followersRef.delete() { error in
            
            if error != nil {
                
                completion?(error)
                
            } else {
                
                followingRef.delete() { error in
                    
                    if error != nil {
                        
                        completion?(error)
                        
                    } else {
                        
                        userLocs.removeLocation(forDocumentWithID: user.uid) { error in
                            
                            if error != nil {
                                
                                completion?(error)
                                
                            } else {
                                
                                usersRef.document(user.uid).delete() { error in
                                    
                                    if error != nil {
                                        
                                        completion?(error)
                                        
                                    } else {
                                     
                                        completion?(nil)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func signIn(_ email: String, _ password: String, _ completion: ((AuthDataResult?, Error?, String?, String?) -> ())? = nil) {
        
        Auth.auth().signIn(withEmail: email.lowercased(), password: password, completion: { (result, error) in
            
            var errorTitle: String?
            var errorMessage: String?
            
            if error != nil {
                
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    
                case .userNotFound:
                    
                    errorTitle = "Email not found"
                    errorMessage = "The email you entered does not belong to any registered account. Please try again."
                    
                case .invalidEmail:
                    
                    errorTitle = "Invalid email"
                    errorMessage = "The email you entered is invalid. Please try again."
                    
                case .wrongPassword:
                    
                    errorTitle = "Incorrect password for " + email
                    errorMessage = "The password you entered is incorrect. Please try again."
                    
                case .userDisabled:
                    
                    errorTitle = email + " is disabled."
                    errorMessage = "This account is disabled. Please try again."
                    
                case .networkError:
                    
                    errorTitle = "Network is unstable"
                    errorMessage = "Please check your internet connection and try again."
                    
                default:
                    
                    errorTitle = "Something went wrong"
                    errorMessage = "Please try again."
                    
                }
                
            }
            
            completion?(result, error, errorTitle, errorMessage)
            
        })
        
    }
    
    func signOut(_ completion: ((Error?) -> ())? = nil) {
        
        do {
            
            try Auth.auth().signOut()
            completion?(nil)
            
        } catch { completion?(error) }
            
    }
    
    func sendEmailVerification(_ completion: ((Error?) -> ())? = nil) {
        
        getCurrentUser { (user, error) in
            
            if error != nil {
                
                completion?(error)
                
            } else {
                
                user!.sendEmailVerification { (error) in
                    
                    completion?(error)
                    
                }
                
            }
            
        }
        
    }
    
    func sendPasswordReset(_ email: String, _ completion: ((Error?, String?, String?) -> ())? = nil) {
        
        Auth.auth().sendPasswordReset(withEmail: email.lowercased()) { (error) in
            
            var errorTitle: String?
            var errorMessage: String?
            
            if error != nil {
                
                let errorCode = AuthErrorCode(rawValue: error!._code)
                
                switch errorCode {
                    
                case .userNotFound:
                    
                    errorTitle = "Email not found"
                    errorMessage = "The email you entered does not belong to any registered account. Please try again."
                    
                case .invalidEmail:
                    
                    errorTitle = "Invalid email"
                    errorMessage = "The email you entered is invalid. Please try again."
                    
                case .networkError:
                    
                    errorTitle = "Network is unstable"
                    errorMessage = "Please check your internet connection and try again."
                    
                default:
                    
                    errorTitle = "Something went wrong"
                    errorMessage = "Please try again."
                    
                }
                
            }
            
            completion?(error, errorTitle, errorMessage)
            
        }
        
    }
    
    func getCurrentUser(_ completion: ((User?, Error?) -> ())? = nil) {
        
        if let currentUser = Auth.auth().currentUser {
            
            completion?(currentUser, nil)
            
        } else {
            
            completion?(nil, AuthError.currentUserNotFound)
            
        }
        
    }
    
    func getUniversities(_ completion: (([University]?, Error?) -> ())? = nil) {
        
        let universitiesRef = Firestore.firestore().collection("universities")
        
        universitiesRef.getDocuments { (snapshot, error) in
            
            if error != nil {
                
                completion?(nil, error)
                
            } else {
                
                if let snapshot = snapshot {
                    
                    var universities: [University] = []
                    
                    for document in snapshot.documents {
                        
                        let rawData = document.data()
                        
                        guard let name = rawData["name"] as? String else { continue }
                        guard let domain = rawData["domain"] as? String else { continue }
                        guard let radius = rawData["radius"] as? Double else { continue }
                        guard let latitude = rawData["latitude"] as? Double else { continue }
                        guard let longitude = rawData["longitude"] as? Double else { continue }
                        
                        let university = University(name: name, domain: domain, latitude: latitude, longitude: longitude, radius: radius)
                        
                        universities.append(university)
                        
                    }
                    
                    completion?(universities, nil)
                    
                } else {
                    
                    completion?(nil, nil)
                    
                }
                
            }
            
        }
        
    }
    
}
