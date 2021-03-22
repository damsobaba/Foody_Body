//
//  MessageApiTest.swift
//  My_Foody_BodyTests
//
//  Created by Adam Mabrouki on 22/03/2021.
//

import XCTest

final class MessageApiTest: XCTestCase {

    var values = ["from":"pierre"]
    

    
    private class DatabaseStub: MessageApiType {
        func sendMessage(from: String, to: String, value: Dictionary<String, Any>) {
        }
        
        func receiveMessage(from: String, to: String, onSuccess: @escaping (Message) -> Void) {
            guard let message = Message.transformMessage(dict:  ["from": "pierre","to":"tom","date": 20.00], keyId: "uUs63keFW1NiuHtW85bbFMHn12v2") else { return  }
            onSuccess(message)
        }
 }
    
    func testReceiveMessage_WhenTheDictInfoAreCorrect_ThenShouldReturnMessage() {
        let sut: MessageManager = MessageManager(database: DatabaseStub() )
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.receiveMessage(from: "pierre", to: "tom") { (success) in
            XCTAssertTrue(success.from == "pierre" )
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
        }
    
    func testSendMessageMethode_WhenMessageSend_ThanShouldReturnMessage() {
        let sut: MessageManager = MessageManager(database: DatabaseStub() )
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        XCTAssertNotNil(sut.sendMessage(from: "pierre", to: "louise", value: values))
        expectation.fulfill()

    wait(for: [expectation], timeout: 0.1)
    }
    
}
