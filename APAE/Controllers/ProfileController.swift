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
        
        let auth = Auth.auth().currentUser
        print(Auth.auth().currentUser?.displayName)
        email.text = auth?.displayName
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out:", signOutError)
        }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoginController") as? LoginController
          else{
              return
          }
        dismiss(animated: true, completion: nil)
    }
    
}
