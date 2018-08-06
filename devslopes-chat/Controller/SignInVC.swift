//
//  SignInVC.swift
//  devslopes-chat
//
//  Created by Константин Клинов on 8/5/18.
//  Copyright © 2018 Константин Клинов. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInBtn.layer.cornerRadius = 8
        
    }

    override func viewDidAppear(_ animated: Bool) {
  
        setUserName()
        
        if AuthService.instance.isLoggedIn {
            performSegue(withIdentifier: "showMainVC", sender: nil)
        }
    }
    
        
        func showAlert(title: String, message: String) {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    
    
        func setUserName(){
            if let user = Auth.auth().currentUser {
                AuthService.instance.isLoggedIn = true
                let emailcomponents = user.email?.components(separatedBy: "@")
                if let userName = emailcomponents?[0] {
                    AuthService.instance.username = userName
                } else {
                    AuthService.instance.isLoggedIn = false
                    AuthService.instance.username = nil
                }
            }
    }

 
    @IBAction func sighInTapped(_ sender: Any) {
        guard let email = emailTxtField.text, let password = passwordTxtField.text else {
            showAlert(title: "Error", message: "Please enter email and password")
            return
        }
            guard  email != "", password != "" else {
                showAlert(title: "Error", message: "Please enter email and password")
            return
            }
            AuthService.instance.emailLogin(email, password: password) { (success, message) in
                if success {
                    self.setUserName()
                    self.performSegue(withIdentifier: "showMainVC", sender: nil)
                } else {
                
                    self.showAlert(title: "Failture", message: message)
                }
            }
}
}
    


