//
//  favouriteModel.swift
//  APAE
//
//  Created by Rui Costa on 03/02/2022.
//

import Foundation
struct FavouriteModel: Codable {
    //Model of a favourite in this app very similar to a news model
       let id: Int
       let title: String
       let imageURL: URL?
       let newsSite: String?
       let publishedAt: String?
        var imageData: Data? = nil
}
