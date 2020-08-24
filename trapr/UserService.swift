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
        
        get(id: email, source: .default) { (user, error) in
            completion?(user, error)
        }
//        firestore.collection("users").document(email).getDocument { (snapshot, error) in
//
//            var user: User?
//            if let data = snapshot?.data() {
//                user = User(dictionary: data)
//                user?.id = email
//            }
//            completion?(user, error)
//        }
    }
    
    func getUserStats(completion: ((UserStatistics?, Error?) -> Void)?) {
        super.get(orderByField: UserFields.email.rawValue) { (users, error) in
            let stats = UserStatistics(count: users.count)
            completion?(stats, error)
        }
    }
    
    func registerAuthenticatedUser(authenticatedUser: AuthenticatedUser, completion: ((User?, Error?) -> Void)?) {
        
        // check to see if this is an existing user
        self.get(email: authenticatedUser.email) { (user, error) in

            if let error = error {
                completion?(nil, error)
            }
            
            self.currentUser = user
            
            // first time this user has logged in (they'll be added as a Contributor only)
            if (self.currentUser == nil) {
                // Create a new User record from the authenticated user
                self.currentUser = User(email: authenticatedUser.email)
                self.currentUser!.displayName = authenticatedUser.displayName
            }
            self.currentUser!.lastAuthenticated = Date()
            
            // Update (or add, if new) user record to database
            self.update(user: self.currentUser!, completion: { (error) in
                if let error = error {
                    completion?(nil, error)
                }
                completion?(self.currentUser, error)
            })
            
        }

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
