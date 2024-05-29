//
//  BookDTO.swift
//  Data
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

struct BookDTO: Decodable {
  
  let id: String
  let title: String
  let subTitle: String
  let price: String
  let imageUrl: URL?
  let linkUrl: URL?
  
  enum CodingKeys: String, CodingKey {
    case id = "isbn13"
    case title
    case subTitle = "subtitle"
    case price
    case imageUrl = "image"
    case linkUrl = "url"
  }
  
}

struct SearchResponseDTO: Decodable {
  let error: String
  let total: String
  let page: String
  let books: [BookDTO]
}
