//
//  NotificationHandler.swift
//  Arquibancada Watch App
//
//  Created by aaav on 29/11/22.
//

import Foundation
import UserNotifications

class NotificationHandler {
    
    func askPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ success, error in
            if success {
                print("Access granted")
            }
            else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(title: String, timeInterval: Double, body: String){
        
        var trigger : UNNotificationTrigger?
        
        trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
}
