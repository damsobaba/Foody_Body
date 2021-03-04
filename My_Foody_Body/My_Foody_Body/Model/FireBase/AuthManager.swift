//
//  UserApi.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 16/02/2021.
//


import Foundation
import FirebaseAuth
import Firebase

import FirebaseStorage

protocol AuthType {
    var currentUserId: String { get }
    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void)
    func signUp(userName: String, email: String, password: String,image: UIImage?, callback: @escaping (Bool) -> Void)
    func logOut(callback: @escaping (Bool) -> Void)
    func isUserConnected(callback: @escaping (Bool) -> Void)
}

class AuthManager: AuthType {
    
    
    
    
    private let ref = Ref()
    
    var currentUserId: String {
        return Auth.auth().currentUser != nil ? Auth.auth().currentUser!.uid : ""
    }
    
    
    
    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            guard (authData != nil), error == nil else {
                callback(false)
                return
            }
            callback(true)
        }
    }
    
    //
    
    
    
    //    func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
    //        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
    //            if error != nil {
    //                onError(error!.localizedDescription)
    //                return
    //            }
    //
    //            onSuccess()
    //        }
    //    }
    
    
    func signUp(userName: String, email: String, password: String,image: UIImage?, callback: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                print(error!.localizedDescription)
                return }
            if let authData = authDataResult {
                let dict: Dictionary<String, Any> =  [
                    self.ref.uid: authData.user.uid,
                    self.ref.emaiL: authData.user.email!,
                    self.ref.usernamE: userName,
                    self.ref.profileImageUrl: "",
                    self.ref.status: "Hello, I'm a new foody-body 😊 "
                    
                ]
                
                guard let imageSelected = image else { return }
                
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
                    return
                }
                
                let storageProfile = Ref().storageSpecificProfile(uid: authData.user.uid)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                StorageService.savePhoto(username: userName, uid: authData.user.uid, data: imageData, metadata: metadata, storageProfileRef: storageProfile, dict: dict,onError: { (errorMessage) in
                    callback(true)
                })
                
            }
        }
    }
    
    
    
    //    func signUp (withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
    //        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
    //            if error != nil {
    //               print(error!.localizedDescription)
    //                return }
    //            if let authData = authDataResult {
    //                let dict: Dictionary<String, Any> =  [
    //                    self.ref.uid: authData.user.uid,
    //                    self.ref.emaiL: authData.user.email!,
    //                    self.ref.usernamE: username,
    //                    self.ref.profileImageUrl: "",
    //                    self.ref.status: "Hello, I'm a new foody-body 😊 "
    //
    //                ]
    //
    //                guard let imageSelected = image else { return }
    //
    //                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
    //                    return
    //                }
    //
    //                let storageProfile = Ref().storageSpecificProfile(uid: authData.user.uid)
    //
    //                let metadata = StorageMetadata()
    //                metadata.contentType = "image/jpg"
    //
    //                StorageService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: metadata, storageProfileRef: storageProfile, dict: dict,onError: { (errorMessage) in
    //                    onError(errorMessage)
    //                })
    //
    //            }
    //        }
    //    }
    
    
    
    
    func saveUserProfile(dict: Dictionary<String, Any>,  onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Ref().databaseSpecificUser(uid: Api.User.currentUserId).updateChildValues(dict) { (error, dataRef) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    
    
    func logOut(callback: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            callback(true)
        } catch {
            callback(false)
        }
    }
//    
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        _ = Auth.auth().addStateDidChangeListener { _, user in
            guard (user != nil) else {
                callback(false)
                return
            }
            callback(true)
        }
    }
    
    func observeUsers(onSuccess: @escaping(UserCompletion)) {
        Ref().databaseUsers.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func getUserInforSingleEvent(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func getUserInfor(uid: String, onSuccess: @escaping(UserCompletion)) {
        let ref = Ref().databaseSpecificUser(uid: uid)
        ref.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                if let user = User.transformUser(dict: dict) {
                    onSuccess(user)
                }
            }
        }
    }
    
    func observeNewMatch(onSuccess: @escaping(UserCompletion)) {    Ref().databaseRoot.child("newMatch").child(Api.User.currentUserId).observeSingleEvent(of: .value) { (snapshot) in
        guard let dict = snapshot.value as? [String: Bool] else { return }
        dict.forEach({ (key, value) in
            self.getUserInforSingleEvent(uid: key, onSuccess: { (user) in
                onSuccess(user)
            })
        })
    }
    }
    
    
    
    
    
    
}

typealias UserCompletion = (User) -> Void


