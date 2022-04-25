//
//  ActivityController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/13/22.
//

import Foundation
import UIKit

private let respectCellIdentifier = "RespectCell"
class ActivityController: UITableViewController {
    
    var respectNotifications = [RespectNotification]()
    
    var respectTotal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchRespectNotifications()
        fetchTotalRespect()
    }
    
    func configure() {
        self.tableView.backgroundColor = .white
        self.tableView.register(RespectCell.self, forCellReuseIdentifier: respectCellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        configureNavigationBar(title: "Respect Activity", prefersLargeTitles: false)
        
        
        
        
    }
    
    func fetchTotalRespect() {
        VictoryService.shared.fetchTotalRespects { number in
            if let number = number {
                self.respectTotal = number
                print("This is the number \(number)")
                let button = UIButton()
                button.addTarget(self, action: #selector(self.presentRespectAlert), for: .touchUpInside)
                button.setTitle("\(number)", for: .normal)
                let barButton = UIBarButtonItem(customView: button)
                self.navigationItem.setRightBarButton(barButton, animated: true)

                
            }
        
            
        }
        
    }
    func fetchRespectNotifications(){
        VictoryService.shared.fetchRespectActivity { respectNotifications in
            let sorted = respectNotifications.sorted(by: { ($0.timestamp ?? Date.distantFuture) > ($1.timestamp as? Date ?? Date.distantPast)})

        
            self.respectNotifications = sorted
            self.tableView.reloadData()
        }
    }
    
    
    @objc func presentRespectAlert() {
        guard let respectTotal = respectTotal else {
            return
        }

        let alert = UIAlertController(title: "Total Respect: \(respectTotal)", message: "Keep it going!", preferredStyle: .alert)
        let action = UIAlertAction(title: "🔥 LFG 🔥", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        respectNotifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: respectCellIdentifier, for: indexPath) as? RespectCell else { return UITableViewCell() }
        cell.respectNotification = respectNotifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}


extension ActivityController: RespectCellDelegate {
    func respectCellTapped(cell: RespectCell) {
        print("present view victory")
        guard let victoryID = cell.respectNotification?.victoryID else { return }
        let controller = ViewVictoryController(victoryID: victoryID)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
