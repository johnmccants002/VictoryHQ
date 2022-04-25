//
//  NewVictory.swift
//  VictoryHQ
//
//  Created by John McCants on 1/17/22.
//

import Foundation
import UIKit

struct NewVictory {
    var victoryText: String
    var victoryDetails: String?
    var victoryImage: UIImage?
    var taggedUser: String?
    var taggedUserFullName: String?
    
    init(victoryText: String) {
        self.victoryText = victoryText
    }
}
