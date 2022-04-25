//
//  UserService.swift
//  VictoryHQ
//
//  Created by John McCants on 1/14/22.
//

import Foundation
import UIKit
import Firebase

struct UserService {
    
    static let shared = UserService()
    
    func saveProfileInfo(profileImage: UIImage?, aboutText: String?, instagramHandle: String?, twitterHandle: String?, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var dict = [String: Any]()
        if let aboutText = aboutText {
            dict["aboutText"] = aboutText
        }
        
        if let instagramHandle = instagramHandle {
            dict["instagram"] = instagramHandle
        }
        
        if let twitterHandle = twitterHandle {
            dict["twitter"] = twitterHandle
        }
        
        if let profileImage = profileImage {
            updateUserImage(image: profileImage) { error, ref in
                if let error = error {
                    print("Error updating user image: \(error.localizedDescription)")
                }
                REF_USERS.child(uid).updateChildValues(dict)
                completion()
            }
        } else {
            REF_USERS.child(uid).updateChildValues(dict)
            completion()
        }
 
    }
    
    func saveRequestUserInfo(profileImage: UIImage?, aboutText: String?, instagramHandle: String?, twitterHandle: String?, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var dict = [String: Any]()
        if let aboutText = aboutText {
            dict["aboutText"] = aboutText
        }
        
        if let instagramHandle = instagramHandle {
            dict["instagram"] = instagramHandle
        }
        
        if let twitterHandle = twitterHandle {
            dict["twitter"] = twitterHandle
        }
        
        if let profileImage = profileImage {
            updateRequestUserImage(image: profileImage) { error, ref in
                if let error = error {
                    print("Error updating user image: \(error.localizedDescription)")
                }
                REF_USER_REQUESTS.child(uid).updateChildValues(dict)
                completion()
            }
        } else {
            REF_USER_REQUESTS.child(uid).updateChildValues(dict)
            completion()
        }
 
    }
    
    func updateUserImage(image: UIImage, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let compressedImage = image.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(compressedImage, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: Error putting image data to database \(error)")
            }
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let values = ["profileImageUrl": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
            }
        }
    }
    
    func updateRequestUserImage(image: UIImage, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let compressedImage = image.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(compressedImage, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: Error putting image data to database \(error)")
            }
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let values = ["profileImageUrl": profileImageUrl]
                
                REF_USER_REQUESTS.child(uid).updateChildValues(values, withCompletionBlock: completion)
            }
        }
    }
    
    func fetchCurrentUser(completion: @escaping(User?) -> Void) {
    
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return }
        print("Current User Uid: \(uid)")
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                completion(nil)
                return}
            
            let currentUser = User(uid: uid, dict: dict)
            
            completion(currentUser)
        }
    }
    
    func fetchUser(uid: String, completion: @escaping(User?) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { completion(nil)
                return
            }
            
            let user = User(uid: uid, dict: dict)
            completion(user)
        }
    }
    
    func fetchUserFromRequests(completion: @escaping(User?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return}
        REF_USER_REQUESTS.child(uid).observeSingleEvent(of: .value) {
            snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                return
            }
            let user = User(uid: uid, dict: dict)
            completion(user)
        }
    }
    
    
    func fetchRequests(completion: @escaping([User]?) -> Void) {
        var users = [User]()
        REF_USER_REQUESTS.observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: [String: Any]] else { completion(nil)
                return
            }
            for (key, value) in dict {
                let userDict = value
                let user = User(uid: key, dict: userDict)
                users.append(user)
                completion(users)
            }
        }
    }
    
    func acceptTapped(uid: String, completion: @escaping() -> Void) {
        REF_USER_REQUESTS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { completion()
                return
            }
            REF_USERS.child(uid).updateChildValues(dict) { error, ref in
                if let error = error {
                    print(error.localizedDescription)
                }
                REF_USER_REQUESTS.child(uid).removeValue()
                completion()
            }
        }
        
    }
    
    func denyTapped(uid: String, completion: @escaping() -> Void) {
        REF_USER_REQUESTS.child(uid).removeValue()
        completion()
        
    }
    
    func checkIfUserAccepted(completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        }

    }
    
    func fetchUserToken(uid: String, completion: @escaping(String) -> Void) {
        FIRESTORE_DB_REF.collection("users_table").document(uid).getDocument { snapshot, err in
            if let err = err {
                print("ERROR FETCHING USER TOKEN: \(err)")
            }
            
            let dict = snapshot?.data() as? [String: String]
            
            let token = dict?["fcmToken"]
         
            completion(token ?? "Nothing")
        }
    }
    
    func fetchProfileImage(uid: String, completion: @escaping(URL?) -> Void) {
        
        REF_USERS.child(uid).child("profileImageUrl").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() == false {
                completion(nil)
            }
            let imageUrlString = snapshot.value as? String
            
            guard let imageUrlString = imageUrlString else { return }
            let imageURL = URL(string: imageUrlString)
            
            guard let imageURL = imageURL else {
                return }
            
            completion(imageURL)
        }
        
    }
}
