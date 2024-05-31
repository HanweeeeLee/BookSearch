//
//  DetailUsecaseTests.swift
//  Domain
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest
@testable import Domain

final class DetailUsecaseTests: XCTestCase {
  
  var stubRepository: StubDetailRepository!
  var detailUsecase: DetailUsecaseImplement!
  
  override func setUp() {
    super.setUp()
    stubRepository = StubDetailRepository()
    detailUsecase = DetailUsecaseImplement(repository: stubRepository)
  }
  
  override func tearDown() {
    stubRepository = nil
    detailUsecase = nil
    super.tearDown()
  }
  
  func testBookDetailSuccess() async {
    // Given
    let expectedBookDetail = BookDetail(
      id: "123",
      title: "Swift Programming",
      subTitle: "The Big Nerd Ranch Guide",
      price: "$39.99",
      imageUrl: nil,
      linkUrl: nil,
      page: 480,
      publishedYear: 2021,
      rating: 4.5,
      language: "English",
      publisher: "Big Nerd Ranch",
      authors: "Matthew Mathias, John Gallagher",
      description: "A comprehensive guide to Swift programming.", 
      pdfUrls: ["Chapter1": URL(string: "https://naver.com")!]
    )
    stubRepository.result = .success(expectedBookDetail)
    
    // When
    let result = await detailUsecase.bookDetail(id: "123")
    
    // Then
    switch result {
    case .success(let bookDetail):
      XCTAssertEqual(bookDetail.id, expectedBookDetail.id, "책 ID가 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.title, expectedBookDetail.title, "책 제목이 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.subTitle, expectedBookDetail.subTitle, "책 부제목이 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.price, expectedBookDetail.price, "책 가격이 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.page, expectedBookDetail.page, "책 페이지 수가 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.publishedYear, expectedBookDetail.publishedYear, "출판 연도가 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.rating, expectedBookDetail.rating, "책 평점이 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.language, expectedBookDetail.language, "언어가 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.publisher, expectedBookDetail.publisher, "출판사가 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.authors, expectedBookDetail.authors, "저자가 예상과 같아야 합니다.")
      XCTAssertEqual(bookDetail.description, expectedBookDetail.description, "책 설명이 예상과 같아야 합니다.")
    case .failure(let error):
      XCTFail("성공을 예상했으나 실패가 발생했습니다: \(error)")
    }
  }
  
  func testBookDetailFailure() async {
    // Given
    struct TestError: Error {}
    stubRepository.result = .failure(TestError())
    
    // When
    let result = await detailUsecase.bookDetail(id: "123")
    
    // Then
    switch result {
    case .success:
      XCTFail("실패를 예상했으나 성공이 발생했습니다.")
    case .failure:
      XCTAssertTrue(true, "에러가 발생해야 합니다.")
    }
  }
}

class StubDetailRepository: DetailRepository {
  
  var result: Result<BookDetail, Error>!
  
  func bookDetail(id: String) async -> Result<BookDetail, any Error> {
    return result
  }
}
