//
//  AuthService.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 03/03/2021.
//

import Foundation
import UIKit
final class AuthService {

    // MARK: - Properties

    private let auth: AuthType
    var currentUID: String? { return auth.currentUserId }

    // MARK: - Initializer

    init(auth: AuthType = AuthManager()) {
        self.auth = auth
    }

    // MARK: - Auth Methods

    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void) {
        auth.signIn(email: email, password: password, callback: callback)
    }

    func signUp(userName: String, email: String, password: String,image:Data, callback: @escaping (Bool) -> Void) {
        auth.signUp(userName: userName, email: email, password: password,image: image,callback: callback)
    }

    func logOut(callback: @escaping (Bool) -> Void) {
//        auth.logOut(callback: callback)
         auth.logOut(callback: callback)
               (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
    }
//
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        auth.isUserConnected(callback: callback)
    }
    
    func saveUserProfile(dict: Dictionary<String, Any>,  onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        auth.saveUserProfile(dict: dict, onSuccess: onSuccess, onError: onError)
    }
    
}
