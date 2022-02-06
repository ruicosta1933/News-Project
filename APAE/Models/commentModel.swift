//
//  commentModel.swift
//  APAE
//
//  Created by Rui Costa on 01/02/2022.
//

import Foundation

struct CommentsModel: Codable {
    //Model of a comment in this app
    let user: String
    let comment: String
    let date: String
}
