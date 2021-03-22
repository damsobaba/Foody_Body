//
//  UserTest.swift
//  My_Foody_BodyTests
//
//  Created by Adam Mabrouki on 22/03/2021.
//

import XCTest

class UserTest: XCTestCase {
   
    func test_initialize_user() {
        let user = User(uid: "123", username: "pierre", email: "pierre@gmail.com", profileImageUrl: "", status: "HEY")
        XCTAssertEqual(user.uid, "123")
        XCTAssertEqual(user.username, "pierre")
        XCTAssertEqual(user.email, "pierre@gmail.com")
        XCTAssertEqual(user.profileImage, UIImage())
        XCTAssertEqual(user.status, "HEY")
       
    }

    func test_sut_can_transform_user() {
        let user = User.transformUser(dict: [ "uid": "123","username": "pierre", "email": "pierre@gmail.com", "profileImageUrl": "123","status":"hey","age":20,"isMale":true,"foodDescription":"la","foodDescription2":"ba","foodDescription3":"la", "foodImage":"1","foodImage2":"2","foodImage3":"3"])
        XCTAssertNotNil(user)
        XCTAssertEqual(user?.uid, "123")
        XCTAssertEqual(user?.username, "pierre")
        XCTAssertEqual(user?.email, "pierre@gmail.com")
        XCTAssertEqual(user?.profileImage, UIImage())
        XCTAssertEqual(user?.status, "hey")
        XCTAssertEqual(user?.age, 20)
        XCTAssertEqual(user?.isMale,true)
        XCTAssertEqual(user?.foodDescription,"la")
        XCTAssertEqual(user?.foodDesciption2,"ba")
        XCTAssertEqual(user?.foodDescription3,"la")
        XCTAssertEqual(user?.foodImage,"1")
        XCTAssertEqual(user?.foodImage2,"2")
        XCTAssertEqual(user?.foodImage3,"3")
    }
    
    func test_sut_canNot_transform_user() {
        let user = User.transformUser(dict: [ "uid": "123","username": ""])
        XCTAssertNil(user)
        
    }
    
    
    
    func test_sut_canUpdateData() {
        let user =  User.updateData(User.transformUser(dict:["username":"pierre", "email":"pierre@gmail.com", "profileImageUrl": "kdkdkfjfjfj", "uid": "uUs63keFW1NiuHtW85bbFMHn12v2", "status":"salut, je suis nouveau" ])!)
        XCTAssertNotNil(user)
      
    }
  
}
