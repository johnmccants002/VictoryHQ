//
//  VictoryService.swift
//  VictoryHQ
//
//  Created by John McCants on 1/14/22.
//

import Foundation
import UIKit
import Firebase

struct VictoryService {
    
    static let shared = VictoryService()
    
    func uploadVictory(user: User, victoryText: String, victoryImage: UIImage?, victoryDetails: String?, completion: @escaping(Error?) -> Void) {
        if victoryText.isEmpty == true {
            completion(nil)
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = REF_VICTORIES.childByAutoId()
        
        
        guard let victoryID = ref.key else { return }
        let userRef = REF_USER_VICTORIES.child(uid).child(victoryID)
        var values : [String: Any]?
        
        var victoryDict = ["uid": uid, "victoryText": victoryText, "fullName": user.fullName, "victoryID": victoryID, "timestamp": Int(NSDate().timeIntervalSince1970)] as [String : Any]
        
        if let victoryDetails = victoryDetails {
            victoryDict["victoryDetails"] = victoryDetails
        }
        
        if let victoryImage = victoryImage {
            uploadVictoryImage(image: victoryImage, victoryID: victoryID, victoryDict: victoryDict) {
                completion(nil)
                print("uploaded victory with image")
            }
        } else {
            ref.updateChildValues(victoryDict)
            userRef.updateChildValues(victoryDict)
            completion(nil)
        }
        
        
        
        
    }
    
    
    // MARK: Upload Victory Image Function
    
    // MARK: Fetch Victories
    
    func fetchVictories(completion: @escaping([Victory]) -> Void) {
        var victories = [Victory]()
        let group = DispatchGroup()
           group.enter()
        REF_VICTORIES.observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            for (key, value) in dict {
                guard let value = value as? [String: Any] else { return }
                var victory = Victory(victoryID: key, dictionary: value)
                checkIfUserRespected(victoryId: key) { didRespect in
                    victory.didRespect = didRespect
                    victories.append(victory)
                 
                    completion(victories)
                }
            }
        }
        
    }
    
    func fetch20Victories(lastVictory: Victory?, completion: @escaping(_ victories: [Victory]) -> ()) {
        var queryRef: DatabaseQuery
        
        if let lastVictory = lastVictory {
            print("nil nil nil")
            let lastTimestamp = lastVictory.timestamp.timeIntervalSince1970
            queryRef = REF_VICTORIES.queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp).queryLimited(toLast: 20)
        } else {
            queryRef = REF_VICTORIES.queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
        }
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
            var tempVictories = [Victory]()
            guard let dict = snapshot.value as? [String: Any] else { return }
            for (key, value) in dict {
                guard let value = value as? [String: Any] else { return }
                if key != lastVictory?.victoryID {
                var victory = Victory(victoryID: key, dictionary: value)
                    tempVictories.append(victory)
//                     
//                    checkIfUserRespected(victoryId: key) { didRespect in
//                            victory.didRespect = didRespect
//                            
//                      
//                        }
                    
                
            }
            
            
        }
            
            let victories = tempVictories.sorted(by: {$0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970})
            return completion(victories)
        })
    }
    
    func fetchTotalVictoryCount(completion: @escaping(Int) -> Void) {
        REF_VICTORIES.observe(.value) { snapshot in
            let count = snapshot.childrenCount
            completion(Int(count))
        }
        
    }
    
    func uploadVictoryImage(image: UIImage, victoryID: String, victoryDict: [String : Any], completion: @escaping() -> Void) {
        var dict = victoryDict
        guard let compressedImage = image.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_VICTORY_IMAGES.child(filename)
        
        storageRef.putData(compressedImage, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: Error putting image data to database \(error)")
            }
            storageRef.downloadURL { url, error in
                guard let victoryImageUrl = url?.absoluteString else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let values = ["victoryImageUrl": victoryImageUrl]
                dict["victoryImageUrl"] = victoryImageUrl
                let ref = REF_USER_VICTORIES.child(uid).child(victoryID)
                
                ref.updateChildValues(dict)
                REF_VICTORIES.child(victoryID).updateChildValues(dict)
                
                completion()
                
            }
        }
    }
    // MARK: Delete Victory
    func deleteVictory(victory: Victory, completion: @escaping() -> Void) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        let ref = REF_VICTORIES.child(victory.victoryID)
        let userRef = REF_USER_VICTORIES.child(currentUserUid)
        
        userRef.child(victory.victoryID).removeValue()
        ref.removeValue()
        
        deleteRespectActivity(victoryID: victory.victoryID, uid: victory.uid)
        completion()
    }
    
    // MARK: Fetch User Victories
