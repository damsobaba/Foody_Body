//
//  FireBaseDatabase.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 04/03/2021.
//

import Foundation
import Firebase

typealias UserCompletion = (User) -> Void

protocol DatabaseType {
    func observeUsers(onSuccess: @escaping (UserCompletion))
    func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion))
    func getUserInfor(uid: String, onSuccess: @escaping(UserCompletion))
    func observeNewMatch(onSuccess: @escaping(UserCompletion))
    func observeNewSwipe(onSuccess: @escaping(UserCompletion))
}

final class FirebaseDatabase: DatabaseType {
    
    
    
    
    // MARK: - Read Queries
    
    
    
    func observeUsers(onSuccess: @escaping(UserCompletion)) {
        Ref().databaseUsers.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func getUserInfor(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func observeNewMatch(onSuccess: @escaping(UserCompletion)) {    Ref().databaseRoot.child("newMatch").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
        guard let dict = snapshot.value as? [String: Bool] else { return }
        dict.forEach({ (key, value) in
            self.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
                onSuccess(user)
            })
        })
      }
    }
    
    func observeNewSwipe(onSuccess: @escaping(UserCompletion)) {    Ref().databaseRoot.child("newSwipe").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
        guard let dict = snapshot.value as? [String: Bool] else { return }
        print("dd \(dict)")
        dict.forEach({ (key, value) in
            self.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
                onSuccess(user)
                
            })
        })
        

      }
    }
    
    
}


