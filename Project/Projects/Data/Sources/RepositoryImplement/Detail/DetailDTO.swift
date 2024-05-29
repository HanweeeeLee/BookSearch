//
//  DetailDTO.swift
//  Data
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

struct DetailDTO: Decodable {
  
  let id: String
  let title: String
  let subTitle: String
  let price: String
  let imageUrl: URL?
  let linkUrl: URL?
  let page: UInt
  let publishedYear: UInt
  let rating: Double
  let language: String
  let publisher: String
  let authors: String
  let description: String
  
  enum CodingKeys: String, CodingKey {
    case id = "isbn13"
    case title
    case subTitle = "subtitle"
    case price
    case imageUrl = "image"
    case linkUrl = "url"
    case page = "pages"
    case publishedYear = "year"
    case rating = "rating"
    case language
    case publisher
    case authors
    case description = "desc"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(String.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    subTitle = try container.decode(String.self, forKey: .subTitle)
    price = try container.decode(String.self, forKey: .price)
    imageUrl = try container.decodeIfPresent(URL.self, forKey: .imageUrl)
    linkUrl = try container.decodeIfPresent(URL.self, forKey: .linkUrl)
    
    let pageString = try container.decode(String.self, forKey: .page)
    page = UInt(pageString) ?? 0
    
    let yearString = try container.decode(String.self, forKey: .publishedYear)
    publishedYear = UInt(yearString) ?? 0
    
    let ratingString = try container.decode(String.self, forKey: .rating)
    rating = Double(ratingString) ?? 0
    
    language = try container.decode(String.self, forKey: .language)
    publisher = try container.decode(String.self, forKey: .publisher)
    authors = try container.decode(String.self, forKey: .authors)
    description = try container.decode(String.self, forKey: .description)
  }
  
}
