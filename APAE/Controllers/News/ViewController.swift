//
//  ViewController.swift
//  APAE
//
//  Created by Rui Costa on 20/12/2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    private let tableView: UITableView = {
        let table = UITableView()
        
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Function to hide the kwyboard when tapped away from it
        self.hideKeyboardWhenTappedAround() 
        title = "APAE"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        //Get the Cache info of the articles
        CacheController.shared.getArticlesByCache{ [weak self] articles in
                       self?.articles = articles
                       self?.viewModels = articles.compactMap({
                           NewsTableViewCellViewModel(
                            id: $0.id,
                            title: $0.title,
                            imageURL: URL(string: $0.imageUrl ?? ""),
                            newsSite: $0.newsSite ?? "Sem autor",
                            publishedAt: $0.publishedAt ?? ""
                           )
                       })
                       DispatchQueue.main.async {
                           self?.tableView.reloadData()
                       }
               }
        createSearchBar()
    }
    
    @objc func handleRefreshControl(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) {
        //Get the Cache info of the articles
            CacheController.shared.getArticlesByCache { [weak self] articles in
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                    id: $0.id,
                    title: $0.title,
                    imageURL: URL(string: $0.imageUrl ?? ""),
                    newsSite: $0.newsSite ?? "Sem autor",
                    publishedAt: $0.publishedAt ?? ""
                   )
                })

                DispatchQueue.main.async {
                   self?.tableView.reloadData()
                }
           }

            self.tableView.refreshControl?.endRefreshing()
        }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame =  view.bounds
    }
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        )as? NewsTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
      guard let vc = storyboard?.instantiateViewController(withIdentifier: "NewsDetailsViewController") as? NewsDetailsViewController
        else{
            return
        }
        
        vc.article = articles[indexPath.row]
        vc.image = viewModels[indexPath.row].imageData
        
          navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    //Search functions
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewDidLoad()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        APICaller.shared.search(with: text){ [weak self] result in
            switch result {
            case .success(let articles):
                
                self?.articles = articles
                    self?.viewModels = articles.compactMap({
                        NewsTableViewCellViewModel(
                            id: $0.id,
                         title: $0.title,
                         imageURL: URL(string: $0.imageUrl ?? ""),
                         newsSite: $0.newsSite ?? "",
                         publishedAt: $0.publishedAt ?? ""
                        )
                    })

                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.searchVC.dismiss(animated: true, completion: nil)
                    }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }

}

