//
//  ViewController.swift
//  SimpleSocialApp
//
//  Created by Hamit Seyrek on 29.01.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signInClicked(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVCS", sender: nil)
    }
    @IBAction func signOutClicked(_ sender: Any) {
    }
}

