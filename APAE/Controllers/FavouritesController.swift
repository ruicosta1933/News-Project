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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        
        //Query to the likes of the user that is currently logged in
        db.collection("likedByUser").document(id!).collection("news").whereField("isFavourite", isEqualTo: true)
            .getDocuments(){ (QuerySnapshot, err) in
                if err != nil {
                    print("Error")
                }
                else {
                    for document in QuerySnapshot!.documents {
        //API Fetch to get the articles by id
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
                    }
                }
            }
    }
        tableView.dataSource = self
    }
    
    @objc func handleRefreshControl(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) {
        //Clear the ViewData so that it doesn't accumulate articles
            tableViewData.removeAll()
            viewDidLoad()

            self.tableView.refreshControl?.endRefreshing()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Get the cell outlets from the StoryBoard
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as? FavouritesViewCell
        
        //Complete the outlets with information and design
        cell?.title.numberOfLines = 2
        cell?.title.font = .systemFont(ofSize: 22, weight: .semibold)
        cell?.title.text = self.tableViewData[indexPath.row].title
        cell?.date.font = .systemFont(ofSize: 17, weight: .thin)
        cell?.date.text = self.tableViewData[indexPath.row].publishedAt
        cell?.author.font = .systemFont(ofSize: 17, weight: .thin)
        cell?.author.text = self.tableViewData[indexPath.row].newsSite
        
        //Treatment of the image because it comes as an URL
        if let url = self.tableViewData[indexPath.row].imageURL {
            
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else{
                    return
                }
            
                DispatchQueue.main.async {
                    //Design & Atribute image data
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

}
