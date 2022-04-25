//
//  Constants.swift
//  VictoryHQ
//
//  Created by John McCants on 1/14/22.
//

import Foundation
import Firebase
import FirebaseFirestore

let DB_REF = Database.database().reference()
let FIRESTORE_DB_REF = Firestore.firestore()
let REF_USERS = DB_REF.child("users")
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let STORAGE_VICTORY_IMAGES = STORAGE_REF.child("victory_images")
let REF_USER_VICTORIES = DB_REF.child("user-victories")
let REF_VICTORIES = DB_REF.child("victories")
let REF_REPORTED_VICTORIES = DB_REF.child("reported-victories")
let REF_VICTORY_RESPECTS = DB_REF.child("victory-respects")
let REF_USER_RESPECTS = DB_REF.child("user-respects")
let REF_USER_REQUESTS = DB_REF.child("user-requests")

