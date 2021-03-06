//
//  FeedVC.swift
//  SimpleSocialApp
//
//  Created by Hamit Seyrek on 30.01.2022.
//

import UIKit
import Firebase
import OneSignal


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let fireStoreDb = Firestore.firestore()
    
    //MARK: - Variables
    var userEmailArray = [String]()
    var commentArray = [String]()
    var userImageArray = [String]()
    var likeArray = [Int]()
    var postIDArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //configure for tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        getData()
        
        //MARK: - (One signal) - get PlayerId and save to firestore
        if let deviceState = OneSignal.getDeviceState() {
            if let playerId = deviceState.userId {
                fireStoreDb.collection("PlayerIDs").whereField("userId", isEqualTo: Auth.auth().currentUser!.uid).getDocuments { snapShot, error in
                    if error  == nil {
                        if snapShot?.isEmpty == false && snapShot != nil {
                            for document in snapShot!.documents {
                                if let playerIdFromFirebase =  document.get("player_id") as? String {
                                    if playerId != playerIdFromFirebase {
                                        self.fireStoreDb.collection("PlayerIDs").addDocument(data: ["userId" : Auth.auth().currentUser!.uid, "player_id" : playerId]) { error in
                                            if error != nil {
                                                print(error?.localizedDescription)
                                            }
                                        }
                                    } else {
                                        self.fireStoreDb.collection("PlayerIDs").document("")
                                    }
                                }
                            }
                        } else {
                            self.fireStoreDb.collection("PlayerIDs").addDocument(data: ["userId" : Auth.auth().currentUser!.uid, "player_id" : playerId]) { error in
                                if error != nil {
                                    print(error?.localizedDescription)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    //MARK: - GetData from FireStore
    func getData() {
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
                        if let documentID = document.documentID as? String {
                            self.postIDArray.append(documentID)
                        }
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
        cell.postID.text = String(postIDArray[indexPath.row])
        
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
    
}
