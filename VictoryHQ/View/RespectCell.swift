//
//  RespectCell.swift
//  VictoryHQ
//
//  Created by John McCants on 2/2/22.
//

import Foundation
import UIKit

class RespectCell: UITableViewCell {
    
    var respectNotification: RespectNotification? {
        didSet {
            configure()
        }
    }
    var delegate: RespectCellDelegate?
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setupView() {
        addSubview(label)
        label.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 20, paddingRight: 20, height: 40)
        label.centerY(inView: self)
        setupTapGesture()
    }
    
    func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.addGestureRecognizer(tap)
    }
    
    @objc func cellTapped() {
        delegate?.respectCellTapped(cell: self)
    }
    
    func configure() {
        guard let respectNotification = respectNotification else {
            return
        }

            let respectText : NSAttributedString = {
                var respectText = NSMutableAttributedString(string: "\(respectNotification.fullName)", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
                respectText.append(NSAttributedString(string: " respected your victory", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
                return respectText
            }()
        
        label.attributedText = respectText

    }
}

protocol RespectCellDelegate: class {
    func respectCellTapped(cell: RespectCell)
}
