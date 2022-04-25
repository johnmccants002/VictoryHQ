//
//  ViewVictoryController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/17/22.
//

import Foundation
import UIKit

private let victoryCellIdentifier = "VictoryCell"
class ViewVictoryController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var victory: Victory?
    var victoryID: String
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchVictory()
    }
    
    init(victoryID: String) {
        self.victoryID = victoryID
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.collectionView.backgroundColor = .white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(VictoryCell.self, forCellWithReuseIdentifier: victoryCellIdentifier)
        configureNavigationBar(title: "Victory", prefersLargeTitles: false)
       
    }
    
    func fetchVictory() {
        VictoryService.shared.fetchVictory(victoryID: victoryID) { victory in
            self.victory = victory
            self.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: victoryCellIdentifier, for: indexPath) as? VictoryCell else { return UICollectionViewCell()}
                guard let victory = victory else {
                    return cell
                }

                cell.victory = victory
                cell.delegate = self
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }

    
}

extension ViewVictoryController: VictoryCellDelegate {
    func unrespectTapped(cell: VictoryCell) {
        
    }
    
    func detailsTapped(cell: VictoryCell) {
        
    }
    
    func moreButtonTapped(cell: VictoryCell) {
        
    }
    
    func longPress(cell: VictoryCell) {
        
    }
    
    func respectTapped(cell: VictoryCell) {
        
    }
    
    func profilePicTapped(cell: VictoryCell) {
        
    }
    
    
}
