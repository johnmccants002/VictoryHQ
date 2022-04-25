//
//  SettingsController.swift
//  VictoryHQ
//
//  Created by John McCants on 3/21/22.
//

import Foundation
import UIKit
import Firebase

class SettingsController: UIViewController, UINavigationControllerDelegate, UITabBarDelegate {
    
    var logoutButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.textColor = .red
        button.setDimensions(width: 200, height: 50)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    
    func updateUI() {
        self.navigationController?.delegate = self
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        configureNavigationBar(title: "Settings", prefersLargeTitles: false)
        self.view.backgroundColor = .white
        self.view.addSubview(logoutButton)
        logoutButton.centerX(inView: self.view)
        logoutButton.centerY(inView: self.view)
    }
    
    @objc func logout() {
            do {
                try Auth.auth().signOut()
                presentLoginScreen()
            } catch  {
                print("DEBUG: Error signing out...")
            }
        
    }
    
    func presentLoginScreen() {
        let currentUserUid = UserDefaults.standard.value(forKey: "currentUserUid") as? String
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
        UserDefaults.standard.removeObject(forKey: "currentUserUid")
        resetDefaults()
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            _ = self.tabBarController?.selectedIndex = 0
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func resetDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    } 
}
