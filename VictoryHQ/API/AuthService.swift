//
//  AuthService.swift
//  VictoryHQ
//
//  Created by John McCants on 1/8/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage?
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credentials: RegistrationCredentials, completion: @escaping(Error?) -> Void) {
        let firstName : String?
        let lastName : String?
        if let profileImage = credentials.profileImage {
            
            if credentials.fullname.contains(" ") {
                let fullName = credentials.fullname
                let fullNameArr = fullName.components(separatedBy: " ")
                firstName = fullNameArr[0] //First
                lastName = fullNameArr[1] //Last
            } else {
                firstName = credentials.fullname
                lastName = ""
            }
           
            guard let imageData = profileImage.jpegData(compressionQuality: 0.5) else { return }
            let filename = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
            ref.putData(imageData, metadata: nil) { meta, err in
                if let err = err {
                    print("DEBUG: Failed to upload an image with error: \(err.localizedDescription)")
                    completion(err)
                    return
                }
                ref.downloadURL { url, err in
                    if let err = err {
                        completion(err)
                    }
                    guard let profileImageUrl = url else { return }
                    Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                        guard let uid = result?.user.uid else { return }
                        let data = ["email": credentials.email, "fullName": credentials.fullname, "username": credentials.username.lowercased(), "firstName": firstName, "lastName": lastName, "uid": uid, "profileImageUrl": profileImageUrl.absoluteString] as [String : Any]
                        REF_USER_REQUESTS.child(uid).updateChildValues(data)
                        completion(nil)
                    }
                }
            }
        } else {
            if credentials.fullname.contains(" ") {
                let fullName = credentials.fullname
                let fullNameArr = fullName.components(separatedBy: " ")
                firstName = fullNameArr[0] //First
                lastName = fullNameArr[1] //Last
            } else {
                firstName = credentials.fullname
                lastName = ""
            }
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                guard let uid = result?.user.uid else { return }
                let data = ["email": credentials.email, "fullName": credentials.fullname, "username": credentials.username.lowercased(), "uid": uid] as [String : Any]
                REF_USER_REQUESTS.child(uid).updateChildValues(data)
                completion(nil)
            }
            
        }
    }
    
    func checkIfUsernameExists(username: String, completion: @escaping(Int) -> Void) {
        REF_USERS.queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(1)
            } else {
                completion(0)
            }
        }
    }
    
    func checkIfEmailExists(email: String, completion: @escaping(Int) -> Void) {
        REF_USERS.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(1)
            } else {
                completion(0)
            }
        }
        
    }
    
 
    
}
