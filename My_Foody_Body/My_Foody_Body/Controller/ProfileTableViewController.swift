//
//  ProfileTableViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 17/02/2021.
//

import UIKit


class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    
    @IBOutlet weak var cookingImageView: UIImageView!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet var foodDescriptionTextField: UITextField!
    var imageTag = 0
    
    var ppImage: UIImage?
    var favoriteFoodImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeData()
    }
    
    func setupView() {
        setupAvatar()
        setUpFoodImage()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
        imageTag = 1
        
    }
    
    func setUpFoodImage() {
        cookingImageView.layer.cornerRadius = 20
        cookingImageView.clipsToBounds = true
        cookingImageView.isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        cookingImageView.addGestureRecognizer(tapGesture2)
        imageTag = 2
    }
    //PASSER par DES BOUTOOOONNNNNNS
    
    @objc func presentPicker() {
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func observeData() {
        Api.User.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            self.statusTextField.text = user.status
            self.avatar.loadImage(user.profileImageUrl)
            self.cookingImageView.loadImage(user.foodImage)
            
            if let age = user.age {
                self.ageTextField.text = "\(age)"
            } else {
                self.ageTextField.placeholder = "Optional"
            }
            
            
            if let isMale = user.isMale {
                self.genderSegment.selectedSegmentIndex = (isMale == true) ? 0 : 1
            }
            if let foodDescription = user.foodDescription {
                self.foodDescriptionTextField.text = foodDescription
            } else {
                self.foodDescriptionTextField.placeholder = "No name for thise beauty"
            }
            
        }
        
    }
    
    
    
    @IBAction func logoutBtnDidTapped(_ sender: Any) {
        Api.User.logOut()
    }
    
    @IBAction func saveBtnDidTapped(_ sender: Any) {
        
        
        
        var dict = Dictionary<String, Any>()
        if let username = usernameTextField.text, !username.isEmpty {
            dict["username"] = username
        }
        if let email = emailTextField.text, !email.isEmpty {
            dict["email"] = email
        }
        if let status = statusTextField.text, !status.isEmpty {
            dict["status"] = status
        }
        if genderSegment.selectedSegmentIndex == 0 {
            dict["isMale"] = true
        }
        if genderSegment.selectedSegmentIndex == 1 {
            dict["isMale"] = false
        }
        if let age = ageTextField.text, !age.isEmpty {
            dict["age"] = Int(age)
        }
        if let foodDescription = foodDescriptionTextField.text {
            dict["foodDescription"] = foodDescription
        }
        
        
        
        Api.User.saveUserProfile(dict: dict, onSuccess: {
            if let favoriteFoodImage = self.favoriteFoodImage {
                StorageService.saveFoodPhoto(image: favoriteFoodImage, uid: Api.User.currentUserId, onSuccess: {
                    
                }) { (errorMessage)  in
                    
                    print("comprend r ")
                }
            }
            
            
            if let ppimg = self.ppImage {
                StorageService.savePhotoProfile(image: ppimg, uid: Api.User.currentUserId, onSuccess: {
                    
                }) { (errorMessage) in
                    
                    self.presentAlert(title: "Error", message: "they have been issues trying to change you profile")
                }
            } else {
                self.dismissLoadAlertWithMessage(alert: self.loadingAlert(), title: "", message: "Changes has been saved")
            }
          
            
        }) { (errorMessage) in
            self.presentAlert(title: "Error", message: "they have been issues trying to change you profile")
        }
        
        self.dismissLoadAlertWithMessage(alert: self.loadingAlert(), title: "", message: "Changes has been saved")
        
        
        
        
        
    }
    
    
    
    
    
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
       
            if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                
                if imageTag == 1 {
                ppImage = imageSelected
                    avatar.image = imageSelected }
                    else  if imageTag == 2 {
                favoriteFoodImage = imageSelected
                cookingImageView.image = imageSelected
                    }
                }
            
            if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                if imageTag == 1 {
                ppImage = imageOriginal
                avatar.image = imageOriginal
//                }
//                else  {
                favoriteFoodImage = imageOriginal
                cookingImageView.image = imageOriginal
                
                }
            }
    
            // la on a que la foodView qui change
        
        
//                if let imageSelectedFood = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//                    favoriteFoodImage = imageSelectedFood
//                    cookingImageView.image = imageSelectedFood
//                }
//
//                if let imageOriginal2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                    favoriteFoodImage = imageOriginal2
//                    cookingImageView.image = imageOriginal2
//                }
            
        
        
        
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //    func foodImagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //
    //        if let imageSelectedFood = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
    //            favoriteFoodImage = imageSelectedFood
    //            cookingImageView.image = imageSelectedFood
    //        }
    //
    //        if let imageOriginal2 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
    //            favoriteFoodImage = imageOriginal2
    //            cookingImageView.image = imageOriginal2
    //        }
    //
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    
    
    
}
