//
//  AppDelegate.swift
//  My_Foody_Body
//
//  Created by Adam Mabrouki on 11/02/2021.
//

import UIKit
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        configureInitialViewController()
        return true
    }
    
    func configureInitialViewController(){
           DispatchQueue.main.async {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           var initialVc:UIViewController?
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           if Auth.auth().currentUser != nil {
               let homeVC = storyboard.instantiateViewController(withIdentifier:  "TabBarVC" )
               initialVc = homeVC
           }
           else{
               let loginVC = storyboard.instantiateViewController(withIdentifier: "MainVC")
               initialVc = loginVC
           }
           

               if let scene = UIApplication.shared.connectedScenes.first{
                   guard let windowScene = (scene as? UIWindowScene) else { return }
                   let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                   window.windowScene = windowScene
                   window.rootViewController = initialVc
                   window.makeKeyAndVisible()
                   appDelegate.window = window
               }
           }
       }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


    

}
