//
//  DetailsViewController.swift
//  APAE
//
//  Created by Rui Costa on 11/01/2022.
//

import UIKit
import SafariServices
import Firebase

class DetailsViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource{
    
    
static let identifier = "DetailsViewController"
    
    var article: Article?
    var image: Data? = nil
    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(NewsDetailTableViewCell.self, forCellReuseIdentifier: NewsDetailTableViewCell.identifier)
        return table
    }()
    
    private let db = Firestore.firestore()
    private let searchVC = UISearchController(searchResultsController: nil)
    private var viewModels : NewsDetailTableViewCellViewModel?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Detail"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
      /*  self.viewModels = article({
            NewsDetailTableViewCellViewModel(
             title: $0.title,
             summary: $0.summary ?? "Sem Descrição para mostrar",
             imageURL: URL(string: $0.imageUrl ?? ""),
             newsSite: $0.newsSite ?? "Sem autor",
             publishedAt: $0.publishedAt ?? ""
            )
         
        })*/
        
        
       /* NewsDetailTableViewCellViewModel(
        title: article?.title ?? "Sem Titulo" ,
         summary: article?.summary ?? "Sem Descrição para mostrar",
         imageURL: URL(string: article?.imageUrl ?? ""),
         newsSite: article?.newsSite ?? "Sem autor",
         publishedAt: article?.publishedAt ?? ""
        ) */
        
    DispatchQueue.main.async {
        self.tableView.reloadData()
    }
        
        
        
    }
    
    
    @objc func pressed() {
        let docId = String(article!.id)
        
        
                db.collection("likes").document(docId).setData([
                    "no_likes": FieldValue.increment(Int64(1))
                ], merge: true) { err in
                    if let err = err {
                        print("Error writing document: (err)")
                    }
                }
        
        
    }
    @objc func commented() {
        self.tableView.reloadData()
        let docId = String(article!.id)
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsDetailTableViewCell.identifier
        )as? NewsDetailTableViewCell else {
            fatalError()
        }
        
        let nome = cell.textField.text
        
        let comment = cell.commentField.text
        print(comment)
        
        db.collection("comments").document(docId).collection("comment").addDocument(data: [
            "nome": nome,
            "comentario": comment
        ]) { err in
            if let err = err {
                print("Error writing document: (err)")
            }
        }
    
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame =  view.bounds
        
        
    }
 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsDetailTableViewCell.identifier,
            for: indexPath
        )as? NewsDetailTableViewCell else {
            fatalError()
        }
        
        cell.authorLabel.text = article?.newsSite
        cell.publishedAtLabel.text = article?.publishedAt
        cell.newsTitleLabel.text = article?.title
        cell.subTitleLabel.text = article?.summary
        
        let docId = String(article!.id)
        
        db.collection("likes").document(docId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
//                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                cell.likeField.text = String(describing: document.get("no_likes") ?? "0")
            }
        
       
       // let data = viewModels?.imageData
        cell.newsImageView.image = UIImage(data: image!)
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }

}
