//
//  SceneDelegate.swift
//  ScretBrowser
//
//  Created by yangjian on 2023/2/27.
//

import UIKit
import Firebase
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    lazy var launchVC: LaunchVC = {
        LaunchVC.loadStoryBoard()
    }()
    
    lazy var homeVC: UINavigationController = {
        let vc = HomeVC.loadStoryBoard()
        return UINavigationController(rootViewController: vc)
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        AppUtil.shared.delegate = self
        if let url = connectionOptions.urlContexts.first?.url {
            ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    sourceApplication: nil,
                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                )
        }
        FirebaseApp.configure()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if AppUtil.shared.appEnterbackground == true {
            launching()
            FirebaseUtil.log(event: .openHot)
        }
        AppUtil.shared.appEnterbackground = false
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        AppUtil.shared.appEnterbackground = true
    }

    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {
            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        }

}

extension SceneDelegate {
    
    func launching() {
        window?.rootViewController = launchVC
        launchVC.launching()
    }
    
    func launched() {
        window?.rootViewController = homeVC
    }
    
}

