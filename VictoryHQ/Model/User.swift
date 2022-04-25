//
//  User.swift
//  VictoryHQ
//
//  Created by John McCants on 1/7/22.
//

import Foundation
import UIKit

struct User {
    var fullName: String
    var profileImageUrl: URL?
    var aboutText: String?
    let uid: String
    var twitterHandle: String?
    var instagramHandle: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    
    
    init(uid: String, dict: [String: Any]) {
        self.uid = uid
        self.fullName = dict["fullName"] as? String ?? ""
        if let profileImageUrl = dict["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrl) else { return }
            self.profileImageUrl = url
        }
        self.aboutText = dict["aboutText"] as? String ?? ""
        self.twitterHandle = dict["twitter"] as? String ?? ""
        self.instagramHandle = dict["instagram"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        
        
    }
}
