//
//  VictoryCell.swift
//  VictoryHQ
//
//  Created by John McCants on 1/8/22.
//

import Foundation
import UIKit
import SDWebImage
import ImageViewer_swift

class VictoryCell: UICollectionViewCell {
    
    var row: Int?
    
    var user : User? {
        didSet {
            configure()
        }
    }
    
    var token: String?
    
    var victory: Victory? {
        didSet {
            setupRespectButton()
        }
    }
    
    
    var delegate: VictoryCellDelegate?
    
    var respectLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Respect"
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        label.textColor = .lightGray
        return label
    }()
    
    var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
       return imageView
    }()
    
    var fullNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Charmander Jones"
        label.font = UIFont.systemFont(ofSize: 10)
      return label
    }()
    
    var victoryLabel: UILabel = {
        let label = UILabel()
        label.text = "ran 4 miles"
        label.numberOfLines = 6
        return label
    }()
    
    var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    var respectButton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(respectButtonTapped), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(named: "Fistbump1"), for: .normal)
       return button
    }()
    
    var victoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 30, height: 30)
        return iv
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        addSubview(victoryLabel)
        addSubview(profileImageView)
        addSubview(respectButton)
        addSubview(respectLabel)
        addSubview(timestampLabel)
        profileImageView.layer.cornerRadius = profileImageView.viewHeight / 2
        timestampLabel.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 10, paddingRight: 15, width: 50, height: 25)
        
        
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 10, paddingLeft: 10, width: 40, height: 40)
        
       
        victoryLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, paddingTop: 12, paddingLeft: 8, width: 250)
        
        victoryLabel.heightAnchor.constraint(greaterThanOrEqualTo: victoryLabel.heightAnchor, multiplier: 0, constant: 30).isActive = true
        
        respectButton.anchor(bottom: self.bottomAnchor, right: self.rightAnchor, paddingBottom: 20, paddingRight: 20)
        
        respectButton.setDimensions(width: 40, height: 40)
       
        
        respectLabel.anchor(top: respectButton.bottomAnchor, paddingTop: 0)
        respectLabel.centerX(inView: respectButton)
        respectLabel.setHeight(height: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(profilePicTapped))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.75
        layer.masksToBounds = false
                
        
        
    }
    
    func fetchUserImage() {
        guard let victory = victory else {
            return
        }
        UserService.shared.fetchProfileImage(uid: victory.uid) { victoryImageUrl in
            self.profileImageView.sd_setImage(with: victoryImageUrl)
        }
    }
    
    
    func configure() {
        guard let victory = victory else { return }
        let viewModel = VictoryViewModel(victory: victory)
        contentView.isUserInteractionEnabled = true
        victoryLabel.attributedText = viewModel.userInfoText
        
        if let dateString = victory.dateString {
            timestampLabel.text = dateString
        } else {
            timestampLabel.text = viewModel.timestamp
        }
        
        fetchUserImage()
        if let victoryImageUrl = victory.victoryImageUrl {
            victoryImageView.sd_setImage(with: victoryImageUrl) { img, err, cache, url in
                self.victoryImageView.image = img
                self.addSubview(self.victoryImageView)
                self.victoryImageView.centerX(inView: self)
                self.victoryImageView.centerY(inView: self)
                self.victoryImageView.isHidden = true
                self.victoryImageView.setupImageViewer(options: [.theme(.dark)], from: nil)
            }
        } else {
//            self.victoryImageView.image = UIImage(named: "Charmander")
        }
        
        setupLongPress()
        setupRespectButton()
        fetchToken()
        setupLabelTapJustImageView()
    
        
    }
    
    func fetchToken() {
        guard let victory = victory else {
            return
        }

        UserService.shared.fetchUserToken(uid: victory.uid) { token in
            self.token = token
        }
    }
    
    func setupLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(deleteVictory))
        self.addGestureRecognizer(longPress)
    }
    
    @objc func deleteVictory() {
        delegate?.longPress(cell: self)
    }
    
    func animatedImages(for name: String) -> [UIImage] {
        var i = 1
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    
    
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        guard let postText = victoryLabel.text else { return }
        guard let victory = victory else { return }
        
        if let details = victory.victoryDetails {
            delegate?.detailsTapped(cell: self)
        } else {
            if let victoryImageUrl = victory.victoryImageUrl {
                print("image tapped")
                
                self.victoryImageView.showImageViewerWithoutTap(iv: self.victoryImageView)
            }
        }
    }
    
    func setupLabelTapJustImageView() {
        guard let victory = victory else { return }
            let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
            victoryLabel.isUserInteractionEnabled = true
            self.contentView.isUserInteractionEnabled = true
            
            victoryLabel.addGestureRecognizer(tapAction)
    }
    
    @objc func respectButtonTapped() {
        guard let victory = victory else {
            return
        }
        
        if victory.didRespect == false {
            respectVictory()
        } else if victory.didRespect == true {
            unrespectVictory()
        }
        
    }
    
    @objc func profilePicTapped() {
        delegate?.profilePicTapped(cell: self)
    }
    
    func moreButtonTapped() {
        delegate?.moreButtonTapped(cell: self)
    }
    
    func detailsTapped() {
        delegate?.detailsTapped(cell: self)
    }
    
    func respectVictory() {
        self.respectButton.imageView!.animationImages = animatedImages(for: "Fistbump")
        self.respectButton.imageView!.animationDuration = 0.2
        self.respectButton.imageView!.animationRepeatCount = 1
        self.respectButton.imageView!.startAnimating()
        if self.victory?.didRespect == false {
            self.respectButton.setImage(UIImage(named: "Fistbump4"), for: .normal)
            self.respectLabel.textColor = .black
        }
        delegate?.respectTapped(cell: self)
        guard var didRespect = self.victory?.didRespect else { return }
        didRespect.toggle()
    }
    
    func unrespectVictory() {
        self.respectButton.setImage(UIImage(named:"Fistbump1"), for: .normal)
        self.respectLabel.textColor = .lightGray
        delegate?.unrespectTapped(cell: self)
        guard var didRespect = self.victory?.didRespect else { return }
        didRespect.toggle()
    }
    
    func setupRespectButton() {
        guard let victory = victory, let didRespect = victory.didRespect else {
            return
        }
        let imageName = didRespect ? "Fistbump4" : "Fistbump1"
        respectButton.setImage(UIImage(named: imageName), for: .normal)
        let labelColor = didRespect ?  UIColor.black : UIColor.lightGray
        
        respectLabel.textColor = labelColor
        
      
    }
    
    func setupTaggedUser() {
        
    }
}

protocol VictoryCellDelegate {
    func detailsTapped(cell: VictoryCell)
    func moreButtonTapped(cell: VictoryCell)
    func longPress(cell: VictoryCell)
    func respectTapped(cell: VictoryCell)
    func profilePicTapped(cell: VictoryCell)
    func unrespectTapped(cell: VictoryCell)
}
