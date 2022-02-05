//
//  modalController.swift
//  APAE
//
//  Created by Rui Costa on 21/01/2022.
//
import UIKit
import Foundation
import Firebase

class modalController: UIViewController, UITableViewDataSource {
    
    var tableViewData: [CommentsModel] = []
    static let identifier = "modalController"
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var docId: String!
    
    @IBOutlet var tableView: UITableView!
    
    
    var commentModels : [CommentsModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
                
                db.collection("comments").document(docId).collection("comment").getDocuments() {
                    (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: (err)")
                        } else {
                            
                            for document in querySnapshot!.documents {
                                let comment = String(describing: document.get("comment")!)
                                let date = (document.get("timestamp")! as? Timestamp)?.dateValue() ?? Date()
                                let userName = String(describing: document.get("user")!)
                                
                                let formatter = DateFormatter()
                                        formatter.locale = .init(identifier: "pt_POSIX")
                                        formatter.dateFormat = "EEEE, MMM d"
                                        let formatteddate = formatter.string(from: date)
                                
                                self.tableViewData.append(CommentsModel(user: userName, comment: comment, date: formatteddate))
                               
                            }
                            DispatchQueue.main.async {
                               self.tableView.reloadData()
                            }
                            
                        }
                    }
                tableView.dataSource = self
            }
                            
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.tableViewData.count
        }
                            
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentsTableViewCell
            
            
            
            
            cell?.comment.text = self.tableViewData[indexPath.row].comment
            cell?.name.text = self.tableViewData[indexPath.row].user
            cell?.date.text = self.tableViewData[indexPath.row].date
            return cell!
        }
    }

    

