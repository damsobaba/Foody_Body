//
//  Reference.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//




import Foundation
import Firebase

let refUser = "users"
let refMessage = "messages"
let refInbox = "inbox"

let urlStorageRoot = "gs://foody-body-be872.appspot.com"
let storageProfil = "profile"
let profilImageUrl = "profileImageUrl"
let foodImage = "foodImage"
let uid = "uid"
let emaiL = "email"
let usernamE = "username"
let status = "status"


let identifierTabbar = "TabBarVC"
let identifierMain = "MainVC"
let IdentifierChat = "ChatVC"





class Ref {
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(refUser)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    var databaseMessage: DatabaseReference {
        return databaseRoot.child(refMessage)
    }
    
    func databaseMessageSendTo(from: String, to: String) -> DatabaseReference {
        return databaseMessage.child(from).child(to)
    }
    
    var databaseInbox: DatabaseReference {
        return databaseRoot.child(refInbox)
    }
    
    func databaseInboxInfor(from: String, to: String) -> DatabaseReference {
        return databaseInbox.child(from).child(to)
    }
    
    func databaseInboxForUser(uid: String) -> DatabaseReference {
        return databaseInbox.child(uid)
    }
    
    // Storage Ref
    
    let storageRoot = Storage.storage().reference(forURL: urlStorageRoot)
    
    var storageMessage: StorageReference {
        return storageRoot.child(refMessage)
    }
    
    var storageProfile: StorageReference {
        return storageRoot.child(storageProfil)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
    
    func storageSpecificImageMessage(id: String) -> StorageReference {
        return storageMessage.child("photo").child(id)
    }
    
    func storageSpecificFoodImage(id: String) -> StorageReference {
        return storageMessage.child("photo").child(id)
    }
    
}
