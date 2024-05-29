//
//  SearchUsecaseImplement.swift
//  Domain
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import AppFoundation
import Foundation

/**
 이 클래스의 기능들은  thread safe함을 보장하지 않습니다.
 */
public final class SearchUsecaseImplement: SearchUsecase {
  
  // MARK: - private properties
  
  private let repository: SearchRepository
  private let countOfResponsesPerQuestion: UInt
  private var currentPage: UInt = 0
  private var currentKeyword: String = ""
  
  // MARK: - public properties
  
  private(set) public var isEndOfReach: Bool = false
  private(set) public var isQuerying: Bool = false
  
  // MARK: - life cycle
  
  public init(
    countOfResponsesPerQuestion: UInt = 10,
    repository: SearchRepository
  ) {
    self.countOfResponsesPerQuestion = countOfResponsesPerQuestion
    self.repository = repository
  }
  
  // MARK: - private method
  
  private func bookList(keyword: String, page: UInt) async -> Result<[Book], Error> {
    self.isQuerying = true
    defer { self.isQuerying = false }
    
    let result = await repository.searchBookList(keyword: keyword, page: page)
    switch result {
    case .success(let bookList):
      if bookList.count < countOfResponsesPerQuestion {
        isEndOfReach = true
      }
      return .success(bookList)
    case .failure(let err):
      return .failure(err)
    }
  }
  
  private func resetPagination() {
    currentPage = 0
    isEndOfReach = false
  }
  
  // MARK: - public method
  
  public func searchBookList(keyword: String) async -> Result<[Book], Error> {
    resetPagination()
    currentKeyword = keyword
    return await bookList(
      keyword: keyword,
      page: self.currentPage
    )
  }
  
  public func moreBookList() async -> Result<[Book], Error> {
    guard !isEndOfReach else { return .success([]) }
    self.currentPage += 1
    return await bookList(
      keyword: self.currentKeyword,
      page: self.currentPage
    )
  }
  
}
