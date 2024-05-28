//
//  Book.swift
//  Domain
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation
import AppFoundation

public struct Book: Equatable {
  public let id: String
  public let title: String
  public let subTitle: String
  public let price: String
  public let imageUrl: URL?
  public let linkUrl: URL?
  
  public init(
    id: String,
    title: String,
    subTitle: String,
    price: String,
    imageUrl: URL?,
    linkUrl: URL?
  ) {
    self.id = id
    self.title = title
    self.subTitle = subTitle
    self.price = price
    self.imageUrl = imageUrl
    self.linkUrl = linkUrl
  }
  
  public static func == (lhs: Book, rhs: Book) -> Bool {
    return lhs.id == rhs.id
  }
  
}
