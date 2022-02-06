//
//  NewsTableViewCell.swift
//  APAE
//
//  Created by Rui Costa on 20/12/2021.
//

import UIKit


class FavouritesViewCell: UITableViewCell {
    
    //Cell with the outlets of the storyboard
    @IBOutlet var newsImage: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var author: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
