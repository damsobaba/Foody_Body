
//  DatabaseManager.swift
//  My_Foody_BodyTests
//
//  Created by Adam Mabrouki on 04/03/2021.
//


import XCTest
@testable import My_Foody_Body

final class DadabaseManagerTests: XCTestCase {

    // MARK: - Helpers

    private class DatabaseStub: DatabaseType {
     
        // observe data from all users
        func observeUsers(onSuccess: @escaping (UserCompletion)) {
            guard let getUser = User.transformUser(dict: ["username":"pierre", "email":"pierre@gmail.com", "profileImageUrl": "blabla", "uid": "uUs63keFW1NiuHtW85bbFMHn12v2", "status":"salut, je suis nouveau" ]) else { return }

            onSuccess(getUser)

        }


          // observe all the data from the data of specify user
        func getUserInforSingleEvent(uid: String, onSuccess: @escaping (UserCompletion)) {
            guard let getUser = User.transformUser(dict:  ["username":"pierre", "email":"pierre@gmail.com", "profileImageUrl": "blabla", "uid": "uUs63keFW1NiuHtW85bbFMHn12v2", "status":"salut, je suis nouveau" ]) else { return }
            onSuccess(getUser)
        }

        
       // check if they is a match between two user by checking if the nod contain the swipe user
        func observeNewMatch(onSuccess: @escaping (UserCompletion)) {
          getUserInforSingleEvent(uid: "uUs63keFW1NiuHtW85bbFMHn12v2", onSuccess: onSuccess)
        }

        
        func findMatchfor(user: String, onSuccess: @escaping (Bool) -> Void) {
            onSuccess(true)
        }
        
    }


    // MARK: - Tests

 

    func testGetUserDataMethod_WhenTheDictInfoArecorrect_ThenShouldReturnAUser() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub())
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.observeUsers { (success) in
//            XCTAssertTrue(success.uid == "uUs63keFW1NiuHtW85bbFMHn12v2")
            XCTAssertEqual(success.username , "pierre" )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        }
    
    func testGetSpecifyUser_() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub())
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getUserInforSingleEvent(uid: "uUs63keFW1NiuHtW85bbFMHn12v2", onSuccess: { (success) in
            
            XCTAssertTrue(success.username == "pierre")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
        }
    
    func testNewMatchMethode_whenTheNewMatchIdIsPassed_ThanShouldReturnTheAssociateNewMatchUserName() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub())
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.observeNewMatch { (success) in
            XCTAssertTrue(success.username == "pierre")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        
    }
    
    func testFindMatchMethode_WhenUserSwipe_dataBaseaddNewMatchId() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub())
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.findMatchfor(user:"uUs63keFW1NiuHtW85bbFMHn12v2") { (success) in
            XCTAssertTrue(success == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    
    }
    
}