//    func fetchUserVictories(completion: @escaping([Victory]) -> Void) {
//        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
//       var userVictories = [Victory]()
//        REF_USER_VICTORIES.child(currentUserUid).observeSingleEvent(of: .value) { snapshot in
//            guard let dict = snapshot.value as? [String: [String: Any]] else { return }
//
//            for (key, value) in dict {
//            let victory = Victory(victoryID: key, dictionary: value)
//                userVictories.append(victory)
//                completion(userVictories)
//            }
//        }
//    }
    
    func fetchUserVictories(lastVictory: Victory?, completion: @escaping(_ victories: [Victory]) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var queryRef: DatabaseQuery
        
        if let lastVictory = lastVictory {
            print("nil nil nil")
            let lastTimestamp = lastVictory.timestamp.timeIntervalSince1970
            queryRef = REF_USER_VICTORIES.child(uid).queryOrdered(byChild: "timestamp").queryEnding(atValue: lastTimestamp).queryLimited(toLast: 20)
        } else {
            queryRef = REF_USER_VICTORIES.child(uid).queryOrdered(byChild: "timestamp").queryLimited(toLast: 20)
        }
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
            var tempVictories = [Victory]()
            guard let dict = snapshot.value as? [String: Any] else { return }
            for (key, value) in dict {
                guard let value = value as? [String: Any] else { return }
                if key != lastVictory?.victoryID {
                var victory = Victory(victoryID: key, dictionary: value)
                    tempVictories.append(victory)
            
                
            }
            
            
        }
            let victories = tempVictories.sorted(by: {$0.timestamp.timeIntervalSince1970 > $1.timestamp.timeIntervalSince1970})
            return completion(victories)
        })
    }
    
    // MARK: Fetch User Respect Activity
    func fetchRespectActivity(completion: @escaping([RespectNotification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var respectNotifications = [RespectNotification]()
        
        REF_USER_RESPECTS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: [String: Any]] else { return }
            
            for (key, value) in dict {
                let respectNotification = RespectNotification(respectID: key, dict: value)
                respectNotifications.append(respectNotification)
                completion(respectNotifications)
            }
        }
        
        
    }
    
    func checkIfUserRespected(victoryId: String, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return }
        REF_VICTORY_RESPECTS.child(victoryId).child(uid).observeSingleEvent(of: .value) { snapshot in
            print("Victory respected = \(snapshot.exists())")
            completion(snapshot.exists())
        }
    }
    
    func respectVictory(victory: Victory, user: User, completion: () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let victoryUid = victory.uid
        let refUserRespects = REF_USER_RESPECTS.childByAutoId()
        let dict = ["uid": uid] as [String: Any]
        
        guard let respectID = refUserRespects.key else { return }
        let userDict =
        [
            "fullName": user.fullName,
            "userUid": uid,
            "victoryID": victory.victoryID,
            "respectID": respectID,
            "timestamp": Int(Date().timeIntervalSince1970)
            
        ] as [String: Any]
        if victory.uid != uid {
            REF_VICTORY_RESPECTS.child(victory.victoryID).child(uid).updateChildValues(dict)
            REF_USER_RESPECTS.child(victoryUid).childByAutoId().updateChildValues(userDict)
        }
    }
    
    func unrespectVictory(victory: Victory, user: User, completion: () -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USER_RESPECTS.child(victory.uid).child(uid).removeValue() {
            error, ref in
            REF_VICTORY_RESPECTS.child(victory.victoryID).removeValue()
        }
    }
    
    // MARK: Fetch Victory Respects

    
    // MARK: Report Victory
    
    func reportVictory() {
        
    }
    
    func fetchVictory(victoryID: String, completion: @escaping(Victory) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = REF_VICTORIES.child(victoryID)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            let victory = Victory(victoryID: victoryID, dictionary: dict)
            completion(victory)
        }
    }
    
    func getYesterdayCount(completion: @escaping(Int) -> Void) {
        let last24hours = Date().timeIntervalSince1970 - 86400
        let toDateTimeStamp = Date().timeIntervalSince1970 - 86400
        let dayBefore = last24hours - 86400
            REF_VICTORIES.queryOrdered(byChild: "timestamp").queryStarting(atValue: toDateTimeStamp).observeSingleEvent(of: .value) { snapshot in
                print("This is the count ordered by time: \(snapshot.childrenCount)")
                let todayCount = Int(snapshot.childrenCount)
                completion(todayCount)
            }

        
    }
    
    func getDayBeforeCount(completion: @escaping(Int) -> Void) {
        let last24hours = Date().timeIntervalSince1970 - 86400
        let toDateTimeStamp = Date().timeIntervalSince1970 - 86400
        let dayBefore = last24hours - 86400
        
            REF_VICTORIES.queryOrdered(byChild: "timestamp").queryStarting(atValue: dayBefore).queryEnding(atValue: last24hours).observeSingleEvent(of: .value) {
                snapshot in
                print("This is the count ordered by time dayBefore to last24hours: \(snapshot.childrenCount)")
                let dayBeforeCount = Int(snapshot.childrenCount)
                completion(dayBeforeCount)
            }
        
    }
    
    func deleteRespectActivity(victoryID: String, uid: String) {
        REF_USER_VICTORIES.child(victoryID).removeValue()
        
        REF_VICTORY_RESPECTS.child(victoryID).removeValue()
      

        REF_USER_RESPECTS.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dict = snapshot.value as? [String: [String: Any]] else { return }
            
            for (key, value) in dict {
                
                for (key2, value2) in value {
                    print("2")
                    if let value2 = value2 as? String {
                        if key2 == "victoryID" && value2 == victoryID {
                            print("This is what should be deleted: \(key2), \(value2)")
                            REF_USER_RESPECTS.child(uid).child(key).removeValue()
                        }
                    }
                }
               
            }
          
        }
    }
    
    func fetchTotalRespects(completion: @escaping(Int?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_RESPECTS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let sum = snapshot.childrenCount
            let count = Int(exactly: sum)
            
            completion(count)
            
        }
    }

    

    
    
}
