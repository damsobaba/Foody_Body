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
    
    
    var foodImage: String?
    var foodImage2: String?
    var foodImage3: String?
    var foodDescription: String?
    var foodDesciption2: String?
    var foodDescription3: String?
    var swipeUser: [String]?
    
    
    
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
        if let isMale = dict["isMale"] as? Bool {
            user.isMale = isMale
        }
        if let age = dict["age"] as? Int {
            user.age = age
        }
        
        if let foodImage = dict["foodImage"] as? String {
            user.foodImage = foodImage
        }
        
        if let foodImage2 = dict["foodImage2"] as? String {
            user.foodImage2 = foodImage2
        }
        if let foodImage3 = dict["foodImage3"] as? String {
            user.foodImage3 = foodImage3
        }
        
        if let foodDescription = dict["foodDescription"] as? String{
            user.foodDescription = foodDescription
        }
        if let foodDescription2 = dict["foodDescription2"] as? String{
            user.foodDesciption2 = foodDescription2
        }
        if let foodDescription3 = dict["foodDescription3"] as? String{
            user.foodDescription3 = foodDescription3
        }
        
        if let swipeUser = dict["swiped"] as? [String]{
            user.swipeUser = swipeUser
        }
        
        
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

   
