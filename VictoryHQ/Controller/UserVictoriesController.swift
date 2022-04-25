//
//  UserVictoriesController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/14/22.
//

import Foundation
import UIKit
import Firebase

let victoryIdentifier = "VictoryCell"
class UserVictoriesController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
    
    var victories = [Victory]()
    var lastVictory : Victory?
    var refreshControl = UIRefreshControl()
    var endingReached = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        configureUI()
        fetchUserVictories()
    }
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        configureNavigationBar(title: "Your Victories", prefersLargeTitles: false)
        collectionView.register(VictoryCell.self, forCellWithReuseIdentifier: victoryIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetchUserVictories), for: .valueChanged)
    }
    
    @objc func fetchUserVictories() {
        VictoryService.shared.fetchUserVictories(lastVictory: lastVictory) { victories in
            if victories.count == 0 {
                self.endingReached = true
            }
            self.lastVictory = victories.last
            self.refreshControl.endRefreshing()
            self.victories.append(contentsOf: victories)
            self.collectionView.reloadData()
        }
    }
    
    func presentDeleteAlert(victory: Victory, row: Int) {
        
        let alert = UIAlertController(title: "Delete Victory", message: "Are you sure you want to delete this Victory?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { _ in
            VictoryService.shared.deleteVictory(victory: victory) {
                print("Successfully deleted Victory")
                self.victories.remove(at: row)
                self.collectionView.reloadData()
            }
        }
        let action2 = UIAlertAction(title: "Nope", style: .cancel) { _ in
        }
        alert.addAction(action)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return victories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: victoryIdentifier, for: indexPath) as! VictoryCell
        
        cell.victory = victories[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        cell.configure()
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.victories.count - 1 {
            if endingReached == false {
                fetchUserVictories()
            }
        }
    }
    
    
    
    
}

extension UserVictoriesController: VictoryCellDelegate {
    func unrespectTapped(cell: VictoryCell) {
        
    }
    
    func respectTapped(cell: VictoryCell) {
        
    }
    
    func detailsTapped(cell: VictoryCell) {
        
    }
    
    func moreButtonTapped(cell: VictoryCell) {
        
    }
    
    func longPress(cell: VictoryCell) {
        guard let victory = cell.victory, let uid = Auth.auth().currentUser?.uid else { return }
        if victory.uid == uid {
            self.presentDeleteAlert(victory: victory, row: cell.tag)
        }
    }
    
    func profilePicTapped(cell: VictoryCell) {
        
    }
    
    
}
