//
//  ViewController.swift
//  SimpleSocialApp
//
//  Created by Hamit Seyrek on 29.01.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signInClicked(_ sender: Any) {
        if emailTextField.text != nil {
            if passTextField.text != nil {
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passTextField.text!) { authData, error in
                    if error != nil {
                        self.myAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                        }
                    else {
                        self.performSegue(withIdentifier: "toFeedVCS", sender: nil)
                    }
            }
            }else {
                myAlert(title: "Error!", message: "Password can't be null")
            }
        } else {
            myAlert(title: "Error!", message: "Email can't be null")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailTextField.text != nil {
            if passTextField.text != nil {
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passTextField.text!) { authData, error in
                    if error != nil {
                        self.myAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
                        }
                    else {
                        self.performSegue(withIdentifier: "toFeedVCS", sender: nil)
                    }
            }
            }else {
                myAlert(title: "Error!", message: "Password can't be null")
            }
        } else {
            myAlert(title: "Error!", message: "Email can't be null")
        }
        
    }
    
    func myAlert(title:String,message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}

