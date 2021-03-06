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
    @IBOutlet weak var cookingImageView2: UIImageView!
    @IBOutlet weak var cookingImageView3: UIImageView!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet var foodDescriptionTextField: UITextField!
    @IBOutlet weak var foodDescription2TextField: UITextField!
    @IBOutlet weak var foodDescription3TextField: UITextField!
    
    private let authService: AuthService = AuthService()
    private let databaseManager: DatabaseManager = DatabaseManager()
    private var imageTag = 0
    private var ppImage: UIImage?
    private var currentImageView: UIImageView? = nil
    private var favoriteFoodImage:UIImage?
    private var favoriteFoodImage2: UIImage?
    private var favoriteFoodImage3: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        observeData()
        tableView.reloadData()
    }
    
    func setupView() {
        setupAvatar()
        setUpFoodImage()
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ageTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        statusTextField.resignFirstResponder()
        foodDescriptionTextField.resignFirstResponder()
        foodDescription2TextField.resignFirstResponder()
        foodDescription3TextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ageTextField.resignFirstResponder()
        usernameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        statusTextField.resignFirstResponder()
        foodDescriptionTextField.resignFirstResponder()
        foodDescription2TextField.resignFirstResponder()
        foodDescription3TextField.resignFirstResponder()
        return true
    }
    
    func setupAvatar() {
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
    }
    
    func setUpFoodImage() {
        [cookingImageView,cookingImageView2,cookingImageView3].forEach { $0?.layer.cornerRadius = 20}
        [cookingImageView,cookingImageView2,cookingImageView3].forEach { $0?.clipsToBounds = true }
        [cookingImageView,cookingImageView2,cookingImageView3].forEach { $0?.isUserInteractionEnabled = true
        }
        
    }
    
    // load the profila data from the firebase
    func observeData() {
        databaseManager.getUserInforSingleEvent(uid: Api.User.currentUserId) { (user) in
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            self.statusTextField.text = user.status
            self.avatar.loadImage(user.profileImageUrl)
            self.cookingImageView.loadImage(user.foodImage)
            self.cookingImageView2.loadImage(user.foodImage2)
            self.cookingImageView3.loadImage(user.foodImage3)
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
                self.foodDescriptionTextField.placeholder = "add ingredients"
            }
            if let foodDescription2 = user.foodDesciption2 {
                self.foodDescription2TextField.text = foodDescription2
            } else {
                self.foodDescription2TextField.placeholder = "add ingredients"
            }
            if let foodDescription3 = user.foodDescription3 {
                self.foodDescription3TextField.text = foodDescription3
            } else {
                self.foodDescription3TextField.placeholder = "add ingredients"
            }
        }
        
    }
    
    @IBAction func logoutBtnDidTapped(_ sender: Any) {
        authService.logOut { isSuccess in
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
            if !isSuccess {
                self.presentAlert(title: "error", message: "We having trouble tryng to log you out")
            }
        }
    }
    
    // saves all the informations into firebase database
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
        if let foodDescription2 = foodDescription2TextField.text {
            dict["foodDescription2"] = foodDescription2
        }
        if let foodDescription3 = foodDescription3TextField.text {
            dict["foodDescription3"] = foodDescription3
        }
        authService.saveUserProfile(dict: dict, onSuccess: { _ in 
            if let saveFoodImage = self.favoriteFoodImage?.jpeg  {
                self.authService.saveFoodPhoto(image: saveFoodImage, uid: Api.User.currentUserId, dictValue:"foodImage") { (errorMessage)  in
                    self.presentAlert(title: "Error", message: "they have been issues trying to change you profile")
                }
            }
            if let saveFoodImage2 = self.favoriteFoodImage2?.jpeg {
                self.authService.saveFoodPhoto(image: saveFoodImage2, uid: Api.User.currentUserId, dictValue:"foodImage2") { (errorMessage)  in
                    
                    self.presentAlert(title: "Error", message: "they have been issues trying to change you profile")
                }
            }
            if let saveFoodImage3 = self.favoriteFoodImage3?.jpeg  {
                
                self.authService.saveFoodPhoto(image: saveFoodImage3, uid: Api.User.currentUserId, dictValue:"foodImage3") { (errorMessage)  in
                    self.presentAlert(title: "Error", message: "they have been issues trying to change you profile")
                }
            }
            if let ppimg = self.ppImage?.jpeg {
                self.authService.savePhotoProfile(image: ppimg, uid: Api.User.currentUserId) {
                    (errorMessage) in
                    self.presentAlert(title: "Error", message: "they have been issues trying to change you profile")
                }
            }
        }) { (errorMessage) in
            self.presentAlert(title: "Error", message: "they have been issues trying to change you profile")
        }
        self.dismissLoadAlertWithMessage(alert: self.loadingAlert(), title: "", message: "Changes has been saved")
    }
    
    // handle all the tap gesture in order to pick the right photo for the rigth image
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        currentImageView = sender.view as? UIImageView
        imageTag = currentImageView!.tag
        view.endEditing(true)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

extension ProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageSelected = info[UIImagePickerController.InfoKey.editedImage]
        currentImageView?.image = imageSelected as? UIImage
        
        switch imageTag {
        case 0:
            ppImage = imageSelected as? UIImage
        case 1:
            favoriteFoodImage = imageSelected as? UIImage
        case 2:
            favoriteFoodImage2 = imageSelected as? UIImage
        case 3:
            favoriteFoodImage3 = imageSelected as? UIImage
        default:
            break
        }
        let imageOriginal = info[UIImagePickerController.InfoKey.originalImage]
        currentImageView?.image = imageOriginal as? UIImage
        switch imageTag {
        case 0:
            ppImage = imageOriginal as? UIImage
        case 1:
            favoriteFoodImage = imageOriginal as? UIImage
        case 2:
            favoriteFoodImage2 = imageOriginal as? UIImage
        case 3:
            favoriteFoodImage3 = imageOriginal as? UIImage
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
}
