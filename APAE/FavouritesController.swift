//
//  FavouritesController.swift
//  APAE
//
//  Created by Rui Costa on 01/02/2022.
//

import Foundation
import UIKit
import Firebase

class FavouritesController: UIViewController {
    static let identifier = "FavouritesController"
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var id = Auth.auth().currentUser?.uid
        
        
        db.collection("likedByUser").document(id!).collection("news").whereField("isFavourite", isEqualTo: true)
            .addSnapshotListener{ (QuerySnapshot, err) in
                if let err = err {
                    print("Error")
                }
                else {
                    for document in QuerySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
                
            }
    }
}
