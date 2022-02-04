//
//  favouriteModel.swift
//  APAE
//
//  Created by Rui Costa on 03/02/2022.
//

import Foundation
struct FavouriteModel: Codable {
       let id: Int
       let title: String
       let imageURL: URL?
       let newsSite: String?
       let publishedAt: String?
        var imageData: Data? = nil
}
