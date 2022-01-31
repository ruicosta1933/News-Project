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
    
    @IBOutlet var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.text = Auth.auth().currentUser?.email
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
