//
//  SearchRepositoryImplement.swift
//  Data
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation
import Domain
import AppNetwork

public final class SearchRepositoryImplement: SearchRepository {
  
  // MARK: - private property
  
  // MARK: - public property
  
  // MARK: - lifeCycle
  
  public init() {
    
  }
  
  // MARK: - private method
  
  // MARK: - public method
  
  public func searchBookList(keyword: String, page: UInt) async -> Result<[Book], Error> {
    let result: Result<SearchResponseDTO, NetworkManager.NetworkError> = await NetworkManager.shared.requestData(target: ITBookAPI.searchBook(keyword: keyword, page: page))
    switch result {
    case .success(let response):
      return .success(response.books.map {
        .init(
          id: $0.id,
          title: $0.title,
          subTitle: $0.subTitle,
          price: $0.price,
          imageUrl: $0.imageUrl,
          linkUrl: $0.linkUrl
        )
      })
    case .failure(let err):
      return .failure(err)
    }
  }
  
}
