
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



        private let userResult: UserCompletion

        init(_ userData: @escaping UserCompletion) {
            self.userResult = userData
        }

//        init(_ error: Error) {
//            self.userResult = .failure(error)
//        }

        func observeUsers(onSuccess: @escaping (UserCompletion)) {
        onSuccess(userResult)

        }



        func getUserInforSingleEvent(uid: String, onSuccess: @escaping (UserCompletion)) {
//            let user = UserCompletion(getUserInfor(uid: "uUs63keFW1NiuHtW85bbFMHn12v2",onSuccess: userResult))
//            onSuccess(user)
            getUserInforSingleEvent(uid: "uUs63keFW1NiuHtW85bbFMHn12v2", onSuccess: userResult)
        }

        func getUserInfor(uid: String, onSuccess: @escaping (UserCompletion)) {
            
        }

        func observeNewMatch(onSuccess: @escaping (UserCompletion)) {

        }


        func observeNewSwipe(onSuccess: @escaping (UserCompletion)) {

        }



    }

    enum TestError: Error {
        case invalidUID
    }

    // MARK: - Tests

//    func testGetUserDataMethod_WhenTheUIDIsCorrect_ThenShouldReturnUserData() {
//
//        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub(
//        }
//
//        }
//        }    ["uid" "NyeVduglGkQAgldAgG5durdJAer2", "username": "A Username"]))
//        let uid: String = "NyeVduglGkQAgldAgG5durdJAer2"
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        sut.observeUsers(onSucess: ) { result in
//            guard case .success(let userData) = result else {
//                XCTFail("Get User Data Method Success Tests Fails")
//                return
//            }
//            XCTAssertTrue(userData as! [String: String] == ["uid": "NyeVduglGkQAgldAgG5durdJAer2", "username": "A Username"])
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.01)
//    }
//
//    func testGetUserDataMethod_WhenTheUIDIsIncorrect_ThenShouldReturnAnError() {
//        let sut: DatabaseManager = DatabaseManager(database: DatabaseStub(TestError.invalidUID))
//        let uid: String = "invalidUid"
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        sut.getUserData(with: uid) { result in
//            guard case .failure(let error) = result else {
//                XCTFail("Get User Data Method Success Tests Fails")
//                return
//            }
//            XCTAssertNotNil(error)
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.01)
//    }
}
