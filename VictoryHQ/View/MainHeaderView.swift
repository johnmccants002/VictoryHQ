//
//  MainHeaderView.swift
//  VictoryHQ
//
//  Created by John McCants on 1/8/22.
//

import Foundation
import UIKit
import AVFoundation

class MainHeaderView: UICollectionReusableView {
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
       
        return view
    }()
    
    private let goalView: UIView = {
       let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 120)
        view.backgroundColor = .white
        return view
    }()
    
    var count : Int? {
        didSet {
            setupCurrentCount()
        }
    }
    
    var goalCount: Int? {
        didSet {
            setupGoalCount()
        }
    }
    
    var progressCount: Int?
    
    var yesterdayCount: Int? {
        didSet {
            calculateNumber()
        }
    }
    
    var dayBeforeCount: Int? {
        didSet {
            calculateNumber()
        }
    }
    
    private let nextGoalLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        return label
    }()
    
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let differenceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(goalView)
        goalView.addSubview(nextGoalLabel)
        goalView.addSubview(currentLabel)
        goalView.anchor(width: 200, height: 120)
        goalView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        nextGoalLabel.centerX(inView: goalView)
        nextGoalLabel.anchor(top: goalView.topAnchor, paddingTop: 8, height: 30)
        currentLabel.centerX(inView: goalView)
        currentLabel.anchor(top: nextGoalLabel.bottomAnchor, paddingTop: 8, height: 30)
        goalView.addSubview(differenceLabel)
        differenceLabel.anchor(top: currentLabel.bottomAnchor, paddingTop: 8, height: 30)
        differenceLabel.centerX(inView: goalView)
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.75
        layer.masksToBounds = false
        
        
    }
    
    func setupCurrentCount() {
        guard let count = count else {
            return
        }

        currentLabel.text = "Current: \(count) Victories"
        
    }
    
    func setupGoalCount() {
        guard let goalCount = goalCount else {
            return
        }
        nextGoalLabel.text = "Group Goal: \(goalCount) Victories"
    }
    
    func calculateNumber() {
        
        if let yesterdayCount = yesterdayCount, let dayBeforeCount = dayBeforeCount {
            let title = NSMutableAttributedString(string: "Progress: ", attributes: [.font: UIFont.systemFont(ofSize: 16)])
            let progressCount = yesterdayCount - dayBeforeCount
            self.progressCount = progressCount
            if progressCount > 0 {
                title.append(NSAttributedString(string: "+\(progressCount)", attributes: [.foregroundColor: UIColor.systemGreen, .font: UIFont.boldSystemFont(ofSize: 16)]))
                differenceLabel.attributedText = title
    
            } else if progressCount < 0 {
                title.append(NSAttributedString(string: "\(progressCount)", attributes: [.foregroundColor: UIColor.systemRed, .font: UIFont.systemFont(ofSize: 16)]))
                differenceLabel.attributedText = title
              
            } else {
                title.append(NSAttributedString(string: "+\(progressCount)", attributes: [.foregroundColor: UIColor.systemBlue, .font: UIFont.systemFont(ofSize: 16)]))
                differenceLabel.attributedText = title
             
            }
        }
        
        
     
    }
    

    



    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
