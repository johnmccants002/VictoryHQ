//
//  Victory.swift
//  VictoryHQ
//
//  Created by John McCants on 1/9/22.
//

import Foundation
import UIKit

struct Victory: Codable {
    
    var victoryText: String
    var victoryDetails: String?
    var victoryID: String
    var uid: String
    var fullName: String
    var timestamp: Date!
    var dateString: String?
    var victoryImageUrl: URL?
    var didRespect: Bool?
    var taggedUser: String?
    var taggedUserFullName: String?
    
    init(victoryID: String, dictionary: [String: Any]) {
        self.victoryID = victoryID
        self.uid = dictionary["uid"] as? String ?? ""
        self.victoryText = dictionary["victoryText"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        
        if let details = dictionary["victoryDetails"] as? String {
            self.victoryDetails = details
        }
        
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy"
            let date = Date()
            let yesterday = date.dayBefore
            let todaysDateString = dateFormatter.string(from: date)
            let yesterdayDateString = dateFormatter.string(from: yesterday)
            let justDateString = dateFormatter.string(from: self.timestamp)
            if todaysDateString == justDateString {
                self.dateString = "Today"
            } else if yesterdayDateString == justDateString {
                self.dateString = "Yesterday"
            } else {
                self.dateString = dateFormatter.string(from: self.timestamp)
            }
           
       
        }
        
        if let victoryImageUrl = dictionary["victoryImageUrl"] as? String {
            guard let imageUrl = URL(string: victoryImageUrl) else { return }
            self.victoryImageUrl = imageUrl
        }
        
    }

}

struct Just {
    var justText: String
    var uid: String
    var timestamp: Date!
    var didRespect: Bool = false
    var firstName: String
    var lastName: String
    var justID: String
    var profileImageUrl: URL?
    var respects: Int = 0
    var justImageUrl: URL?
    var dateString: String?
    var token: String?
    var userOnFire: Bool = false
    var details: String?
    var userHeatingUp: Bool = false
    
    init(justID: String, dictionary: [String: Any]) {
        self.justID = justID
        self.uid = dictionary["uid"] as? String ?? ""
        self.justText = dictionary["justText"] as? String ?? ""
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.respects = dictionary["respects"] as? Int ?? 0
        
        if let details = dictionary["justDetails"] as? String {
            self.details = details
        }
        
        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrl) else { return }
            self.profileImageUrl = url
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy"
            let date = Date()
            let yesterday = date.dayBefore
            let todaysDateString = dateFormatter.string(from: date)
            let yesterdayDateString = dateFormatter.string(from: yesterday)
            let justDateString = dateFormatter.string(from: self.timestamp)
            if todaysDateString == justDateString {
                self.dateString = "Today"
            } else if yesterdayDateString == justDateString {
                self.dateString = "Yesterday"
            } else {
                self.dateString = dateFormatter.string(from: self.timestamp)
            }
           
       
        }
        
        if let justImageUrl = dictionary["justImageUrl"] as? String {
            guard let imageUrl = URL(string: justImageUrl) else { return }
            self.justImageUrl = imageUrl
        }
        
    }
    
}

extension Just: Equatable {
    static func == (lhs: Just, rhs: Just) -> Bool {
        return lhs.justID == rhs.justID
    }
}
