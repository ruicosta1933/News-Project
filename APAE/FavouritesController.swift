//
//  FavouritesController.swift
//  APAE
//
//  Created by Rui Costa on 01/02/2022.
//

import Foundation
import UIKit
import Firebase

class FavouritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let identifier = "FavouritesController"
    let db = Firestore.firestore()
    private var viewModels : FavouritesViewCellModel? = nil
    private var article  : Article? = nil
    private var articles = [Article]()
    
    var tableViewData: [FavouritesViewCellModel] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(FavouritesViewCell.self, forCellReuseIdentifier: FavouritesViewCell.identifier)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let id = Auth.auth().currentUser?.uid
        title = "Favourites"
        db.collection("likedByUser").document(id!).collection("news").whereField("isFavourite", isEqualTo: true)
            .addSnapshotListener{ (QuerySnapshot, err) in
                if let err = err {
                    print("Error")
                }
                else {
                    for document in QuerySnapshot!.documents {
                APICaller.shared.getById(with: document.documentID){ [weak self] result in
                         switch result {
                         case .success(let articles):
                             
                             self?.articles.append(articles)
                                                                       
                            self?.tableViewData.append(
                                FavouritesViewCellModel( id: articles.id,
                                                            title: articles.title,
                                                            imageURL: URL(string: articles.imageUrl ?? ""),
                                                            newsSite: articles.newsSite ?? "",
                                                            publishedAt: articles.publishedAt ?? "")
                                                            )
                           
                             
                                 DispatchQueue.main.async {
                                     self?.tableView.reloadData()
                                 }
                             
                         case .failure(let error):
                             print(error)
                         }
                        print("\(document.documentID) => \(document.data())")
                    }
                }
            }
    }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame =  view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesController", for: indexPath) as? FavouritesViewCell
        
        print(tableViewData[indexPath.row])
        print("1234")
        cell?.configure(with: tableViewData[indexPath.row])
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
      guard let vc = storyboard?.instantiateViewController(withIdentifier: "NewsDetailsViewController") as? NewsDetailsViewController
        else{
            return
        }
        
        vc.article = articles[indexPath.row]
        vc.image = viewModels!.imageData
        
          navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
