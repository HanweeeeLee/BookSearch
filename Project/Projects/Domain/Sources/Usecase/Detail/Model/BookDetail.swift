//
//  BookDetail.swift
//  Domain
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public struct BookDetail: Equatable {
  public let id: String
  public let title: String
  public let subTitle: String
  public let price: String
  public let imageUrl: URL?
  public let linkUrl: URL?
  public let page: UInt
  public let publishedYear: UInt
  public let rating: Double
  public let language: String
  public let publisher: String
  public let authors: String
  public let description: String
  
  public init(
    id: String,
    title: String,
    subTitle: String,
    price: String,
    imageUrl: URL?,
    linkUrl: URL?,
    page: UInt,
    publishedYear: UInt,
    rating: Double,
    language: String,
    publisher: String,
    authors: String,
    description: String
  ) {
    self.id = id
    self.title = title
    self.subTitle = subTitle
    self.price = price
    self.imageUrl = imageUrl
    self.linkUrl = linkUrl
    self.page = page
    self.publishedYear = publishedYear
    self.rating = rating
    self.language = language
    self.publisher = publisher
    self.authors = authors
    self.description = description
  }
  
  public static func == (lhs: BookDetail, rhs: BookDetail) -> Bool {
    return lhs.id == rhs.id
  }
  
}
