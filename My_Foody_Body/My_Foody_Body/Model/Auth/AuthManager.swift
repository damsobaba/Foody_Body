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
import FirebaseDatabase
import AVFoundation

protocol AuthType {
    var currentUserId: String { get }
    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void)
    func signUp(userName: String, email: String, password: String,image: Data?, callback: @escaping (Bool) -> Void)
    func logOut(callback: @escaping (Bool) -> Void)
    func isUserConnected(callback: @escaping (Bool) -> Void)
    func saveUserProfile(dict: Dictionary<String, Any>,  onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void)
    
    
    
    func savePhotoProfile(image: Data, uid: String, onError: @escaping(_ errorMessage: String) -> Void)
    func saveFoodPhoto(image: Data, uid: String,dictValue:String, onError: @escaping(_ errorMessage: String) -> Void)
    
   func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onError: @escaping(_ errorMessage: String) -> Void)
    
    
   func savePhotoMessage(image: UIImage?, id: String, callback: @escaping (Result<Any, Error>)  -> Void)
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
    

    func signUp(userName: String, email: String, password: String,image: Data?, callback: @escaping (Bool) -> Void) {
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
                

                let storageProfile = Ref().storageSpecificProfile(uid: authData.user.uid)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                
                self.savePhoto(username: userName, uid: authData.user.uid, data: imageSelected, metadata: metadata, storageProfileRef: storageProfile, dict: dict,onError: { (errorMessage) in
                    callback(true)
                })
                
            }
        }
    }
    
 
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
  
    func isUserConnected(callback: @escaping (Bool) -> Void) {
        _ = Auth.auth().addStateDidChangeListener { _, user in
            guard (user != nil) else {
                callback(false)
                return
            }
            callback(true)
        }
    }
    
    


   
         
        
    func savePhotoProfile(image: Data, uid: String, onError: @escaping(_ errorMessage: String) -> Void)  {

               
               let storageProfileRef = Ref().storageSpecificProfile(uid: uid)
               
               let metadata = StorageMetadata()
               metadata.contentType = "image/jpg"
               
               storageProfileRef.putData(image, metadata: metadata, completion: { (storageMetaData, error) in
                   if error != nil {
                       onError(error!.localizedDescription)
                       return
                   }
                   
                   storageProfileRef.downloadURL(completion: { (url, error) in
                       if let metaImageUrl = url?.absoluteString {
                           
                           if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                               changeRequest.photoURL = url
                               changeRequest.commitChanges(completion: { (error) in
                                
                               })
                           }
                           
                        Ref().databaseSpecificUser(uid: uid).updateChildValues(["profileImageUrl": metaImageUrl], withCompletionBlock: { (error, ref) in
                               if error != nil {
                                onError(error!.localizedDescription)
                                  
                               }
                           })
                       }
                   })
                   
               })
               
               
          }

    func saveFoodPhoto(image: Data, uid: String,dictValue:String, onError: @escaping(_ errorMessage: String) -> Void)  {
   

            let storageProfileRef = Ref().storageSpecificProfile(uid: uid)

            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"

            storageProfileRef.putData(image, metadata: metadata, completion: { (storageMetaData, error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if let metaImageUrl = url?.absoluteString {

                        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                            changeRequest.photoURL = url
                            changeRequest.commitChanges(completion: { (error) in

                            })
                        }

                        Ref().databaseSpecificUser(uid: uid).updateChildValues([dictValue: metaImageUrl,], withCompletionBlock: { (error, ref) in
                            if error != nil {
                                onError(error!.localizedDescription)
                            }
                        })

                    }
                })

            })


        }

        
        func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onError: @escaping(_ errorMessage: String) -> Void) {
            storageProfileRef.putData(data, metadata: metadata, completion: { (storageMetaData, error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
                
                storageProfileRef.downloadURL(completion: { (url, error) in
                    if let metaImageUrl = url?.absoluteString {
                        
                        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                            changeRequest.photoURL = url
                            changeRequest.displayName = username
                            changeRequest.commitChanges(completion: { (error) in
                            })
                        }
                        
                        var dictTemp = dict
                        dictTemp["profileImageUrl"] = metaImageUrl
                    
                        
                        Ref().databaseSpecificUser(uid: uid).updateChildValues(dictTemp, withCompletionBlock: { (error, ref) in
                            if error != nil {
                                onError(error!.localizedDescription)
                               
                            }
                        })
                    }
                })
                
            })
            
        }
        
        
        
    func savePhotoMessage(image: UIImage?, id: String, callback: @escaping (Result<Any, Error>)  -> Void) {
            if let imagePhoto = image {
                let ref = Ref().storageSpecificImageMessage(id: id)
                if let data = imagePhoto.jpegData(compressionQuality: 0.5) {
                    
                    ref.putData(data, metadata: nil) { (metadata, error) in
                        if error != nil {
                            callback(.failure(error!))
                        }
                        ref.downloadURL(completion: { (url, error) in
                            if let metaImageUrl = url?.absoluteString {
                                let dict: Dictionary<String, Any> = [
                                    "imageUrl": metaImageUrl as Any,
                                    "height": imagePhoto.size.height as Any,
                                    "width": imagePhoto.size.width as Any,
                                    "text": "" as Any
                                ]
                                callback(.success(dict))
                            }
                        })
                    }
                }
            }
        }
       
        
    }
    
    
    
    
    
    

   
