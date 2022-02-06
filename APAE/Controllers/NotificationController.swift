//
//  NotificationController.swift
//  APAE
//
//  Created by Rui Costa on 31/01/2022.
//

import Foundation
import UserNotifications

class NotificationController {
    //Share the all class and its functions
    static let shared = NotificationController()
    let center = UNUserNotificationCenter.current()
    
    func notification() {
        
        let content = UNMutableNotificationContent()
        // All body of the notification
        content.title = "Novo Artigo Publicado."
        content.body = "Leia ja a nova noticia !"
        //Time of delay to display the notification
        let date = Date().addingTimeInterval(5)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
       
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
      
        self.center.add(request) { (error) in
            if error != nil {
                print("algo errado")
            }
        }
    }
}
