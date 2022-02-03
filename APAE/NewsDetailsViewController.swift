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
    
    public static let shared = NewsDetailsViewController()
    
static let identifier = "NewsDetailsViewController"
    
    var article: Article?
    var image: Data? = nil
    

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var subTitleLabel: UILabel!
    
    
    @IBOutlet var showComments: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var commentsLabel: UILabel!
    @IBOutlet var likesCount: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var commentField: UITextView!
    
    @IBOutlet var commentButton: UIButton!
    
    private let db = Firestore.firestore()
    var isFavourite : Bool = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let button = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(shareNews))
        navigationItem.rightBarButtonItem = button
        
        titleLabel.text = article?.title
        subTitleLabel.text = article?.summary
        dateLabel.text = article?.publishedAt
        authorLabel.text = article?.newsSite
        likeButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        view.backgroundColor = .systemBackground
        
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(data: image!)
    
        commentField.layer.borderColor = UIColor.systemBlue.cgColor
        commentField.layer.borderWidth = 1
        commentField.layer.cornerRadius = 5
        
        let uId = Auth.auth().currentUser!.uid
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
        
        
        
        db.collection("likedByUser").document(String(describing: uId)).collection("news").document(docId)
                    .addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: (error!)")
                        return
                    }

                    if document.get("isFavourite") != nil {
                        self.isFavourite = document.get("isFavourite") as! Bool
                        if(self.isFavourite == false){
                            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                        }
                        else{
                            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                        }
                    }
                }
    
        
        
    }
   

   
    
    @objc func shareNews() {
        
        guard let image = UIImage(data: image!), let url = URL(string: (article?.url)!) else {
                    return
                }
                let shareSheetvc = UIActivityViewController(
                    activityItems: [
                        image,
                        url
                    ],
                    applicationActivities: nil
                )
        
                present(shareSheetvc, animated: true)
     
    }
    
    @IBAction func showQR(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "QRController") as? QRController
                else {
                    return
                }
                
                vc.articleURL = article?.url ?? ""
                
                navigationController?.present(vc, animated: true)
    }
    
    @objc func pressed() {
        
        
        
        
        let docId = String(article!.id)
                let userId = Auth.auth().currentUser?.uid
                
        
                if isFavourite == true {
                    db.collection("likedByUser").document(String(describing: userId!)).collection("news").document(docId).setData([
                        "isFavourite": false,
                    ], merge: true)
                    
                    db.collection("likes").document(docId).setData([
                        "no_likes": FieldValue.increment(Int64(-1))
                    ], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                    }
                } else if isFavourite == false{
                    
                    
                    
                    
                    db.collection("likedByUser").document(String(describing: userId!)).collection("news").document(docId).setData([
                        "isFavourite": true,
                    ], merge: true)
                    
                    db.collection("likes").document(docId).setData([
                        "no_likes": FieldValue.increment(Int64(1))
                    ], merge: true) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        }
                    }
                }
        
        
        
        UIView.animate(withDuration: 0.4,
            animations: {
                self.likeButton.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.4) {
                    if(self.isFavourite == false){
                        self.likeButton.transform = CGAffineTransform.identity
                        self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                    else{
                        self.likeButton.transform = CGAffineTransform.identity
                        self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    }
                }
            })
        
    
    }
    
    @IBAction func showComments(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "modalController") as? modalController
               else {
                   return
               }
               
                vc.docId = String(article!.id)
               
               navigationController?.present(vc, animated: true)
    }
    @IBAction func comment(_ sender: Any) {
        let docId = String(article!.id)
        let user = Auth.auth().currentUser
        
        db.collection("comments").document(docId).collection("comment").addDocument(data: [
                    "comment": commentField.text,
                    "user": user?.displayName,
                    "timestamp": FieldValue.serverTimestamp()
                ])
        let alerta = UIAlertController(title: "Sucesso", message: "O seu comentário foi enviado com sucesso", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alerta, animated: true, completion: nil)
        
    }
   
}


