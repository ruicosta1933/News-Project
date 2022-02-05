//
//  RecoverPasswordController.swift
//  APAE
//
//  Created by Rui Costa on 29/01/2022.
//

import Foundation
import UIKit
import Firebase
class RecoverPasswordController: UIViewController{
    static let identifier = "RecoverPasswordController"
    
    @IBOutlet var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }
    @IBAction func recoverPassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: email.text!) { error in
            if (error?._code == nil) {
                
                let alerta = UIAlertController(title: "Email Enviado", message: "Foi enviado o email para alteração da password", preferredStyle: .alert)
                alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alerta, animated: true, completion: nil)
            } else{
                let errCode = AuthErrorCode(rawValue: error!._code)
                switch errCode {
                    
                case .missingEmail:
                    let alerta = UIAlertController(title: "Email Invalido", message: "Esse email nao se encontra registado", preferredStyle: .alert)
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
