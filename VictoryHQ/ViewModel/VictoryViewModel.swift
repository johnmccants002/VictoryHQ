//
//  VictoryViewModel.swift
//  VictoryHQ
//
//  Created by John McCants on 1/14/22.
//

import Foundation
import UIKit

struct VictoryViewModel {
    let victory: Victory

//    var profileImageUrl: URL? {
//        return victory.profileImageUrl
//    }

    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .weekOfMonth]
        formatter.maximumUnitCount = 1

        let now = Date()
        if formatter.string(from: Date(), to: now) == "0d" {
            return "Today"
        }
        return formatter.string(from: Date(), to: now) ?? "2m"
    }

    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: "\(victory.fullName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: "\(victory.victoryText)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        if let details = victory.victoryDetails, !details.isEmpty {
            let text = (" (Details 🧾)")
            let underlineAttriString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
            let photoRange = (text as NSString).range(of: " (Details 🧾)")
            underlineAttriString.addAttribute(.foregroundColor, value: UIColor.blue, range: photoRange)
            title.append(NSAttributedString(attributedString: underlineAttriString))
            return title
        } else
        if victory.victoryImageUrl != nil {
            let text = (" (Photo 🖼)")
            let underlineAttriString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.boldSystemFont(ofSize: 12)])
            let photoRange = (text as NSString).range(of: " (Photo 🖼)")
            underlineAttriString.addAttribute(.foregroundColor, value: UIColor.blue, range: photoRange)
            title.append(NSAttributedString(attributedString: underlineAttriString))
        }

        return title
    }

    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = victory.victoryText
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        let size = measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size
    }

}
