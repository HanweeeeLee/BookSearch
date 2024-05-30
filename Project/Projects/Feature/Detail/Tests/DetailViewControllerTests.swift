//
//  DetailViewControllerTests.swift
//  Detail
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest
import AppFoundation
import Domain
@testable import Detail

final class DetailViewModelTests: XCTestCase {
  
  var viewModel: DetailViewModel!
  var usecase: StubDetailUsecase!
  var disposeBag = DisposeBag()
  
  override func setUp() {
    super.setUp()
    self.usecase = StubDetailUsecase()
    self.viewModel = DetailViewModel(
      detailUsecase: usecase,
      bookId: "testBookId"
    )
    self.disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    self.viewModel = nil
    self.usecase = nil
    self.disposeBag = DisposeBag()
    super.tearDown()
  }
  
  func testDetailSuccess() {
    // Given
    let detail: BookDetail = BookDetail(
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
      description: "A comprehensive guide to Swift programming."
    )
    usecase.result = .success(detail)
    let expectation = XCTestExpectation(description: "상세 정보 얻어오는중")
    
    // When
    self.viewModel.send(.requestDetail)
    
    // Then
    self.viewModel.state.subscribe { state in
      if state.isLoading.valueUpdatedCount == 1 {
        XCTAssertTrue(state.isLoading.value, "로딩 상태가 false가 되어야 합니다")
      }
      if state.bookDetail.valueUpdatedCount != 0 {
        XCTAssertEqual(state.bookDetail.value, detail, "질의 결과가 기대한 대로 설정되어야 합니다")
      }
      if state.isLoading.valueUpdatedCount == 2 {
        XCTAssertFalse(state.isLoading.value, "로딩 상태가 false가 되어야 합니다")
      }
      expectation.fulfill()
    }
    .disposed(by: self.disposeBag)
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testDetailFailure() {
    // Given
    let error = NSError(domain: "TestError", code: -1, userInfo: nil)
    usecase.result = .failure(error)
    let expectation = XCTestExpectation(description: "State updated with search error")
    
    // When
    viewModel.send(.requestDetail)
    
    // Then
    viewModel.state.subscribe { state in
      if state.isLoading.valueUpdatedCount == 1 {
        XCTAssertTrue(state.isLoading.value, "로딩 상태가 true가 되어야 합니다")
      }
      if state.err.valueUpdatedCount != 0 {
        XCTAssertEqual(state.err.value, error, "오류 상태가 기대한 대로 설정되어야 합니다")
      }
      if state.isLoading.valueUpdatedCount == 2 {
        XCTAssertFalse(state.isLoading.value, "로딩 상태가 false가 되어야 합니다")
      }
      expectation.fulfill()
    }.disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 5)
  }
  
}


class StubDetailUsecase: DetailUsecase {
  var result: Result<BookDetail, Error>?
  
  func bookDetail(id: String) async -> Result<BookDetail, Error> {
    return result ?? .failure(NSError(domain: "MockError", code: 0, userInfo: nil))
  }
}
