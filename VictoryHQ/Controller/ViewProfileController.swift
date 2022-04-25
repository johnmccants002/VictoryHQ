//
//  ViewProfileController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/13/22.
//

import Foundation
import UIKit

class ViewProfileController: UIViewController {
    
    var uid: String?
    var titleString: String?
    
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
    
    var biotTextView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textColor = .black

    
        return tv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Charmander"
        return label
    }()
    
    let fullnameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .center

       return label
    }()
    
    var instagramButton : UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemPurple
        button.layer.borderWidth = 0.75
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Instagram", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleInstagramTapped), for: .touchUpInside)
 
        return button
    }()
    
    var twitterButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .twitterBlue
        button.layer.borderWidth = 0.75
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Twitter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleTwitterTapped), for: .touchUpInside)

     
        
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
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        configureUI()
        fetchUser()
//        setGradientBackground(colorTop: .systemOrange, colorBottom: .systemPurple)
    }

    
    
    // MARK: - Helpers

    
    func configureUI() {
        profileImageView.setDimensions(width: 200, height: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        self.view.addSubview(profileImageView)
        profileImageView.centerX(inView: self.view)
        profileImageView.anchor(top: self.view.topAnchor, paddingTop: 96)
        

        
        self.view.addSubview(stack)
        stack.anchor(top: profileImageView.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, paddingTop: 16, paddingLeft: 20, paddingRight: 20)
        
        self.view.addSubview(biotTextView)
        biotTextView.anchor(top: stack.bottomAnchor, paddingTop: 20, width: self.view.viewWidth - 80)
        biotTextView.centerX(inView: self.view)
  
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    func populateUserData() {
        guard let user = user else {
            return
        }
        fullnameLabel.text = user.fullName
        usernameLabel.text = user.username
    
        if let url = user.profileImageUrl {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        if let twitterHandle = user.twitterHandle, twitterHandle != "" {
            buttons.append(twitterButton)
        }
        
        if let instagramHandle = user.instagramHandle, instagramHandle != "" {
            buttons.append(instagramButton)
        }
        
        if let bioText = user.aboutText {
            biotTextView.text = bioText
        }
        for button in buttons {
            button.layer.cornerRadius = 35 / 2
            button.setWidth(width: 180)
            self.stack.addArrangedSubview(button)
        }
        
        stack.isUserInteractionEnabled = true
        self.reloadInputViews()
        

    }
    
    @objc func handleDismissal() {
        delegate?.dismissController()
    }
    
    @objc func handleTwitterTapped() {
        if let user = user, let twitterUsername = user.twitterHandle {
        print("twitter button tapped profile header")
        let appURL = URL(string: "twitter://user?screen_name=\(twitterUsername)")!
                let application = UIApplication.shared

                if application.canOpenURL(appURL)
                {
                    application.open(appURL)
                }
                else
                {
                    let webURL = URL(string: "https://twitter.com/\(twitterUsername)")!
                    application.open(webURL)
                }
        }
    
        
    }
    
    @objc func handleInstagramTapped() {

        if let user = user, let instagramUsername = user.instagramHandle {
          let appURL = URL(string: "instagram://user?username=\(instagramUsername)")!
                  let application = UIApplication.shared

                  if application.canOpenURL(appURL)
                  {
                      application.open(appURL)
                  }
                  else
                  {
                      let webURL = URL(string: "https://instagram.com/\(instagramUsername)")!
                      application.open(webURL)
                  }
        }
        
        
    }

    
//    var height = 380
//    var user: User?

//    let gradient = CAGradientLayer()
//    private let profileImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.clipsToBounds = true
//        iv.backgroundColor = .lightGray
//        iv.layer.borderColor = UIColor.white.cgColor
//        iv.layer.borderWidth = 4
//        iv.isUserInteractionEnabled = true
//        iv.image = UIImage(named: "Charmander")
//        return iv
//    }()
//
//    private let fullnameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .center
//        return label
//    }()
//
//    private let aboutTextView: UITextView = {
//        let tv = UITextView()
//        tv.isEditable = true
//        tv.isUserInteractionEnabled = true
//        tv.isSelectable = true
//        tv.textAlignment = .center
//        tv.isEditable = false
//        return tv
//    }()
//
//    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        fetchUser()
//
//    }
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
//
//
//    func updateViews() {
//
//        self.view.addSubview(headerView)
//        headerView.anchor(top: self.view.topAnchor)
//        headerView.centerX(inView: self.view)
//        headerView.usernameLabel.textColor = .black
//        headerView.fullnameLabel.textColor = .black
//        headerView.isUserInteractionEnabled = true
//
//
//
//    }
//
//
//
    func fetchUser() {
        guard let uid = uid else {
            return
        }

            UserService.shared.fetchUser(uid: uid) { user in
                self.user = user
  


                if let user = user {
                    self.title = user.fullName
                }

            }

        

    }
    
    
}


protocol SocialAppButtonsDelegate: NSObject {
    func instagramTapped(user: User?)
    func twitterTapped(user: User?)
}



