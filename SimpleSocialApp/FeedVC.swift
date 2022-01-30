//
//  FeedVC.swift
//  SimpleSocialApp
//
//  Created by Hamit Seyrek on 30.01.2022.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var userEmailArray = [String]()
    var commentArray = [String]()
    var userImageArray = [String]()
    var likeArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //configure for tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
    }
    //MARK: - GetData from FireStore
    func getData() {
        let fireStoreDb = Firestore.firestore()
        fireStoreDb.collection("posts").order(by: "date", descending: true).addSnapshotListener { querySnapshot, error in
            if error != nil {
                print("Error in here!!!")
            } else {
                if querySnapshot?.isEmpty == false {
                    //Clear tableView
                    self.userImageArray.removeAll()
                    self.userEmailArray.removeAll()
                    self.commentArray.removeAll()
                    self.likeArray.removeAll()
                    for document in querySnapshot!.documents {
                        if let userName = document.get("postedBy") as? String {
                            self.userEmailArray.append(userName)
                        }
                        if let imageUrl = document.get("imageUrl") as? String {
                            self.userImageArray.append(imageUrl)
                        }
                        if let comment = document.get("comment") as? String {
                            self.commentArray.append(comment)
                        }
                        if let likeCount = document.get("likeCount") as? Int {
                            self.likeArray.append(likeCount)
                        }
                    }
                    //Realtime updated
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Table View Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! FeedTVC
        cell.userEmailTextField.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = commentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        
        //Image async
        let url = URL(string: userImageArray[indexPath.row])
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.userImageView.image = image
                    }
                } else {
                    cell.userImageView.image = UIImage(named: "selectImage")
                }
            }
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userEmailArray.count
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
