//
//  NewsDetailsViewController.swift
//  APAE
//
//  Created by Rui Costa on 19/01/2022.
//

import Foundation
import UIKit
import Firebase

class NewsDetailsViewController: UIViewController{
    
    
    
    
    
    
static let identifier = "NewsDetailsViewController"
    
    var article: Article?
    var image: Data? = nil
    

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var subTitleLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var likesCount: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var commentField: UITextView!
    @IBOutlet var commentButton: UIButton!
    
    private let db = Firestore.firestore()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        
        let docId = String(article!.id)
        
        db.collection("likes").document(docId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
//                let source = document.metadata.hasPendingWrites ? "Local" : "Server"
                self.likesCount.text = String(describing: document.get("no_likes") ?? "0")
            }
        
        imageView.image = UIImage(data: image!)
        titleLabel.text = article?.title
        subTitleLabel.text = article?.summary
        dateLabel.text = article?.publishedAt
        authorLabel.text = article?.newsSite
        likeButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        commentField.layer.borderColor = UIColor.systemBlue.cgColor
        commentField.layer.borderWidth = 1
        commentField.layer.cornerRadius = 5
        commentButton.layer.borderWidth = 1
        commentButton.layer.cornerRadius = 5
        commentButton.layer.borderColor = UIColor.systemBlue.cgColor
        commentButton.addTarget(self, action: #selector(commented), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        
        
        
    }
    

    @objc func commented() {
        let docId = String(article!.id)
        
        let comment = commentField.text
        
        db.collection("comments").addDocument(data: [
            "newsId" : docId,
            "comentario": comment,
            "timestamps": FieldValue.serverTimestamp()
        ])
        
        
        
    }
    
    @objc func pressed() {
        
        UIView.animate(withDuration: 0.4,
            animations: {
                self.likeButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    self.likeButton.transform = CGAffineTransform.identity
                    self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
            })
        
        let docId = String(article!.id)
        
        
                db.collection("likes").document(docId).setData([
                    "no_likes": FieldValue.increment(Int64(1))
                ], merge: true)
        
        
    }
    
   
}


