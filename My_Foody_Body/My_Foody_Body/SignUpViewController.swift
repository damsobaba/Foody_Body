//
//  SignUpViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 11/02/2021.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullnameContainterView: UIView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailContainterView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainterView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    var image:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonsAspect()
        setUpAvatar()
    }
    
    
    func changeButtonsAspect() {
        signInButton.layer.cornerRadius = 6
        signUpButton.layer.cornerRadius = 6
        
    }
    
    func setUpAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker,animated: true, completion: nil)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func SignUpButtonTapped(_ sender: Any) {
        
        guard let imageSelected = self.image else {
            print("Avatar")
            return
        }
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else { return }
        
        Auth.auth().createUser(withEmail: "test14@gmail.com", password: "123456") { (authDataResult, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if let authData = authDataResult {
                print(authData.user.email)
                var dict: Dictionary<String, Any> =  [
                    "uid": authData.user.uid,
                    "email": authData.user.email!,
                    "profileImageUrl": "",
                    "status": "Welcome "
                ]
                let storageRef = Storage.storage().reference(forURL: "gs://foody-body-be872.appspot.com")
                let storageProfileRef = storageRef.child("profile").child(authData.user.uid)
                
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                storageProfileRef.putData(imageData,metadata: metadata,completion: {(StorageMetadata,error) in
                    if error != nil {
                        print(error?.localizedDescription)
                        return
                    }
                    storageProfileRef.downloadURL { (url, error) in
                        if let metaImageUrl = url?.absoluteString {
                           dict["profileImageUrl"] = metaImageUrl
                            Database.database().reference().child("users")
                                .child(authData.user.uid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
                                if error == nil {
                                    print("Done")
                                }
                            })
                        }
                    }
                })
                
                
            }
        }
        
    }

}
extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            avatar.image = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            avatar.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
