//
//  StorageService.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//


import Foundation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

import AVFoundation

class StorageService {


     
    static func savePhotoMessage(image: UIImage?, id: String, callback: @escaping (Result<Any, Error>)  -> Void) {
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
    
    
//    static func savePhotoMessage(image: UIImage?, id: String, onSuccess: @escaping(_ value: Any) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
//        if let imagePhoto = image {
//            let ref = Ref().storageSpecificImageMessage(id: id)
//            if let data = imagePhoto.jpegData(compressionQuality: 0.5) {
//
//                ref.putData(data, metadata: nil) { (metadata, error) in
//                    if error != nil {
//                        onError(error!.localizedDescription)
//                    }
//                    ref.downloadURL(completion: { (url, error) in
//                        if let metaImageUrl = url?.absoluteString {
//                            let dict: Dictionary<String, Any> = [
//                                "imageUrl": metaImageUrl as Any,
//                                "height": imagePhoto.size.height as Any,
//                                "width": imagePhoto.size.width as Any,
//                                "text": "" as Any
//                            ]
//                            onSuccess(dict)
//                        }
//                    })
//                }
//            }
//        }
//    }
//
    
    
    static func savePhotoProfile(image: UIImage, uid: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void)  {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {
            return
        }
        
        let storageProfileRef = Ref().storageSpecificProfile(uid: uid)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageProfileRef.putData(imageData, metadata: metadata, completion: { (storageMetaData, error) in
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
                    
                    Ref().databaseSpecificUser(uid: uid).updateChildValues([profilImageUrl: metaImageUrl], withCompletionBlock: { (error, ref) in
                        if error == nil {
                            
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    })
                }
            })
            
        })
        
        
    }
    
    static func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
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
                    dictTemp[profilImageUrl] = metaImageUrl
                    
                    
                    Ref().databaseSpecificUser(uid: uid).updateChildValues(dictTemp, withCompletionBlock: { (error, ref) in
                        if error == nil {
                            
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    })
                }
            })
            
        })
        
    }
}
