//
//  NewVictoryController.swift
//  VictoryHQ
//
//  Created by John McCants on 1/7/22.
//

import Foundation
import UIKit

class NewVictoryController: UIViewController, UINavigationControllerDelegate {
    
    var currentUser: User?
    var victoryTextView: UITextView = {
        let tv = UITextView()
        tv.tintColor = .black
        tv.isScrollEnabled = false
        tv.autocorrectionType = .yes
        tv.text = ""
        tv.textAlignment = .center
        tv.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        return tv
    }()
    
    var detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.text = "Details"
        label.textAlignment = .center
        return label
    }()
    
    var victoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        label.text = "You"
        label.textAlignment = .center
        return label
    }()
    
    var addPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Photo"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(addPhotoTapped))
        label.addGestureRecognizer(recognizer)
        return label
    }()
    
    var detailTextView: UITextView = {
        let tv = UITextView()
        tv.tintColor = .black
        tv.autocapitalizationType = .none
        tv.isScrollEnabled = false
        tv.autocorrectionType = .yes
        tv.textAlignment = .center
        tv.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        return tv
    }()
    
    var victoryImageView: UIImageView = {
        let iv = UIImageView()
        
        return iv
    }()
    
    var postButtonKeyboard: UIBarButtonItem {
        let nextButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(self.postButtonPressed(_:)))
        nextButton.width = self.view.viewWidth
        nextButton.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
        nextButton.tintColor = UIColor.white
        return nextButton
    }
    var keyboardToolBar: UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = false
//        keyboardToolbar.barTintColor = UIColor.systemOrange
        keyboardToolbar.items = [self.postButtonKeyboard]
        keyboardToolbar.setBackgroundImage(UIImage(named: "toolbar5"), forToolbarPosition: .bottom, barMetrics: .default)
