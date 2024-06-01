//
//  ITBookAPI.swift
//  Data
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import AppNetwork
import Foundation

enum ITBookAPI {
  case searchBook(keyword: String, page: UInt)
  case bookDetail(id: String)
}

extension ITBookAPI: TargetType {
  
  var baseURL: URL {
    return URL(string: "https://api.itbook.store/1.0")!
  }
  
  var path: String {
    switch self {
    case .searchBook(let keyword, let page):
      return "/search/\(keyword)/\(page)"
    case .bookDetail(let id):
      return "/books/\(id)"
    }
  }
  
  var method: NetworkManager.HTTPMethod {
    switch self {
    case .searchBook:
      return .get
    case .bookDetail:
      return .get
    }
  }
  
  var task: NetworkManager.Task {
    switch self {
    case .searchBook:
      return .requestPlain
    case .bookDetail:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
  
}
