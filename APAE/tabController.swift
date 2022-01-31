//
//  tabController.swift
//  APAE
//
//  Created by Rui Costa on 29/01/2022.
//

import Foundation
import UIKit

class tabController: UITabBarController{
    static let identifier = "tabController"

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationPermission()
    }
    func notificationPermission() {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
                print(error)
            }
            // Enable or disable features based on the authorization.
            print(granted)
        }
    }
}
