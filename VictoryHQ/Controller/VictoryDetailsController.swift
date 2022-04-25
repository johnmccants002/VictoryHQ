//
//  VictoryDetailsController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/17/22.
//

import Foundation
import UIKit
import SDWebImage
import ImageViewer_swift

class VictoryDetailsController: UIViewController {
    
    var victory: Victory?
    var userImage: UIImage?
    var detailsView: UIView?
    var victoryTextHeight : Int?
    var victoryDetailsHeight : Int?
    
    var detailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        return label
    }()
    
    var user: User?
    
    var userImageView = UIImageView()
    var justDetailsLabel = UILabel()
    var justDetailsImage : UIImage?
    var detailsImageView: UIImageView = UIImageView()
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewGesture()
        overrideUserInterfaceStyle = .light
        self.view.anchor(width: 500)
   
    }
    
    // MARK: - Helper Functions
    
    func setupViewGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.view.addGestureRecognizer(tap)
    }
    


    
    func setupView() {
        self.setProperHeight()
        self.view.backgroundColor = .clear
        let detailsView = UIView()
        detailsView.backgroundColor = .white
        detailsView.layer.cornerRadius = 500 / 10
        detailsView.layer.borderColor = UIColor.black.cgColor
        detailsView.layer.borderWidth = 2
        self.detailsView = detailsView
        self.view.addSubview(detailsView)
        detailsView.anchor(width: self.view.viewWidth - 40, height: 500)
        detailsView.centerX(inView: self.view)
        detailsView.centerY(inView: self.view)
        detailsView.addSubview(detailTitleLabel)
        detailsView.addSubview(userImageView)
        userImageView.anchor(top: detailsView.topAnchor, left: detailsView.leftAnchor, paddingTop: 40, paddingLeft: 20, width: 30, height: 30)
        userImageView.layer.cornerRadius = 30 / 2
        detailTitleLabel.anchor(top: userImageView.topAnchor, left: userImageView.rightAnchor, right: detailsView.rightAnchor, paddingTop: -5, paddingLeft: 5, paddingRight: 20, height: CGFloat(victoryTextHeight ?? 60))
        detailTitleLabel.numberOfLines = 4
        detailsView.addSubview(justDetailsLabel)
        
        guard let victory = victory else {
            return
        }
        
            if let userImage = userImage {
                userImageView.image = userImage
                userImageView.contentMode = .scaleAspectFill
                userImageView.clipsToBounds = true
               
            } else {
                userImageView.image = UIImage(named: "blank")
                
            }
        let title = NSMutableAttributedString(string: "\(victory.fullName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
            title.append(NSAttributedString(string: "\(victory.victoryText)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
            detailTitleLabel.attributedText = title
            if let url = victory.victoryImageUrl {
                self.detailsImageView.sd_setImage(with: url) { image, error, cache, url in
                    if image != nil {
                        self.setupWithImageView()
                    }
                }
            } else {
                guard let victoryDetailsHeight = victoryDetailsHeight else {
                    return
                }
                if let details = victory.victoryDetails {
                self.justDetailsLabel.text = details
                    justDetailsLabel.anchor(top: userImageView.bottomAnchor, left: detailTitleLabel.leftAnchor, right: detailTitleLabel.rightAnchor, paddingTop: 5, height: CGFloat(victoryDetailsHeight))
                justDetailsLabel.setDimensions(width: 300, height: CGFloat(victoryDetailsHeight))
                justDetailsLabel.numberOfLines = 7
                justDetailsLabel.textAlignment = .left
                justDetailsLabel.font = UIFont(name: "HelveticaNeue", size: 14)
                
                    
                
                    detailsView.anchor(height: CGFloat(victoryDetailsHeight) + 150)
                
            
            }
        }
        
        
    }
    
    func setupWithImageView() {
        if let detailsView = detailsView {
            detailsView.addSubview(detailsImageView)
            detailsImageView.anchor(top: detailTitleLabel.bottomAnchor, paddingTop: 10, width: 200, height: 200)
            detailsImageView.centerX(inView: detailsView)
            detailsImageView.layer.borderWidth = 1
            detailsImageView.layer.borderColor = UIColor.black.cgColor
            detailsImageView.setupImageViewer(options: [.theme(.dark)], from: nil)
            if let victory = victory {
                if let details = victory.victoryDetails {
                    justDetailsLabel.text = details
                }
                if let userImage = userImage {
                    userImageView.image = userImage
                    userImageView.contentMode = .scaleAspectFill
                    userImageView.clipsToBounds = true
                   
                } else {
                    userImageView.image = UIImage(named: "blank")
                    
                }
                let title = NSMutableAttributedString(string: "\(victory.fullName) ", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
                title.append(NSAttributedString(string: "\(victory.victoryText)", attributes: [.font: UIFont.systemFont(ofSize: 14)]))
                detailTitleLabel.attributedText = title
            }
            justDetailsLabel.font = UIFont(name: "HelveticaNeue", size: 14)
            justDetailsLabel.anchor(top: detailsImageView.bottomAnchor, width: 300, height: 150)
            justDetailsLabel.textAlignment = .left
            justDetailsLabel.centerX(inView: detailsView)
            justDetailsLabel.numberOfLines = 7

        }
        
    }
    
    func setProperHeight() {
        guard let victory = victory else {
            return
        }
        
        switch victory.victoryText.count {
        case Int.min..<100:
            victoryTextHeight = 40
        case Int.min..<200:
            victoryTextHeight = 60
        case Int.min..<300:
            victoryTextHeight = 80
        default:
            victoryTextHeight = 100
        }
        

        guard let victoryDetails = victory.victoryDetails else { return }
        
        switch victoryDetails.count {
        case Int.min..<100:
            victoryDetailsHeight = 60
        case Int.min..<200:
            victoryDetailsHeight = 100
        case Int.min..<300:
            victoryDetailsHeight = 140
        default:
            victoryDetailsHeight = 200
        }

    }

    
    // MARK: - Selectors
    
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
