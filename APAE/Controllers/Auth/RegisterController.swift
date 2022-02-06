//
//  RegisterController.swift
//  APAE
//
//  Created by Rui Costa on 29/01/2022.
//

import Foundation
import UIKit
import Firebase

class RegisterController : UIViewController {
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    private let db = Firestore.firestore()
   
    @IBOutlet var goToLogin: UIButton!
    
    
    static let identifier = "RegisterController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Function to hide the keyboard when tapped away from it
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func registerAccount(_ sender: Any) {
        
        //Firebase Function to create and add the user info to the list of users in database
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
           
            
            
            if (error?._code == nil) {
                //Change variable used for the user to have a nickName in the app
                let change = Auth.auth().currentUser?.createProfileChangeRequest()
                change?.displayName = self.userName.text
                change?.commitChanges { error in
                    print("algo errado")
                }
                
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabController") as? tabController
                       else {
                           return
                       }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                
            } else{
                let errCode = AuthErrorCode(rawValue: error!._code)
                //Error treatment for the info written by the user
                switch errCode {
                    
                case .invalidEmail:
                    let alerta = UIAlertController(title: "Email Invalido", message: "O email usado não existe", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alerta, animated: true, completion: nil)
                    
                case .weakPassword:
                    let alerta = UIAlertController(title: "Password Fraca", message: "Password inserida encontra-se fraca", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alerta, animated: true, completion: nil)
                
                default:
                    let alerta = UIAlertController(title: "Erro", message: "Algo de errado nao deu certo", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alerta, animated: true, completion: nil)
                }
            }
        }
    }
}
