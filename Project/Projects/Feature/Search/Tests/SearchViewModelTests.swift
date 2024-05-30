//
//  SearchViewModelTests.swift
//  SearchTests
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest
import Domain
import AppFoundation
@testable import Search

class SearchViewModelTests: XCTestCase {
  
  var viewModel: SearchViewModel!
  var usecase: StubSearchUsecase!
  var disposeBag: DisposeBag = DisposeBag()
  
  override func setUp() {
    super.setUp()
    disposeBag = DisposeBag()
    usecase = StubSearchUsecase()
    viewModel = SearchViewModel(searchUsecase: usecase)
  }
  
  override func tearDown() {
    super.tearDown()
    disposeBag = DisposeBag()
    viewModel = nil
    usecase = nil
  }
  
  func testSearchSuccess() {
    // Given
    let books = [Book(
      id: "1",
      title: "Test Book",
      subTitle: "SubTitle",
      price: "10$",
      imageUrl: nil,
      linkUrl: nil
    )]
    usecase.searchResult = .success(books)
    let expectation = XCTestExpectation(description: "State updated with search results")
    
    // When
    viewModel.send(.search(keyword: "Test"))
    
    // Then
    viewModel.state.subscribe { state in
      if state.isLoading.valueUpdatedCount == 1 {
        XCTAssertTrue(state.isLoading.value, "로딩 상태가 false가 되어야 합니다")
      }
      if state.bookList.valueUpdatedCount != 0 {
        XCTAssertEqual(state.bookList.value, books, "검색 결과가 기대한 대로 설정되어야 합니다")
      }
      if state.isLoading.valueUpdatedCount == 2 {
        XCTAssertFalse(state.isLoading.value, "로딩 상태가 false가 되어야 합니다")
      }
      expectation.fulfill()
    }
    .disposed(by: self.disposeBag)
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testMoreSearchSuccess() {
    // Given
    let moreBooks = [Book(id: "2", title: "More Book", subTitle: "SubTitle", price: "15$", imageUrl: nil, linkUrl: nil)]
    usecase.moreResult = .success(moreBooks)
    let expectation = XCTestExpectation(description: "State updated with more search results")
    
    // When
    viewModel.send(.moreSearch)
    
    // Then
    viewModel.state.subscribe { [weak self] state in
      if state.isLoading.valueUpdatedCount == 1 {
        XCTAssertTrue(state.isLoading.value, "로딩 상태가 true가 되어야 합니다")
      }
      if state.bookList.valueUpdatedCount != 0 {
        XCTAssertEqual(state.bookList.value, moreBooks, "더 많은 검색 결과가 기대한 대로 설정되어야 합니다")
      }
      if state.isLoading.valueUpdatedCount == 2 {
        XCTAssertFalse(state.isLoading.value, "로딩 상태가 false가 되어야 합니다")
      }
      self?.disposeBag = DisposeBag()
      expectation.fulfill()
    }.disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testSearchFailure() {
    // Given
    let error = NSError(domain: "TestError", code: -1, userInfo: nil)
    usecase.searchResult = .failure(error)
    let expectation = XCTestExpectation(description: "State updated with search error")
    
    // When
    viewModel.send(.search(keyword: "Test"))
    
    // Then
    viewModel.state.subscribe { [weak self] state in
      if state.isLoading.valueUpdatedCount == 1 {
        XCTAssertTrue(state.isLoading.value, "로딩 상태가 true가 되어야 합니다")
      }
      if state.err.valueUpdatedCount != 0 {
        XCTAssertEqual(state.err.value, error, "오류 상태가 기대한 대로 설정되어야 합니다")
      }
      if state.isLoading.valueUpdatedCount == 2 {
        XCTAssertFalse(state.isLoading.value, "로딩 상태가 false가 되어야 합니다")
      }
      self?.disposeBag = DisposeBag()
      expectation.fulfill()
    }.disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testMoreSearchFailure() {
    // Given
    let error = NSError(domain: "TestError", code: -1, userInfo: nil)
    usecase.moreResult = .failure(error)
    let expectation = XCTestExpectation(description: "State updated with more search error")
    
    // When
    viewModel.send(.moreSearch)
    
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
  
  func testQueryInProgress() {
    // Given
    usecase.isQuerying = true
    let expectation = XCTestExpectation(description: "State updated with query in progress error")
    
    // When
    viewModel.send(.search(keyword: "Test"))
    
    // Then
    viewModel.state.subscribe { state in
      if state.isLoading.valueUpdatedCount != 0 {
        XCTAssertNil(state.err.value, "오류 상태가 nil이어야 합니다")
        XCTAssertTrue(state.bookList.value.isEmpty, "책 목록이 비어 있어야 합니다")
      }
      expectation.fulfill()
    }.disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 5)
  }
  
  func testEndOfReach() {
    // Given
    usecase.isEndOfReach = true
    let expectation = XCTestExpectation(description: "State updated with end of reach error")
    
    // When
    viewModel.send(.moreSearch)
    
    // Then
    viewModel.state.subscribe { state in
      if state.isLoading.valueUpdatedCount != 0 {
        XCTAssertNil(state.err.value, "오류 상태가 nil이어야 합니다")
        XCTAssertTrue(state.bookList.value.isEmpty, "책 목록이 비어 있어야 합니다")
      }
      expectation.fulfill()
    }.disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 5)
  }
  
}

class StubSearchUsecase: SearchUsecase {
  var isEndOfReach: Bool = false
  var isQuerying: Bool = false
  
  var searchResult: Result<[Book], Error> = .success([])
  var moreResult: Result<[Book], Error> = .success([])
  
  func searchBookList(keyword: String) async -> Result<[Book], Error> {
    isQuerying = true
    defer { isQuerying = false }
    return searchResult
  }
  
  func moreBookList() async -> Result<[Book], Error> {
    isQuerying = true
    defer { isQuerying = false }
    return moreResult
  }
  
}
