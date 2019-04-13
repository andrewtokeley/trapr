//
//  UserService.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService: FirestoreEntityService<User>, UserServiceInterface {
    
    var currentUser: User?
    
    func get(email: String, completion: ((User?, Error?) -> Void)?) {
        firestore.collection("users").document(email).getDocument { (snapshot, error) in
            
            var user: User?
            if let data = snapshot?.data() {
                user = User(dictionary: data)
                user?.id = email
            }
            completion?(user, error)
        }
    }
    
    func getUserStats(completion: ((UserStatistics?, Error?) -> Void)?) {
        super.get(orderByField: UserFields.email.rawValue) { (users, error) in
            let stats = UserStatistics(count: users.count)
            completion?(stats, error)
        }
    }
    
    func registerAuthenticatedUser(authenticatedUser: AuthenticatedUser, completion: ((User?, Error?) -> Void)?) {
        
        // Create a new User record from the authenticated user
        let user = User(email: authenticatedUser.email)
        user.lastAuthenticated = Date()
        user.displayName = authenticatedUser.displayName
        user.roles = [UserRole.contributor.rawValue]
        
        // This will add a new user if the user wasn't previously registered
        self.update(user: user, completion: { (error) in
            print("self.update completed")
            if let error = error {
                completion?(nil, error)
            } else {
                self.get(email: user.id!, completion: { (user, error) in
                    self.currentUser = user
                    completion?(user, error)
                })
            }
        })
    }
    
    func updateLastOpenedApp(user: User, lastOpenedApp: Date, completion: ((Error?) -> Void)?) {
        if let id = user.id {
            firestore.collection("users").document(id).updateData(
                [UserFields.lastOpenedApp.rawValue: lastOpenedApp],
                completion: { (error) in
                    // for now we don't care if it fails or not :-)
                    completion?(error)
            })
        }
    }
    
    func delete(user: User, completion: ((Error?) -> Void)?) {
        super.delete(entity: user) { (error) in
            completion?(error)
        }
    }
    
    func deleteAllUsers(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities { (error) in
            completion?(error)
        }
    }
    
    func update(user: User, completion: ((Error?) -> Void)?) {
        
        if let id = user.id {
            firestore.collection("users").document(id).setData(user.dictionary, merge: true)
            { (error) in
                // this won't be raised if the user is offline
                if let error = error {
                    completion?(error)
                }
            }
            // assume all is good
            completion?(nil)
        } else {
            completion?(FirestoreEntityServiceError.updateFailed)
        }
    }
}
