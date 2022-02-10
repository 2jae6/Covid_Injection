//
//  AppDelegate.swift
//  AutoCrypt_Test
//
//  Created by Jay on 2022/01/13.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let rootViewcontroller = UINavigationController(rootViewController: ListViewController(with: ListViewModel()))

        window?.rootViewController = rootViewcontroller
        return true
    }

}
