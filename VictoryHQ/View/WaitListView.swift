//
//  WaitListView.swift
//  VictoryHQ
//
//  Created by John McCants on 2/7/22.
//

import Foundation
import UIKit

class WaitListView: UIView {
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for John to let you into the app. We'll send you a notification when you have been accepted. Please check back in later 😎"
        label.numberOfLines = 5
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        addSubview(messageLabel)
        messageLabel.centerX(inView: self)
        messageLabel.centerY(inView: self)
        messageLabel.anchor(width: 250, height: 400)
    }
}
