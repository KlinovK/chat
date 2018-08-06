//
//  MainVC.swift
//  devslopes-chat
//
//  Created by Константин Клинов on 8/5/18.
//  Copyright © 2018 Константин Клинов. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DataService.instance.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        let tap = UIGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @IBAction func logoutBtnWasPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "showSignInVC", sender: nil)
        } catch {
            print("An error occured signing out")
        }
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        guard let messageText = messageTextField.text else {
            showalert(title: "Error", message: "Please enter a message")
       return
        }
        guard messageText != "" else {
            showalert(title: "Error", message: "No message to send")
            return
        }
        if let user = AuthService.instance.username {
            DataService.instance.saveMessage(user, message: messageText)
            messageTextField.text = ""
            dismissKeyboard()
            tableView.reloadData()
        }
    }
    
   @objc func keyboardWillShow(notif: NSNotification){
        if let keyboardSize = (notif.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 { self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
  @objc func keyboardWillHide(notif: NSNotification){
        if let keyboardSize = (notif.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 { self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func dismissKeyboard(){
       view.endEditing(true)
    }
    
    func showalert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion:  nil)
    }
    
}

extension MainVC: DataServiceDelegate, UITableViewDelegate, UITableViewDataSource {
    func dataLoaded() {
        tableView.reloadData()
        if DataService.instance.message.count > 0 {
            let indexPath = IndexPath(row: DataService.instance.message.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.message.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = DataService.instance.message[(indexPath as NSIndexPath).row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as? MessageCell {
            if let user = msg.userID, let message = msg.message {
                cell.configureCell(user: user, message: message)
            }
            return cell
        } else {
            return MessageCell()
        }
    }
    
}
