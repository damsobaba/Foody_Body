//
//  AuthServiceTest.swift
//  My_Foody_BodyTests
//
//  Created by Adam Mabrouki on 04/03/2021.
//

import XCTest
@testable import My_Foody_Body

import FirebaseStorage
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

        func signUp(userName: String, email: String, password: String, image: Data?, callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func logOut(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func isUserConnected(callback: @escaping (Bool) -> Void) {
            callback(isSuccess)
        }

        func saveUserProfile(dict: Dictionary<String, Any>, onSuccess: @escaping (Bool) -> Void, onError: @escaping (String) -> Void) {
            onSuccess(isSuccess)
        }

        func savePhotoProfile(image: Data, uid: String, onError: @escaping (String) -> Void) {
            onError("they have been a error trying to save you profile picture")
        }

        func saveFoodPhoto(image: Data, uid: String, dictValue: String, onError: @escaping (String) -> Void) {
            onError("they have been a error trying to save you food picture")
        }

        func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onError: @escaping (String) -> Void) {
            onError("a error as occure trying to save you picture")
        }

        func savePhotoMessage(image: UIImage?, id: String, callback: @escaping (Result<Any, Error>) -> Void) {
            callback(.success(isSuccess))
        }
    }


    // MARK: - Tests

    func testCurrentUID_WhenTheUserIsConnected_ThenShouldReturnAValue() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectedUID: String = "uUs63keFW1NiuHtW85bbFMHn12v2"
        XCTAssertTrue(sut.currentUID! == expectedUID)
    }



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
        sut.signUp(userName: "Username", email: "Email", password: "Password", image: Data()) { isSuccess in
            XCTAssertTrue(isSuccess == true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSignUpMethod_WhenTheUserEnterIncorrectData_ThenShouldNotCreateTheUser() {
        let sut: AuthService = AuthService(auth: AuthStub(false))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.signUp(userName: "Username", email: "Email", password: "", image: Data()) { isSuccess in
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
    
    func testSaveUserProfileMethode_WhenUserPressSaveProfile_thenTheUserInfoShouldBeSaved() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.saveUserProfile(dict: Dictionary<String, Any>()) { (Bool) in
            XCTAssertTrue(Bool == true)
            expectation.fulfill()
        } onError: { (String) in
            
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSavePhotoProfilMethode_WhenUserPressSave_thenProfilePictureShouldbeSaved() {
        let sut: AuthService = AuthService(auth: AuthStub(true))

        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.savePhotoProfile(image: Data(), uid: "uUs63keFW1NiuHtW85bbFMHn12v2") { isError in
            XCTAssertTrue(isError ==  "they have been a error trying to save you profile picture")
                   expectation.fulfill()
               }
               wait(for: [expectation], timeout: 0.01)
    }
    
    
    func testSavePhotoMessageMethode_WhenPhotoMessageSend_thePhotoShouldBeSaved() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.savePhotoMessage(image: UIImage(), id: "") { (message) in
            guard case .success = message else {
                XCTFail("Get User Data Method Success Tests Fails")
                return
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testSaveFoodPhotoMethode_WhenUserPressSave_thanFoodImageShouldBeSaved() {
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.saveFoodPhoto(image: Data(), uid: "uUs63keFW1NiuHtW85bbFMHn12v2", dictValue: "foodImage") { (error) in
            XCTAssertTrue( error == "they have been a error trying to save you food picture")
                   expectation.fulfill()
        }
      
        wait(for: [expectation], timeout: 0.01)
    }

    func testSavePhotoMethode_WhenSignUp_thanProfilePictureShouldBesaved() {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        let storageProfile = Reference().storageSpecificProfile(uid:"uUs63keFW1NiuHtW85bbFMHn12v2" )
        let sut: AuthService = AuthService(auth: AuthStub(true))
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.savePhoto(username: "Pierre", uid: "uUs63keFW1NiuHtW85bbFMHn12v2", data: Data(), metadata: metadata, storageProfileRef:storageProfile, dict: Dictionary<String, Any>()) { (error) in
            XCTAssertTrue( error ==  "a error as occure trying to save you picture")
                   expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

}
