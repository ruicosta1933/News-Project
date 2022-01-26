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
    let url = "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.blue.withAlphaComponent(0)
        
        let test = URL(string: url + articleURL)
        
        
        URLSession.shared.dataTask(with: test!) { [weak self] data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            DispatchQueue.main.async {
                self?.qrImage.image = UIImage(data: data)
            }
        }.resume()
        
    }
    
    
}
