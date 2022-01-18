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
        
        title = "APAE"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        
        APICaller.shared.getTopNews { [weak self] result in
                   switch result {
                   case .success(let articles):
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
                   case .failure(let error):
                       print(error)
                   }
               }
        // Do any additional setup after loading the view.
        
        createSearchBar()
        
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
        
      guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        else{
            return
        }
        
        vc.article = articles[indexPath.row]
        vc.image = viewModels[indexPath.row].imageData
        
          navigationController?.pushViewController(vc, animated: true)
        
        
    /*
        let article = articles[indexPath.row]
        
        guard let url = URL (string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)*/
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    //Search
    
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

