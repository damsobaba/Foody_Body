//
//  AuthService.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 03/03/2021.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import AVFoundation

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
         auth.logOut(callback: callback)
//               (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
    }
//
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        auth.isUserConnected(callback: callback)
    }
    
    func saveUserProfile(dict: Dictionary<String, Any>,  onSuccess: @escaping(Bool) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        auth.saveUserProfile(dict: dict, onSuccess: onSuccess, onError: onError)
    }
    
    func savePhotoProfile(image: Data, uid: String, onError: @escaping(_ errorMessage: String) -> Void) {
        auth.savePhotoProfile(image: image, uid: uid, onError: onError)
    }
    
    func saveFoodPhoto(image: Data, uid: String,dictValue:String, onError: @escaping(_ errorMessage: String) -> Void) {
        auth.saveFoodPhoto(image: image, uid: uid, dictValue: dictValue, onError: onError)
    }
    
    func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onError: @escaping(_ errorMessage: String) -> Void) {
        auth.savePhoto(username: username, uid: uid, data: data, metadata: metadata, storageProfileRef: storageProfileRef, dict: dict, onError: onError)
    }
    
    func savePhotoMessage(image: UIImage?, id: String, callback: @escaping (Result<Any, Error>)  -> Void) {
        auth.savePhotoMessage(image: image, id: id, callback: callback)
    }
    
    
}
