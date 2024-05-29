//
//  DetailRepositoryImplement.swift
//  Data
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation
import Domain
import AppNetwork

public final class DetailRepositoryImplement: DetailRepository {
  
  // MARK: - private property
  
  // MARK: - public property
  
  // MARK: - lifeCycle
  
  public init() {
    
  }
  
  // MARK: - private method
  
  // MARK: - public method
  
  public func bookDetail(id: String) async -> Result<BookDetail, Error> {
    let result: Result<DetailDTO, NetworkManager.NetworkError> = await NetworkManager.shared.requestData(target: ITBookAPI.bookDetail(id: id))
    switch result {
    case .success(let dtoModel):
      return .success(
        .init(
          id: dtoModel.id,
          title: dtoModel.title,
          subTitle: dtoModel.subTitle,
          price: dtoModel.price,
          imageUrl: dtoModel.imageUrl,
          linkUrl: dtoModel.linkUrl,
          page: dtoModel.page,
          publishedYear: dtoModel.publishedYear,
          rating: dtoModel.rating,
          language: dtoModel.language,
          publisher: dtoModel.publisher,
          authors: dtoModel.authors,
          description: dtoModel.description
        )
      )
    case .failure(let err):
      return .failure(err)
    }
    
  }
  
}
