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
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var initialVc:UIViewController?
        let storyboard=UIStoryboard(name: "Main", bundle: nil)
        
        if Auth.auth().currentUser != nil {
            let homeVC = storyboard.instantiateViewController(withIdentifier:  IDENTIFIER_TABBAR )
            initialVc = homeVC
        }
        else{
            let loginVC = storyboard.instantiateViewController(withIdentifier:  IDENTIFIER_MAIN)
            initialVc = loginVC
        }
        
//        if #available(iOS 14.1, *) {
            if let scene = UIApplication.shared.connectedScenes.first{
                guard let windowScene = (scene as? UIWindowScene) else { return }
                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
                window.windowScene = windowScene
                window.rootViewController = initialVc
                window.makeKeyAndVisible()
                appDelegate.window = window
            }
//        }
//        else
//        {
//            appDelegate.window?.rootViewController = initialVc
//            appDelegate.window?.makeKeyAndVisible()
//        }
//        }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
