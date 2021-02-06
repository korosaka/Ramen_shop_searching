//
//  CloudMessage.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2021-01-15.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import Foundation
class PushNotificationSender {
    
    let serverKey = "AAAAwJtiVfE:APA91bExhvGYkWtphDlOFS7HweSsR8fkCf0RvelGstM33jsmGkxPfwh6JEUVjyG-jLvQUHGjuhzW1-YO3oF2Vc4Z-p73O1i_-JmTaS96JWiaeITZSWgK8_JUYjt6VXVaDoaP_h4O09-T"
    
    func sendPushNotification(to token: String,
                              receiver: NotificationReceiver) {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        //MARK: data can be added by using "data"
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : receiver.title,
                                                             "body" : receiver.body]]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
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

enum NotificationReceiver: String {
    case requester = "requester"
    case allUser = "all_user"
    
    var title: String {
        switch self {
        case .requester:
            return "Reviewing has been done!"
        default:
            return "New shop has been registered near you!"
        }
    }
    
    var body: String {
        switch self {
        case .requester:
            return "Your adding shop request has been reviewed. Please check it in app."
        default:
            return "Let's check it!"
        }
    }
}
