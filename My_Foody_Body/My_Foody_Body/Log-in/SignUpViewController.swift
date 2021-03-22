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

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullnameContainterView: UIView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var emailContainterView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainterView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
  
    
    private let authService: AuthService = AuthService()
    private var image:UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButtonsAspect()
        setUpAvatar()
    }
  
    func changeButtonsAspect() {
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
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
       emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        fullnameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
         passwordTextField.resignFirstResponder()
         fullnameTextField.resignFirstResponder()
     return true
 }
    
    func validateFields() {
        guard let username = self.fullnameTextField.text, !username.isEmpty else {
         presentAlert(title: "", message: "please enter a username")
            return
        }
        guard let email = self.emailTextField.text, !email.isEmpty else {
            presentAlert(title: "", message: "Please enter a valide email")
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "", message: "Please enter a valid password")
            return
        }
    }
    
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        guard let userName = fullnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let image = image?.jpeg else { return }
        authService.signUp(userName: userName, email: email, password: password, image: image) { isSuccess in
            if isSuccess {
                self.performSegue(withIdentifier: "UnwindToSignInViewController", sender: nil)
            }
            else {
                self.presentAlert(title: "Try Again", message: "the paswword or email adress is incorect")
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

