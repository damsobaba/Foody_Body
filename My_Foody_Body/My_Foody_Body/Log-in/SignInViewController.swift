//
//  SignInViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 11/02/2021.
//


import UIKit

class SignInViewController: UIViewController {

    
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordContainterView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func dismissAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    func validateFields() {
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
   
            presentAlert(title: "Error", message: "please enter a email adress ")
            
            return
        }
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "please enter a valid password ")
            return
        }
        
    }
    
    func signIn(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
     
        Api.User.signIn(email: self.emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            self.dismissLoadAlertWithMessage(alert: self.loadingAlert(), title: "", message: "Loading")
            onSuccess()
        }) { (errorMessage) in
            onError(errorMessage)
        }
    }
    
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateFields()
        self.signIn(onSuccess: {
            (UIApplication.shared.delegate as! AppDelegate).configureInitialViewController()
        }) { (errorMessage) in
         
            self.presentAlert(title: "Error", message: "They have been error")
        }
    }
    
}


