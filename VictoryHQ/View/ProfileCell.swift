//
//  ProfileCell.swift
//  VictoryHQ
//
//  Created by John McCants on 1/12/22.
//

import Foundation
import UIKit

class ProfileCell: UITableViewCell {
    

    var adminViewModel: AdminViewModel? {
        didSet {
            configureAdmin()
        }
    }
    
    var viewModel: ProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var iconView: UIView = {
        let view = UIView()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.centerY(inView: view)
        
        view.backgroundColor = .systemPurple
        view.setDimensions(width: 40, height: 40)
        view.layer.cornerRadius = 40 / 2
        return view
    }()
    
    private var iconImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 28, height: 28)
        iv.tintColor = .white
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        iconImage.image = UIImage(systemName: viewModel.iconImageName)
        titleLabel.text = viewModel.description
    }
    
    func configureAdmin() {
        guard let adminViewModel = adminViewModel else {
            return
        }
        iconImage.image = UIImage(systemName: adminViewModel.iconImageName)
        titleLabel.text = adminViewModel.description
    }
}
