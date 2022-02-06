//
//  QRController.swift
//  APAE
//
//  Created by Rui Costa on 26/01/2022.
//

import Foundation
import UIKit


class QRController: UIViewController {

    @IBOutlet var qrImage: UIImageView!
    
    
    static let identifier = "QRController"
    var articleURL: String!
    let defaultHeight: CGFloat = 300
    //Url of the api that converts any string to qr code
    let APIurl = "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue.withAlphaComponent(0)
        
        //Concatenate the API url with the article URL
        let url = URL(string: APIurl + articleURL)
        
        
        URLSession.shared.dataTask(with: url!) { [weak self] data, _, error in
            //Get the data from the api
            guard let data = data, error == nil else{
                return
            }
            
            DispatchQueue.main.async {
                //Making it show in the imageView 
                self?.qrImage.image = UIImage(data: data)
            }
        }.resume()
        
    }
    
    
}
