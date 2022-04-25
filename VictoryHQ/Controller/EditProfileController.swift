//
//  EditProfileController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/13/22.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
import FirebaseAuth

class EditProfileController: UIViewController, UINavigationControllerDelegate, UITabBarDelegate {
    
    var signOutDelegate: SignOutDelegate?
    var user: User?
    var requestUser: User?
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "Charmander")
        return iv

    }()
    
    let saveButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveButton = UIBarButtonItem(customView: button)
     
        //        let cb = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
//        cb.tag = 1
        return saveButton
    }()
    
    private let aboutTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = true
        tv.isUserInteractionEnabled = true
        tv.isSelectable = true
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textAlignment = .left
        return tv
    }()
    
    private let instagramLabel: UILabel = {
       let lb = UILabel()
        lb.text = "Instagram"
        lb.font = UIFont(name: "Helvetica-Medium", size: 14)
    
        return lb
    }()
    
    private let instagramTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Helvetica-Medium", size: 14)
        tf.autocorrectionType = .no
        tf.placeholder = "Instagram Username"
        tf.borderStyle = .roundedRect
        
        return tf
    }()
    
    private let twitterLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Twitter"
        lb.font = UIFont(name: "Helvetica-Medium", size: 14)
        return lb
    }()
    
    private let twitterTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont(name: "Helvetica-Medium", size: 14)
        tf.autocorrectionType = .no
        tf.placeholder = "Twitter Username"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    
    var logoutButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.textColor = .red
        button.setDimensions(width: 200, height: 50)
        button.layer.cornerRadius = 50 / 2
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(profileImageViewTapped), for: .touchUpInside)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
        
    }()
    
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.font = UIFont(name: "HelveticaNeue-bold", size: 16)
        
        return label
        
    }()

    
    private let imagePicker = UIImagePickerController()
    
    private var changedText: String?
    private var changedImage: UIImage?
    private var instagramHandle: String?
    private var twitterHandle: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        configureNavigationBar(title: "Edit Profile", prefersLargeTitles: false)
        configureUI()
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        profileImageView.centerX(inView: self.view)
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100/2
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: profileImageView.bottomAnchor, paddingTop: 5)
        addPhotoButton.centerX(inView: profileImageView)
        instagramTextField.delegate = self
        twitterTextField.delegate = self
        aboutTextView.delegate = self
        imagePicker.delegate = self
        setupStackView()
        setUserInformation()
    }
    
    override func viewWillLayoutSubviews() {
        setupRightBarButonItem()
    }
    
    func setupRightBarButonItem() {
        self.navigationItem.setRightBarButton(self.saveButton, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func sendInfoToDB() {
        let _ : Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProfileInfo), userInfo: nil, repeats: false)
        
    }

    
    func setUserInformation() {
        UserService.shared.fetchCurrentUser { user in
            if let user = user {
                self.user = user
                if let twitterHandle = user.twitterHandle, twitterHandle != "" {
                    self.twitterTextField.text = twitterHandle
                }
                
                if let instagramHandle = user.instagramHandle, instagramHandle != "" {
                    self.instagramTextField.text = instagramHandle
                }
                self.twitterHandle = user.twitterHandle
                self.instagramHandle = user.instagramHandle
                
                self.aboutTextView.text = user.aboutText
                if let url = user.profileImageUrl {
                    self.profileImageView.sd_setImage(with: url)
                } else {
                    self.profileImageView.image = UIImage(named: "blank")
                }
             
            } else {
                self.setRequestUserInformation()
            }
        }
    }
    
    func setRequestUserInformation() {
        UserService.shared.fetchUserFromRequests { user in
            if let user = user {
                self.requestUser = user
                if let twitterHandle = user.twitterHandle, twitterHandle != "" {
                    self.twitterTextField.text = twitterHandle
                }
                
                if let instagramHandle = user.instagramHandle, instagramHandle != "" {
                    self.instagramTextField.text = instagramHandle
                }
                self.twitterHandle = user.twitterHandle
                self.instagramHandle = user.instagramHandle
                
                self.aboutTextView.text = user.aboutText
                if let url = user.profileImageUrl {
                    self.profileImageView.sd_setImage(with: url)
                } else {
                    self.profileImageView.image = UIImage(named: "blank")
                }
             
            }
        }
    }
    
    
    @objc func saveButtonTapped() {
        print("save button tapped")
     sendInfoToDB()
    }
    
    @objc func updateProfileInfo() {
        self.showLoader(true, withText: "Updating Profile Information")
        if let requestUser = requestUser {
            UserService.shared.saveRequestUserInfo(profileImage: changedImage, aboutText: changedText, instagramHandle: instagramHandle, twitterHandle: twitterHandle) {
                self.showLoader(false, withText: "Updating Profile Information")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchUserInformation"), object: nil)
            }
        } else {
            UserService.shared.saveProfileInfo(profileImage: changedImage, aboutText: changedText, instagramHandle: instagramHandle, twitterHandle: twitterHandle) {
                self.showLoader(false, withText: "Updating Profile Information")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchUserInformation"), object: nil)
            }
        }
    }
    
    
    func setupStackView() {
        let aboutStack = UIStackView(arrangedSubviews: [aboutLabel, aboutTextView])
        view.addSubview(aboutStack)
        aboutStack.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 150)
     
        aboutStack.axis = .vertical
        let stack = UIStackView(arrangedSubviews: [instagramLabel, instagramTextField, twitterLabel, twitterTextField])
        view.addSubview(stack)
        stack.anchor(top: aboutStack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 150)
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        
        view.addSubview(logoutButton)
        logoutButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        logoutButton.centerX(inView: stack)
    }
    
    @objc func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            signOutDelegate?.signOut()
            self.navigationController?.popViewController(animated: true)
        } catch  {
            print("DEBUG: Error signing out...")
        }
        
    }
    

    
    @objc func profileImageViewTapped() {
        self.present(imagePicker, animated: true) {
        }
        
    }
    
}

extension EditProfileController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.changedText = textView.text
    }
}

extension EditProfileController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = pickedImage
            self.changedImage = pickedImage
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension EditProfileController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case instagramTextField: self.instagramHandle = textField.text
        case twitterTextField: self.twitterHandle = textField.text
        default: break
        }
    }
}
