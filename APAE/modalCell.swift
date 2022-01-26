//
//  modalCell.swift
//  APAE
//
//  Created by Rui Costa on 21/01/2022.
//

import Foundation
import UIKit

class modalCellModel {
    let nome: String
    let comentario: String
    let data : String
    
    init(
     nome: String,
     comentario: String,
     data : String
    ){
        self.nome = nome
        self.comentario = comentario
        self.data = data
        
    }
}

class modalCell : UITableViewCell {
    
    static let identifier = "modalCell"
    
    private let commentLabel : UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(commentLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func prepareForReuse() {
        commentLabel.text = nil
    }
    
    func configure(with viewModel : modalCellModel){
        commentLabel.text = viewModel.comentario
    }
    
}
