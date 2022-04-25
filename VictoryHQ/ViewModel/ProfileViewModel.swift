//
//  ProfileViewModel.swift
//  VictoryHQ
//
//  Created by John McCants on 1/12/22.
//

import Foundation
import UIKit

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo = 0
    case victories = 1
    case respectActivity = 2
    case discordServer = 3

    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .victories: return "Your Victories"
        case .respectActivity: return "Respect Activity"
        case .discordServer: return "Discord Channel"

        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .victories: return "text.badge.star"
        case .respectActivity: return "bell.circle"
        case .discordServer: return "network"
  
        }
    }
    
    
}
