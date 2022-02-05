//
//  CommentsTableViewCell.swift
//  APAE
//
//  Created by Rui Costa on 01/02/2022.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
