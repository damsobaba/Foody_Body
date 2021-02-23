//
//  User.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//



import Foundation
import UIKit

class User {
    var uid: String
    var username: String
    var email: String
    var profileImageUrl: String
    var profileImage = UIImage()
    var status: String
    var isMale: Bool?
    var age: Int?
    
    init(uid: String, username: String, email: String, profileImageUrl: String, status: String) {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.status = status
    }
    
    static func transformUser(dict: [String: Any]) -> User? {
        guard let email = dict["email"] as? String,
            let username = dict["username"] as? String,
            let profileImageUrl = dict["profileImageUrl"] as? String,
            let status = dict["status"] as? String,
            let uid = dict["uid"] as? String else {
                return nil
        }
        
        let user = User(uid: uid, username: username, email: email, profileImageUrl: profileImageUrl, status: status)
        
        return user
    }
    
    func updateData(key: String, value: String) {
        switch key {
        case "username": self.username = value
        case "email": self.email = value
        case "profileImageUrl": self.profileImageUrl = value
        case "status": self.status = value
        default: break
        }
    }
}


extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}

   
