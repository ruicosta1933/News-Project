//
//  CommentsTableViewCell.swift
//  APAE
//
//  Created by Rui Costa on 01/02/2022.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
//Cell with the outlets of the storyboard
    @IBOutlet var name: UILabel!
    @IBOutlet var comment: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
