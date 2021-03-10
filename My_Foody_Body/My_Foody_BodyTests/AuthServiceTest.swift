//
//  AuthServiceTest.swift
//  My_Foody_BodyTests
//
//  Created by Adam Mabrouki on 04/03/2021.
//

import XCTest
@testable import My_Foody_Body
class AuthServiceTest: XCTestCase {

    private class AuthStub: AuthType {
        
        private let isSuccess: Bool

        var currentUserId: String { return isSuccess ? "uUs63keFW1NiuHtW85bbFMHn12v2" : "" }

        init(_ isSuccess: Bool) {
            self.isSuccess = isSuccess
        }

        func signIn(email: String, password: String, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func signUp(userName: String, email: String, password: String,image: UIImage?, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func logOut(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func isUserConnected(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }
    }

    // MARK: - Tests

    func testCurrentUID_WhenTheUserIsConnected_ThenShouldReturnAValue() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectedUID: String = "uUs63keFW1NiuHtW85bbFMHn12v2"
        XCTAssertTrue(sut.currentUID! == expectedUID)
    }

//    func testCurrentUID_WhenTheUserIsDisconnected_ThenShouldReturnANilValue() {
//        let sut: AuthService = AuthService(auth: AuthStub(false))
//        let expectedUID: String? = nil
//        XCTAssertTrue(sut.currentUID == expectedUID)
//    }

    func testSignInMethod_WhenTheUserEnterCorrectData_ThenShouldConnectTheUser() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signIn(email: "CorrectMail", password: "CorrectPassword") { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignInMethod_WhenTheUserEnterIncorrectData_ThenShouldNotConnectTheUser() {
        let sut: AuthService = AuthService(auth: AuthStub(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signIn(email: "IncorrectMail", password: "IncorrectPassword") { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignUpMethod_WhenTheUserEnterCorrectData_ThenShouldCreateTheUser() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signUp(userName: "Username", email: "Email", password: "Password", image: UIImage()) { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignUpMethod_WhenTheUserEnterIncorrectData_ThenShouldNotCreateTheUser() {
        let sut: AuthService = AuthService(auth: AuthStub(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signUp(userName: "Username", email: "Email", password: "", image: UIImage()) { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignOutMethod_WhenTheUserWantsToBeDisconnected_ThenTheUserShouldBeDisconnected() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.logOut { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignOutMethod_WhenTheUserWantsToBeDisconnected_ThenTheUserShouldNotBeDisconnected() {
        let sut: AuthService = AuthService(auth: AuthStub(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.logOut { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testIsUserConnectedMethod_WhenTheUserIsConnected_ThenTheListenerShouldNotifyAConnectedUser() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.isUserConnected { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testIsUserConnectedMethod_WhenTheUserIsDisonnected_ThenTheListenerShouldNotifyADisconnectedUser() {
        let sut: AuthService = AuthService(auth: AuthStub(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.isUserConnected { isSuccess in
            XCTAssertTrue(isSuccess == false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
