//
//  modalController.swift
//  APAE
//
//  Created by Rui Costa on 21/01/2022.
//
import UIKit
import Foundation
import Firebase

class modalController: UIViewController {
    
    static let identifier = "modalController"
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = "Alfredo"
        
        

         db.collection("comments")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                document.compactMap({ document in
                    self.commentLabel.text = document.get("comentario") as! String
                    print(document.get("comentario") as! String)
                })
                
                
    //                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
      //          self.commentLabel.text = String(describing: document.get("commentario") ?? "Sem comentario")
            }
    }
    
  
    
    
}
