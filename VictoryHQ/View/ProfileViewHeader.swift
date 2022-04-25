//
//  ProfileViewHeader.swift
//  VictoryHQ
//
//  Created by John McCants on 1/8/22.
//

import Foundation
import UIKit

protocol ProfileHeaderDelegate: class {
    func dismissController()
}

class ProfileHeader: UIView {
    
    // MARK: - Properties
    
    var socialAppDelegate: SocialAppButtonsDelegate?
    
    var user: User? {
        didSet {
            populateUserData()
        }
    }
    let gradient = CAGradientLayer()
    weak var delegate: ProfileHeaderDelegate?

    private let profileImageView: UIImageView = {
     let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
    
    return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Charmander"
        return label
    }()
    
    let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center

       return label
    }()
    
    var instagramButton : UIButton = {
        var button = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 0.75
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Instagram", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(ProfileHeader.self, action: #selector(handleInstagramTapped), for: .touchUpInside)
 
        return button
    }()
    
    var twitterButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 0.75
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Twitter", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(ProfileHeader.self, action: #selector(handleTwitterTapped), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTwitterTapped))
        button.addGestureRecognizer(tap)
        return button
    }()
    
   private lazy var stack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [self.fullnameLabel, self.usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    var buttons = [UIButton]()

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setGradientBackground(colorTop: .systemPurple, colorBottom: .systemOrange)
        configureUI()
        isUserInteractionEnabled = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleInstagramTapped))
        self.addGestureRecognizer(tap)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Helpers
    
    func configureGradientLayer() {
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemOrange.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
    }
    
    func configureUI() {
        profileImageView.setDimensions(width: 200, height: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor, paddingTop: 96)
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleInstagramTapped))
        self.addGestureRecognizer(tap)
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        gradient.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
    }
    
    func populateUserData() {
        guard let user = user else {
            return
        }
        fullnameLabel.text = user.fullName
        if let username = user.username {
            usernameLabel.text = "@\(username)"
        }
    
        if let url = user.profileImageUrl {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        for button in buttons {
    
            self.stack.addArrangedSubview(button)
        }
        
        stack.isUserInteractionEnabled = true
        
       
        print("This is the height: \(self.viewHeight)")
        self.reloadInputViews()
    }
    
    @objc func handleDismissal() {
        delegate?.dismissController()
    }
    
    @objc func handleTwitterTapped() {
        guard let user = user else {
            return
        }

        socialAppDelegate?.twitterTapped(user: user)
        
    }
    
    @objc func handleInstagramTapped() {
        guard let user = user else {
            return
        }
        socialAppDelegate?.instagramTapped(user: user)
        
    }
    
    
}
