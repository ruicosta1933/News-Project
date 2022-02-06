//
//  LoginController.swift
//  APAE
//
//  Created by Rui Costa on 29/01/2022.
//

import UIKit
import Firebase

class LoginController : UIViewController{
    static let identifier = "LoginController"
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var goToRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Function to hide the keyboard when tapped away from it
        self.hideKeyboardWhenTappedAround()
        
    }

    @IBAction func login(_ sender: Any) {
        //Validate user info, if exists and if its correct
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            
            if (error?._code == nil) {
                
                guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "tabController") as? tabController
                       else {
                           return
                       }
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            } else{
                let errCode = AuthErrorCode(rawValue: error!._code)
                switch errCode {
                    //Error treatment for the info written by the user
                case .missingEmail:
                    let alerta = UIAlertController(title: "Email em Falta", message: "O email encontra-se em falta", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alerta, animated: true, completion: nil)
                case .invalidEmail:
                    let alerta = UIAlertController(title: "Email Invalido", message: "O email é invalido", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alerta, animated: true, completion: nil)
                case .missingEmail:
                    let alerta = UIAlertController(title: "Email Invalido", message: "O email não existe", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alerta, animated: true, completion: nil)
                case .wrongPassword:
                    let alerta = UIAlertController(title: "Password Incorreta", message: "Password inserida encontra-se errada", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alerta, animated: true, completion: nil)
                    
                default:
                    let alerta = UIAlertController(title: "Erro", message: "Algo de errado nao deu certo", preferredStyle: .alert)
                    alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alerta, animated: true, completion: nil)
                }
            }
          
        }
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
