//
//  SearchUsecaseTests.swift
//  Domain
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest
import AppFoundation
@testable import Domain

final class SearchUsecaseImplementTests: XCTestCase {
  
  var usecaseImplement: SearchUsecaseImplement!
  var repositoryStub: SearchRepositoryStub!
  
  override func setUp() {
    super.setUp()
    repositoryStub = SearchRepositoryStub()
    usecaseImplement = SearchUsecaseImplement(
      countOfResponsesPerQuestion: 3,
      repository: repositoryStub
    )
  }
  
  override func tearDown() {
    usecaseImplement = nil
    repositoryStub = nil
    super.tearDown()
  }
  
  func testSearchBookList_Success() async {
    // Given
    let expectedBookList: [Book] = [
      Book(
        id: "9780134431598",
        title: "Learning Swift 2 Programming, 2nd Edition",
        subTitle: "",
        price: "$28.32",
        imageUrl: URL(string: "https://itbook.store/img/books/9780134431598.png"),
        linkUrl: URL(string: "https://itbook.store/books/9780134431598")
      ),
      Book(
        id: "9780983066989",
        title: "A Swift Kickstart, 2nd Edition",
        subTitle: "Introducing the Swift Programming Language",
        price: "$29.99",
        imageUrl: URL(string: "https://itbook.store/img/books/9780983066989.png"),
        linkUrl: URL(string: "https://itbook.store/books/9780983066989")
      ),
      Book(
        id: "9781098118501",
        title: "iOS 15 Programming Fundamentals with Swift",
        subTitle: "Swift, Xcode, and Cocoa Basics",
        price: "$53.44",
        imageUrl: URL(string: "https://itbook.store/img/books/9781098118501.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781098118501")
      )
    ]
    repositoryStub.booKList = expectedBookList
    
    // When
    let result = await usecaseImplement.searchBookList(keyword: "a")
    
    // Then
    switch result {
    case .success(let bookList):
      XCTAssertEqual(bookList, expectedBookList, "예상된 도서 목록이 반환되어야 합니다.")
      XCTAssertFalse(usecaseImplement.isEndOfReach, "isEndOfReach가 false여야 합니다.")
    case .failure:
      XCTFail("성공을 예상했으나 실패했습니다.")
    }
  }
  
  func testSearchBookListButEndOfReach_Success() async {
    // Given
    let expectedBookList = [
      Book(
        id: "9780134431598",
        title: "Learning Swift 2 Programming, 2nd Edition",
        subTitle: "",
        price: "$28.32",
        imageUrl: URL(string: "https://itbook.store/img/books/9780134431598.png"),
        linkUrl: URL(string: "https://itbook.store/books/9780134431598")
      ),
      Book(
        id: "9780983066989",
        title: "A Swift Kickstart, 2nd Edition",
        subTitle: "Introducing the Swift Programming Language",
        price: "$29.99",
        imageUrl: URL(string: "https://itbook.store/img/books/9780983066989.png"),
        linkUrl: URL(string: "https://itbook.store/books/9780983066989")
      )
    ]
    repositoryStub.booKList = expectedBookList
    
    // When
    let result = await usecaseImplement.searchBookList(keyword: "a")
    
    // Then
    switch result {
    case .success(let bookList):
      XCTAssertEqual(bookList, expectedBookList, "예상된 도서 목록이 반환되어야 합니다.")
      XCTAssertTrue(usecaseImplement.isEndOfReach, "isEndOfReach가 true여야 합니다.")
    case .failure:
      XCTFail("성공을 예상했으나 실패했습니다.")
    }
  }
  
  func testMoreBookList_Success() async {
    // Given
    let initialBookList = [
      Book(
        id: "9780134431598",
        title: "Learning Swift 2 Programming, 2nd Edition",
        subTitle: "",
        price: "$28.32",
        imageUrl: URL(string: "https://itbook.store/img/books/9780134431598.png"),
        linkUrl: URL(string: "https://itbook.store/books/9780134431598")
      ),
      Book(
        id: "9780983066989",
        title: "A Swift Kickstart, 2nd Edition",
        subTitle: "Introducing the Swift Programming Language",
        price: "$29.99",
        imageUrl: URL(string: "https://itbook.store/img/books/9780983066989.png"),
        linkUrl: URL(string: "https://itbook.store/books/9780983066989")
      ),
      Book(
        id: "9781098118501",
        title: "iOS 15 Programming Fundamentals with Swift",
        subTitle: "Swift, Xcode, and Cocoa Basics",
        price: "$53.44",
        imageUrl: URL(string: "https://itbook.store/img/books/9781098118501.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781098118501")
      )
    ]
    let moreBookList = [
      Book(
        id: "9781119022220",
        title: "Swift For Dummies",
        subTitle: "",
        price: "$21.03",
        imageUrl: URL(string: "https://itbook.store/img/books/9781119022220.png")!,
        linkUrl: URL(string: "https://itbook.store/books/9781119022220")!
      ),
      Book(
        id: "9781484204078",
        title: "Transitioning to Swift",
        subTitle: "",
        price: "$25.84",
        imageUrl: URL(string: "https://itbook.store/img/books/9781484204078.png")!,
        linkUrl: URL(string: "https://itbook.store/books/9781484204078")!
      ),
      Book(
        id: "9781484217535",
        title: "Beginning iPhone Development with Swift 2, 2nd Edition",
        subTitle: "Exploring the iOS 9 SDK",
        price: "$25.00",
        imageUrl: URL(string: "https://itbook.store/img/books/9781484217535.png")!,
        linkUrl: URL(string: "https://itbook.store/books/9781484217535")!
      )
    ]
    repositoryStub.booKList = initialBookList
    await _ = usecaseImplement.searchBookList(keyword: "a")
    
    repositoryStub.booKList = moreBookList
    
    // When
    let result = await usecaseImplement.moreBookList()
    
    // Then
    switch result {
    case .success(let bookList):
      XCTAssertEqual(bookList, moreBookList, "예상된 추가 도서 목록이 반환되어야 합니다.")
    case .failure:
      XCTFail("성공을 예상했으나 실패했습니다.")
    }
  }
  
}

class SearchRepositoryStub: SearchRepository {
  
  var booKList: [Book] = []
  
  func searchBookList(keyword: String, page: UInt) async -> Result<[Book], Error> {
    return .success(booKList)
  }
}
