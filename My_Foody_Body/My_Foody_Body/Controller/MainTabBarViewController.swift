//
//  MainTabBarViewController.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 03/03/2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    // MARK: - Properties

    private let authService: AuthService = AuthService()

    // MARK: - View Life Cycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        authService.isUserConnected { isConnected in
//            if !isConnected {
//                DispatchQueue.main.async {
//                    let storyboard = UIStoryboard(name: "Authentification", bundle: nil)
//                    let signInViewController = storyboard.instantiateViewController(identifier: "SignInViewController")
//                    signInViewController.modalPresentationStyle = .fullScreen
//                    self.present(signInViewController, animated: true)
//                }
//            }
//        }
//    }
}
