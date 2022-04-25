//
//  AdminViewModel.swift
//  VictoryHQ
//
//  Created by John McCants on 1/14/22.
//

import Foundation
import UIKit

enum AdminViewModel: Int, CaseIterable {
    case accountInfo = 0
    case victories = 1
    case requests = 2
    case respectActivity = 3
    case discordServer = 4
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .victories: return "Your Victories"
        case .requests: return "Requests to Enter Network"
        case .respectActivity: return "Respect Activity"
        case .discordServer: return "Discord Channel"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .victories: return "text.badge.star"
        case .requests: return "mail.stack.fill"
        case .respectActivity: return "bell.circle"
        case .discordServer: return "network"
        
        }
    }
    
    
}
