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
    
    var tableViewData: [String] = []
    static let identifier = "modalController"
    var ref: DocumentReference? = nil
    let db = Firestore.firestore()
    var docId: String!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
            
            db.collection("comments").document(docId).collection("comment").getDocuments() {
                (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: (err)")
                    } else {
                        for document in querySnapshot!.documents {
                            var teste = String(describing: document.get("comment")!)
                            print(teste)
                            
                        
                            
                            self.tableViewData.append(teste)
                            print(self.tableViewData)
                            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
            
            cell.textLabel?.text = self.tableViewData[indexPath.row]
            return cell
        }
    }

    

