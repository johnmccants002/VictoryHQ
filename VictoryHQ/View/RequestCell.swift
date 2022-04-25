//
//  RequestCell.swift
//  VictoryHQ
//
//  Created by John McCants on 2/5/22.
//

import Foundation
import UIKit


class RequestCell: UITableViewCell {
    
    var nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    var profileImageView = UIImageView()
    var acceptButton : UIButton = {
        var button = UIButton()
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(acceptTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 35 / 2
        return button
    }()
    var denyButton : UIButton = {
        var button = UIButton()
        button.setTitle("Deny", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(denyTapped), for: .touchUpInside)
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 35 / 2
        return button
    }()
    var delegate : RequestCellDelegate?
    var user: User? {
        didSet {
            setupUserData()
            fetchToken()
        }
    }
    var token: String?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func fetchToken() {
        guard let user = user else { return }
        UserService.shared.fetchUserToken(uid: user.uid) { token in
            self.token = token
        }
    }
    
    func updateUI() {
        addSubview(nameLabel)
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 20, paddingLeft: 10)
        profileImageView.setDimensions(width: 30, height: 30)
        nameLabel.centerY(inView: profileImageView)
        nameLabel.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 10, height: 30)

        profileImageView.setRounded()
        
   
        addSubview(acceptButton)
        addSubview(denyButton)

        acceptButton.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 50, width: 70, height: 35)
        denyButton.anchor(top: profileImageView.bottomAnchor, right: rightAnchor, paddingTop: 10, paddingRight: 50, width: 70, height: 35)


        self.layer.addBorder(edge: .bottom, color: .systemGray4, thickness: 0.25)
      
    }
    
    func setupUserData() {
        guard let user = user else { return }
        nameLabel.text = "\(user.fullName) wants to join the network"
        
        guard let url = user.profileImageUrl else {
            profileImageView.image = UIImage(named: "Charmander")
            return }
        profileImageView.sd_setImage(with: url, completed: nil)
    }
    
    @objc func acceptTapped() {
        delegate?.acceptTapped(cell: self)
    }
    
    @objc func denyTapped() {
        delegate?.denyTapped(cell: self)
    }
}

protocol RequestCellDelegate: AnyObject {
    func acceptTapped(cell: RequestCell)
    func denyTapped(cell: RequestCell)
}
