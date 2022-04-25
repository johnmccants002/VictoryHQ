//
//  RequestsController.swift
//  VictoryHQ
//
//  Created by John McCants on 2/5/22.
//

import Foundation
import UIKit

private let requestCellIdentifier = "RequestCell"
class RequestsController: UITableViewController {
    
    var users = [User]()
    
    var currentUser : User?
    
    var randomEmojis = ["🔥", "💯", "🥳", "🤟🏼", "🙌🏼","🏁"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchRequests()
        fetchCurrentUser()
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        configureNavigationBar(title: "Requests", prefersLargeTitles: false)
        tableView.backgroundColor = .white
        tableView.register(RequestCell.self, forCellReuseIdentifier: requestCellIdentifier)
        
    }
    
    func fetchRequests() {
        UserService.shared.fetchRequests { users in
            if users?.count == 0 || users == nil {
                print("In if statement requests")
                let emptyView = RequestsEmptyView(frame: CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY, width: self.view.bounds.width, height: self.view.bounds.height))
                self.view.addSubview(emptyView)
            }
            if let users = users {
                self.users = users
                self.tableView.reloadData()
        }
        }
    }
    
    func fetchCurrentUser() {
        let currentUserUid = UserDefaults.standard.value(forKey: "currentUserUid") as? String
        UserService.shared.fetchCurrentUser { user in
            self.currentUser = user
        }
    }
    
    func createVictory(user: User) {
        guard let currentUser = self.currentUser else { return }
        let randomEmoji = randomEmojis[Int.random(in: 0..<4)]
        var newVictory = NewVictory(victoryText: "added a new member to Victory HQ. Welcome \(user.fullName)! \(randomEmoji)")
        newVictory.taggedUser = user.uid
        newVictory.taggedUserFullName = user.fullName
        VictoryService.shared.uploadVictory(user: currentUser, victoryText: "added a new member to Victory HQ. Welcome \(user.fullName)! \(randomEmoji)", victoryImage: nil, victoryDetails: nil) { err in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchVictories"), object: nil)
            if let err = err {
                print(err.localizedDescription)
            }
        }
    }
    
    
    
    @objc func removeCell(sender: UIButton) {
        let i = sender.tag
        users.remove(at: i)
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: requestCellIdentifier, for: indexPath) as? RequestCell else {
            return UITableViewCell() }
        cell.user = users[indexPath.row]
        cell.delegate = self
        cell.acceptButton.tag = indexPath.row
        cell.denyButton.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension RequestsController: RequestCellDelegate {
    func acceptTapped(cell: RequestCell) {
        guard let user = cell.user else { return }
        UserService.shared.acceptTapped(uid: user.uid) {
            print("Before guard: \(cell.token)")
            guard let token = cell.token else {
                self.createVictory(user: user)
                self.removeCell(sender: cell.acceptButton)
                self.tableView.reloadData()
                return
            }
            print("In guard: \(token)")
            let currentUserUid = UserDefaults.standard.value(forKey: "currentUserUid") as! String
            print("currentUserUid: \(currentUserUid)")
            PushNotificationSender.shared.sendPushNotification(to: token, title: "Victory HQ Acceptance", body: "You have been accepted into Victory HQ. Welcome to the team!", id: currentUserUid)
            self.createVictory(user: user)
            self.removeCell(sender: cell.acceptButton)
            self.tableView.reloadData()
        }
    }
    
    func denyTapped(cell: RequestCell) {
        guard let user = cell.user else { return }
        UserService.shared.denyTapped(uid: user.uid) {
            self.removeCell(sender: cell.denyButton)
            self.tableView.reloadData()
        }
    }
    
    
}
