//
//  UploadVC.swift
//  SimpleSocialApp
//
//  Created by Hamit Seyrek on 30.01.2022.
//

import UIKit
import Firebase

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
        
        let storage = Storage.storage()
        // Create a root reference
        let storageRef = storage.reference()
        
        // Create a reference to "media" folder
        let mediaRef = storageRef.child("media")
        
        if let data = uploadImage.image?.jpegData(compressionQuality: 0.5) {
            //Create a unique uuid
            let uuid = UUID().uuidString
            
            // Create a reference to "image.jpg"
            let imageRef = mediaRef.child("\(uuid).jpg")
            
            // Save media to Storage
            imageRef.putData(data, metadata: nil) { metaData, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error...")
                } else {
                    imageRef.downloadURL { url, error in
                        if error != nil {
                            self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error...")
                        } else {
                            let imageUrl = url?.absoluteString
                            
                            //MARK: - Database
                            let fireStore = Firestore.firestore()
                            //create post
                            let fireStorePost = [
                                "imageUrl" : imageUrl!,
                                "postedBy" : Auth.auth().currentUser!.uid,
                                "comment" : self.commentTextField.text ?? "",
                                "date" : FieldValue.serverTimestamp(),
                                "likeCount" : 0
                            ] as [String : Any]
                            // Add a new document in collection "cities"
                            fireStore.collection("posts").addDocument(data: fireStorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error...")
                                } else {
                                    self.commentTextField.text = ""
                                    self.uploadImage.image = UIImage(named: "selectImage")
                                    self.tabBarController?.selectedIndex = 0 // back to feed tab
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
}
