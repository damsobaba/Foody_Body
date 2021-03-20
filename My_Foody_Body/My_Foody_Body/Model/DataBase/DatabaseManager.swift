//
//  DatabaseManager.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 04/03/2021.
//

import Foundation
import Foundation

final class DatabaseManager {

    // MARK: - Properties

    private let database: DatabaseType

    // MARK: - Initialization

    init(database: DatabaseType = FirebaseDatabase()) {
        self.database = database
    }

    // MARK: - Read Queries

    func observeUsers(onSucess: @escaping(UserCompletion)) {
        database.observeUsers(onSuccess: onSucess)
    }
    
     
    
    func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
        database.getUserInforSingleEvent(uid: uid, onSuccess: onSuccess)
    }

    func observeNewMatch(onSuccess: @escaping(UserCompletion)) {
        database.observeNewMatch(onSuccess: onSuccess)
}

    func findMatchfor(user: String,onSuccess: @escaping(Bool)->Void) {
        database.findMatchfor(user: user, onSuccess: onSuccess)
    }
      
}



