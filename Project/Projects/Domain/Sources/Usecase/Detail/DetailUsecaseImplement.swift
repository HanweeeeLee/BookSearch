//
//  DetailUsecaseImplement.swift
//  Domain
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public final class DetailUsecaseImplement: DetailUsecase {
  
  // MARK: - private property
  
  private let repository: DetailRepository
  
  // MARK: - public property
  
  // MARK: - lifeCycle
  
  public init(repository: DetailRepository) {
    self.repository = repository
  }
  
  // MARK: - private method
  
  // MARK: - public method
  
  public func bookDetail(id: String) async -> Result<BookDetail, Error> {
    return await self.repository.bookDetail(id: id)
  }
  
}
