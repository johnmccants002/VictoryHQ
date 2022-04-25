//
//  SceneDelegate.swift
//  VictoryHQ
//
//  Created by John McCants on 1/7/22.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        
        let tabController = UITabBarController()
        let mainController = MainController()
        let nav1 = UINavigationController(rootViewController: mainController)
        nav1.navigationBar.setGradientBackground(colors: [.systemPurple, .systemOrange], startPoint: .topLeft, endPoint: .bottomRight)
        let chatController = ChatController()
        let nav2 = UINavigationController(rootViewController: chatController)
        let profileController = ProfileController()
        let nav3 = UINavigationController(rootViewController: profileController)
        nav3.navigationBar.setGradientBackground(colors: [.systemPurple, .systemOrange], startPoint: .topLeft, endPoint: .bottomRight)
        
        mainController.title = "Feed"
        mainController.tabBarItem.image = UIImage(systemName: "house")
        
      
        profileController.title = "Profile"
        profileController.tabBarItem.image = UIImage(systemName: "person")
        chatController.title = "Chat"
        chatController.tabBarItem.image = UIImage(systemName: "message")
        tabController.tabBar.barStyle = .black
        tabController.tabBar.barTintColor = .lightText
        nav1.overrideUserInterfaceStyle = .light
        nav3.overrideUserInterfaceStyle = .light
        tabController.setViewControllers([nav1, nav3], animated: false)
        tabController.overrideUserInterfaceStyle = .light
        let controller = LoginController()
        let nav = UINavigationController(rootViewController: LoginController())
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

