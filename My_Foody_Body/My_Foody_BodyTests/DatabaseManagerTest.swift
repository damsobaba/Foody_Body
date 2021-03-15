
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
            guard let getUser = User.transformUser(dict: ["username":"pierre"]) else { return }

            onSuccess(getUser)

        }


          // observe all the data from the data of specify user
        func getUserInforSingleEvent(uid: String, onSuccess: @escaping (UserCompletion)) {
            guard let getUser = User.transformUser(dict:  ["uid":"uUs63keFW1NiuHtW85bbFMHn12v2"]) else { return }
            onSuccess(getUser)
        }

        
       // check if they is a match between two user by checking if the nod contain the swipe user
        func observeNewMatch(onSuccess: @escaping (UserCompletion)) {
          getUserInforSingleEvent(uid: "Pierre", onSuccess: onSuccess)
        }

            // not working yet
        func observeNewSwipe(onSuccess: @escaping (UserCompletion)) {

        }



    }

    enum TestError: Error {
        case invalidUID
    }

    // MARK: - Tests

 

    func testGetUserDataMethod_WhenTheUIDIscorrect_ThenShouldReturnAnError() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub())
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.observeUsers { (success) in
//            XCTAssertTrue(success.uid == "uUs63keFW1NiuHtW85bbFMHn12v2")
            XCTAssertEqual(success.username , "pierre" )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        }
    
    func testGetSpecifyUser() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub())
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getUserInforSingleEvent(uid: "uUs63keFW1NiuHtW85bbFMHn12v2", onSuccess: { (success) in
            
            XCTAssertTrue(success.username == "Pierre")
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
        }
    
    func testNewMatchMethode() {
        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub())
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.observeNewMatch { (User) in
            XCTAssertTrue(User.username == "Pierre")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        
        
    }
}
