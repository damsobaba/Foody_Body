//
//  SignInViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 11/02/2021.
//


import UIKit

class SignInViewController: UIViewController {
    
    private let authService: AuthService = AuthService()
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.layer.cornerRadius = 20
        logoImageView.clipsToBounds = true
    }
    
    
    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func validateFields() {
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
            
            presentAlert(title: "Error", message: "please enter a valid email adress ")
            
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "please enter a valid password ")
            return
        }
        
    }
    
 
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        authService.signIn(email: email, password: password) { isSuccess in
            if isSuccess {
//                self.dismiss(animated: true)
                (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
            }
            else {
                self.presentAlert(title: "Try Again", message: "the paswword or email adress is incorect")
            }
        }
        
    }
    @IBAction private func unwindToSignInViewController(_ segue: UIStoryboardSegue) { dismiss(animated: false)
        
    }


    
}


