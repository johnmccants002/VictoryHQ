//
//  ProfileController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/7/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "ProfileCell"

class ProfileController: UITableViewController, UITabBarControllerDelegate, UINavigationControllerDelegate {
    
    var currentUser: User?
//    var testData: String?
    var requestUser: User?
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: 380))
    
    var isAdmin: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        fetchUserInformation()
        configureUI()
        setupObserver()

        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func configureUI() {
        configureNavigationBar(title: "Profile", prefersLargeTitles: false)
        tableView.tableHeaderView = headerView
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 60
        tableView.backgroundColor = .systemGroupedBackground
        
        overrideUserInterfaceStyle = .light
        
    }
    
    func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchUserInformation), name: NSNotification.Name.init(rawValue: "fetchUserInformation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoad), name: NSNotification.Name.init(rawValue: "login"), object: nil)
    }
    
    @objc func fetchUserInformation() {
        UserService.shared.fetchCurrentUser { user in
            self.currentUser = user
            self.headerView.user = user
            self.tableView.reloadData()
            
            if user == nil {
                guard let currentUser = Auth.auth().currentUser else {
                    return
                }

                UserService.shared.fetchUserFromRequests() { user in
                    self.requestUser = user
                    self.headerView.user = user
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.bool(forKey: "admin") {
            return AdminViewModel.allCases.count
        } else {
            return ProfileViewModel.allCases.count
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        if UserDefaults.standard.bool(forKey: "admin") {
            let adminViewModel = AdminViewModel(rawValue: indexPath.row)
            cell.adminViewModel = adminViewModel
        } else if isAdmin == false {
            let viewModel = ProfileViewModel(rawValue: indexPath.row)
            cell.viewModel = viewModel
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
   
}

extension ProfileController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.bool(forKey: "admin") {
            guard let viewModel = AdminViewModel(rawValue: indexPath.row) else { return }
            print("Take me to \(viewModel.description)")
            
            
            switch viewModel {
            case .accountInfo:
                let controller = EditProfileController()
                controller.signOutDelegate = self
                self.navigationController?.pushViewController(controller, animated: true)
            case .victories:
                let controller = UserVictoriesController()
                self.navigationController?.pushViewController(controller, animated: true)
            case .respectActivity:
                let controller = ActivityController()
                self.navigationController?.pushViewController(controller, animated: true)
                print("Respect Activity Controller presenting")
            case .requests:
                let controller = RequestsController()
                self.navigationController?.pushViewController(controller, animated: true)
            case .discordServer:
                let appURL = URL(string: "https://discord.gg/cxDPjyq6")!
                        let application = UIApplication.shared
                        
                        if application.canOpenURL(appURL)
                        {
                            application.open(appURL)
                        }
                        else
                        {
                            let webURL = URL(string: "https://discord.com/channels/940436495465078825/940436495922253836")!
                            application.open(webURL)
                        }
            }
        } else  {
            guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else { return }
            switch viewModel {
            case .accountInfo:
                let controller = EditProfileController()
                controller.signOutDelegate = self
                self.navigationController?.pushViewController(controller, animated: true)
            case .victories:
                let controller = UserVictoriesController()
                self.navigationController?.pushViewController(controller, animated: true)
            case .respectActivity:
                let controller = ActivityController()
                self.navigationController?.pushViewController(controller, animated: true)
                print("Respect Activity Controller presenting")
            case .discordServer:
                let appURL = URL(string: "https://discord.gg/cxDPjyq6")!
                        let application = UIApplication.shared
                        
                        if application.canOpenURL(appURL)
                        {
                            application.open(appURL)
                        }
                        else
                        {
                            let webURL = URL(string: "https://discord.com/channels/940436495465078825/940436495922253836")!
                            application.open(webURL)
                        }
           
            }
        }
   
        


    }
}

extension ProfileController: SignOutDelegate {
    
    func resetDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }


    func signOut() {
        let currentUserUid = UserDefaults.standard.value(forKey: "currentUserUid") as? String
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
        UserDefaults.standard.removeObject(forKey: "currentUserUid")
        resetDefaults()
            
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            _ = self.tabBarController?.selectedIndex = 0
            self.present(nav, animated: true, completion: nil)
    
}
}

protocol SignOutDelegate: NSObject {
    func signOut()
}

