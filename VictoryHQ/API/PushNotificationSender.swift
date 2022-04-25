//
//  PushNotificationSender.swift
//  VictoryHQ
//
//  Created by John McCants on 2/8/22.
//

import Foundation
import UIKit

class PushNotificationSender {
    
    static let shared = PushNotificationSender()
    
    func sendPushNotification(to token: String, title: String, body: String, id: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : id]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAZ7aZ07k:APA91bF6YKddFyyUoeTqqJFba9Ivy7ZmJUeDwFa7rUFz2imcZptvb13uAbNJMfn0Xj3iM65OIZUwk-aosRmrBrQ7jGYa0Cut7cOIDhMmGKTyCh3KoWj2XIjlBDE2SM3kkIElZ3BLmex8", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
