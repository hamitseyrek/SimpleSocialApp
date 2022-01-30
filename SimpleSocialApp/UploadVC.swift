//
//  UploadVC.swift
//  SimpleSocialApp
//
//  Created by Hamit Seyrek on 30.01.2022.
//

import UIKit

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var uploadOutlet: UIButton!
    @IBOutlet weak var uploadImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //MARK: - Gesture for image view
        uploadImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choiseImage))
        uploadImage.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: - Gesture for image view
    @objc func choiseImage () {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        uploadImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func uploadClicked(_ sender: Any) {
    }
}
