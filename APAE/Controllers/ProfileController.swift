//
//  ProfileController.swift
//  APAE
//
//  Created by Rui Costa on 30/01/2022.
//

import Foundation
import UIKit
import Firebase

class ProfileController : UIViewController {
    static let identifier = "ProfileController"
    private let db = Firestore.firestore()
    @IBOutlet var email: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // User info to a variable
        let auth = Auth.auth().currentUser
        // Complete the outlet with the username
        email.text = auth?.displayName
        
    }
    
    //Function of logout button
    @IBAction func logOut(_ sender: Any) {
        
        do{
            // End of session
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            //Error treatting
            print("Error signing out:", signOutError)
        }
    
        // Dismisso from the page to the initial page (LoginController)
        
        dismiss(animated: true, completion: nil)
    }
    
}
