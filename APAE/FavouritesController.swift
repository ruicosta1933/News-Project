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
    var tableViewData: [FavouriteModel] = []
    var articles : [Article] = []
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourites"
        let id = Auth.auth().currentUser?.uid
        
        db.collection("likedByUser").document(id!).collection("news").whereField("isFavourite", isEqualTo: true)
            .getDocuments(){ (QuerySnapshot, err) in
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
                                FavouriteModel( id: articles.id,
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
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("aqui")
        return tableViewData.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as? FavouritesViewCell
        
        cell?.title.numberOfLines = 2
        cell?.title.font = .systemFont(ofSize: 22, weight: .semibold)
        cell?.title.text = self.tableViewData[indexPath.row].title
        cell?.date.font = .systemFont(ofSize: 17, weight: .thin)
        cell?.date.text = self.tableViewData[indexPath.row].publishedAt
        cell?.author.font = .systemFont(ofSize: 17, weight: .thin)
        cell?.author.text = self.tableViewData[indexPath.row].newsSite
        
        if let url = self.tableViewData[indexPath.row].imageURL {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
            
                DispatchQueue.main.async {
                    cell?.newsImage.layer.cornerRadius = 6
                    cell?.newsImage.layer.masksToBounds = true
                    cell?.newsImage.clipsToBounds = true
                    cell?.newsImage.backgroundColor = .secondarySystemBackground
                    cell?.newsImage.contentMode = .scaleAspectFill
                    cell?.newsImage.image = UIImage(data: data)
                }
            }.resume()
            
        }
         
        return cell!
        
    }
    
selectcell
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
      guard let vc = storyboard?.instantiateViewController(withIdentifier: "NewsDetailsViewController") as? NewsDetailsViewController
        else{
            return
        }
        
        if let url = self.tableViewData[indexPath.row].imageURL {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
            
                DispatchQueue.main.async {
                    vc.image = data
                }
            }.resume()
            
        }
        
        vc.article = self.articles[indexPath.row]
        
          navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       
        tableView.deselectRow(at: indexPath, animated: true)
        
      guard let vc = storyboard?.instantiateViewController(withIdentifier: "NewsDetailsViewController") as? NewsDetailsViewController
        else{
            return
        }
        
        vc.article = articles[indexPath.row]
        vc.image = viewModels!.imageData
        
          navigationController?.pushViewController(vc, animated: true)
        
    }*/
    
}