//        keyboardToolbar.layer.opacity = 0.65
        keyboardToolbar.layer.borderColor = UIColor.white.cgColor
        return keyboardToolbar
    }
    
    var addPhotoButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 40, weight: .medium, scale: .default)
        let image = UIImage(systemName: "photo", withConfiguration: config)
        button.addTarget(self, action: #selector(addPhotoTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.textColor = .black
        return button
    }()
    
    var addDetailsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Details", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(addDetailsTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.setBackgroundImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var xButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "xButton1"), for: .normal)
        button.setDimensions(width: 15, height: 15)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(xButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupLeftBarItem()
        
     
    }
    

    
    // MARK: - Helper Functions
    
    func configureUI() {
        self.view.backgroundColor = .white
        configureNavigationBar(title: "New Victory", prefersLargeTitles: false)
        view.addSubview(victoryTextView)
        view.addSubview(victoryLabel)
        victoryLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
        victoryTextView.anchor(top: victoryLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: 100)
        victoryTextView.inputAccessoryView = keyboardToolBar
        victoryTextView.inputAccessoryView?.isHidden = true
        victoryTextView.inputAccessoryView?.layer.opacity = 0
        self.keyboardToolBar.isHidden = true
        self.postButtonKeyboard.isEnabled = false
        victoryTextView.delegate = self
        victoryTextView.becomeFirstResponder()
        victoryTextView.autocapitalizationType = .none
        
        view.addSubview(detailTextView)
        detailTextView.anchor(top: victoryLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, height: 100)
        detailTextView.isHidden = true
        detailTextView.autocapitalizationType = .none
        detailTextView.inputAccessoryView = keyboardToolBar
        detailTextView.inputAccessoryView?.isHidden = true
        detailTextView.inputAccessoryView?.layer.opacity = 0
        

        view.addSubview(detailsLabel)
        detailsLabel.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40)
        detailsLabel.isHidden = true
        
        view.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: detailTextView.bottomAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingRight: 20, width: 70, height: 40)
        addPhotoButton.isHidden = true
        
        view.addSubview(addPhotoLabel)
        addPhotoLabel.anchor(top: addPhotoButton.bottomAnchor, left: addPhotoButton.leftAnchor, right: addPhotoButton.rightAnchor, paddingRight: 10, width: 70, height: 20)
        addPhotoLabel.isHidden = true
        
        
        view.addSubview(addDetailsButton)
        addDetailsButton.anchor(top: victoryTextView.bottomAnchor, right: self.view.rightAnchor, paddingTop: 10, paddingRight: 20, width: 70, height: 40)
        
        
        view.addSubview(backButton)
        backButton.anchor(top: detailsLabel.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 15, width: 20, height: 20)
        backButton.isHidden = true
        overrideUserInterfaceStyle = .light
        
        view.addSubview(xButton)
        xButton.isHidden = true
        xButton.anchor(top: addPhotoButton.topAnchor, right: addPhotoButton.rightAnchor, paddingTop: -5)
        
        self.navigationController?.navigationBar.setGradientBackground(colors: [.systemPurple, .systemOrange], startPoint: .topLeft, endPoint: .bottomRight)
        
    }
    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        var bounds =  self.keyboardToolBar.bounds
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)

        self.keyboardToolBar.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupLeftBarItem() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissController))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Selectors
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func postButtonPressed(_ : UIButton) {
        self.showLoader(true, withText: "Uploading Victory")
        sendInfoToDB()

    }
    
    @objc func uploadVictory() {
        guard let currentUser = currentUser else {
            return
        }
        guard let victoryText = victoryTextView.text else { return }
        var newVictory = NewVictory(victoryText: victoryText)
        
        if let victoryDetails = detailTextView.text, !victoryDetails.isEmpty {
            newVictory.victoryDetails = victoryDetails
        }
        
        if let victoryImage = victoryImageView.image {
            newVictory.victoryImage = victoryImage
        }
        VictoryService.shared.uploadVictory(user: currentUser, victoryText: newVictory.victoryText, victoryImage: newVictory.victoryImage, victoryDetails: newVictory.victoryDetails) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            self.showLoader(false, withText: "Uploading Victory")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchVictories"), object: nil)
            self.dismiss(animated: true)
            
        }
        
    }
    
    func sendInfoToDB() {
        let _ : Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.uploadVictory), userInfo: nil, repeats: false)
        
    }
    
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func addPhotoTapped() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
              alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                  self.openCamera()
              }))

              alert.addAction(UIAlertAction(title: "Photos", style: .default, handler: { _ in
                  self.openGallery()
              }))

              alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

              self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func addDetailsTapped(_ : UIButton) {
        self.victoryLabel.text = "Details"
        self.detailTextView.isHidden = false
        self.addDetailsButton.isHidden = true
        self.backButton.isHidden = false
        self.addPhotoButton.isHidden = false
        self.victoryTextView.resignFirstResponder()
        self.victoryTextView.isHidden = true
        self.addPhotoLabel.isHidden = false
        self.detailTextView.becomeFirstResponder()
    }
    
    @objc func backButtonTapped() {
        self.detailTextView.isHidden = true
        self.victoryTextView.isHidden = false
        self.victoryTextView.slideIn()
        self.backButton.isHidden = true
        self.victoryLabel.text = "You"
        self.addPhotoButton.isHidden = true
        self.addDetailsButton.isHidden = false
        self.addPhotoLabel.isHidden = true
        self.detailTextView.resignFirstResponder()
        self.victoryTextView.becomeFirstResponder()
        self.xButton.isHidden = true
    }
    
    @objc func xButtonTapped() {
        self.addPhotoButton.setImage(nil, for: .normal)
        self.victoryImageView.image = nil
        self.xButton.isHidden = true
        self.addPhotoLabel.isHidden = false
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 40, weight: .medium, scale: .default)
        let image = UIImage(systemName: "photo", withConfiguration: config)
        self.addPhotoButton.setImage(image, for: .normal)
    }
}

extension NewVictoryController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case victoryTextView:
            print("in case victory text view")
            if textView.text.count < 1 {
                self.keyboardToolBar.isHidden = true
                self.postButtonKeyboard.isEnabled = false
                self.victoryTextView.inputAccessoryView?.isHidden = true
                self.detailTextView.inputAccessoryView?.isHidden = true
               
            } else {
                print("in greater than one")
                self.keyboardToolBar.isHidden = false
                self.postButtonKeyboard.isEnabled = true
                self.victoryTextView.inputAccessoryView?.isHidden = false
                self.detailTextView.inputAccessoryView?.isHidden = false
                UIView.animate(withDuration: 0.10) {
                    self.victoryTextView.inputAccessoryView?.layer.opacity = 1
                    self.detailTextView.inputAccessoryView?.layer.opacity = 1
                }

                
            }
         
            
            if textView.text.count > 1 {
            
                
            }
        default: break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return textView.text.count + (text.count - range.length) <= 150
       
    }
}

extension NewVictoryController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("image picked")
            addPhotoButton.setImage(pickedImage, for: .normal)
            victoryImageView.image = pickedImage
            self.addPhotoButton.imageView?.contentMode = .scaleAspectFit
            xButton.isHidden = false
            addPhotoLabel.isHidden = true

        }
        

        dismiss(animated: true, completion: nil)
    }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
}
