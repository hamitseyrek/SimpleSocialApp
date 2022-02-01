//
//  FeedTVC.swift
//  SimpleSocialApp
//
//  Created by Hamit Seyrek on 30.01.2022.
//

import UIKit
import Firebase
import OneSignal

class FeedTVC: UITableViewCell {
    
    @IBOutlet weak var postID: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userEmailTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        let fireStoreDB = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!) {
            let likeStore = ["likeCount" : likeCount+1] as [String : Any]
            fireStoreDB.collection("posts").document(postID.text!).setData(likeStore, merge: true)
        }
        
        if let userID = userEmailTextField.text {
            fireStoreDB.collection("PlayerIDs").whereField("userId",isEqualTo: userID).getDocuments { snapShot, error in
                if error == nil {
                    if snapShot?.isEmpty == false && snapShot != nil {
                        for document in snapShot!.documents {
                            if let playerID = document.get("player_id") {
                                //MARK: - Push Notification (One signal)
                                OneSignal.postNotification(["contents" : ["en" : "\(Auth.auth().currentUser!.email!) liked your post"], "include_player_ids" : "\(playerID)"])
                            }
                        }
                    }
                }
            }
        }
    }
}
