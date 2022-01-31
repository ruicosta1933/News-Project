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
    
   
    @IBOutlet var goToLogin: UIButton!
    
    
    static let identifier = "RegisterController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func registerAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { authResult, error in
            if (error?._code == nil) {
                
                let user = Auth.auth().currentUser
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabController") as? tabController
                       else {
                           return
                       }
                
                self.show(vc, sender: true)
            } else{
                let errCode = AuthErrorCode(rawValue: error!._code)
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