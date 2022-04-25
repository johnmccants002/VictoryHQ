//
//  Respect.swift
//  VictoryHQ
//
//  Created by John McCants on 2/2/22.
//

import Foundation
import UIKit

struct RespectNotification {
    let fullName: String
    let victoryID: String
    let respectID: String
    var timestamp : Date!
    
    init(respectID: String, dict: [String: Any]) {
        self.respectID = respectID
        self.fullName = dict["fullName"] as? String ?? ""
        self.victoryID = dict["victoryID"] as? String ?? ""
        
        if let timestamp = dict["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}

