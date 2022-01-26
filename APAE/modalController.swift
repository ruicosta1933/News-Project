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
    var docId : String?
    private let db = Firestore.firestore()
    
    @IBOutlet var comment: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("12")
      /*  db.collection("comments").whereField("newsId", isEqualTo: "13669").getDocuments(){
            (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data()) ====", document.get("comentario") as! String)
                        }
        }
            */
          /* .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot?.documents else {
                    print("Error fetching document: \(error!)")
                    return
                }
                document.compactMap({
                 */
                 /*
                    document in
                    let id = document.get("newsId") as? String
                    if  id == "13669" {
                        self.commentLabel.text = document.get("comentario") as? String
                       print(document.get("comentario") as! String)
                    })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                */
    //                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
      //          self.commentLabel.text = String(describing: document.get("commentario") ?? "Sem comentario")
            }
    }

    

