//
//  AppDelegate.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 01/04/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var api = APIManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppDelegate.api.getAllPlayersFromBE()
        
        if let isSkipped = UserDefaultsManager.shared.getValue(for: .skipOnBoarding) as? Bool, isSkipped {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as? UINavigationController
            return true
        }
        
        return true
    }


}

