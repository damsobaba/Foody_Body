//
//  MessageManager.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 22/03/2021.
//

import Foundation
import Firebase
final class MessageManager {

    // MARK: - Properties

    private let database: MessageApiType

    // MARK: - Initialization

    init(database: MessageApiType = MessageApi()) {
        self.database = database
    }
    
    func sendMessage(from: String, to: String, value: Dictionary<String, Any>) {
        database.sendMessage(from: from, to: to, value: value)
    }
    
    func receiveMessage(from: String, to: String, onSuccess: @escaping(Message) -> Void) {
        database.receiveMessage(from: from, to: to, onSuccess: onSuccess)
    }
    
}
