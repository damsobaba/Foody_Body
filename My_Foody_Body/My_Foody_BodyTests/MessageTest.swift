//
//  MessageTest.swift
//  My_Foody_BodyTests
//
//  Created by Adam Mabrouki on 22/03/2021.
//

import XCTest

class MessageTest: XCTestCase {
    func test_initialize_message() {
        let message = Message(id: "1", from: "pierre", to: "tom", date: 20, text: "hey", imageUrl: "123", height: 20 , width: 30)
        
        XCTAssertEqual(message.id, "1")
        XCTAssertEqual(message.from,"pierre")
        XCTAssertEqual(message.to,"tom")
        XCTAssertEqual(message.date,20)
        XCTAssertEqual(message.text,"hey")
        XCTAssertEqual(message.imageUrl,"123")
        XCTAssertEqual(message.height,20)
        XCTAssertEqual(message.width,30)
        
    }
    func test_sut_can_transform_message() {
        let message = Message.transformMessage(dict: ["from": "pierre","to":"tom","date": 20.00], keyId: "")
        XCTAssertNotNil(message)
        XCTAssertEqual(message?.from,"pierre")
        XCTAssertEqual(message?.to,"tom")
        XCTAssertEqual(message?.date,20.00)
    }
    
    

}
