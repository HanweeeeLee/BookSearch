//
//  ViewController.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import UIKit
import Search
import Domain

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func testStartAction(_ sender: Any) {
    let vc = SearchViewController(
      viewModel: SearchViewModel(
        coordinator: nil, 
        searchUsecase: SearchUsecaseImplement(
          countOfResponsesPerQuestion: 5,
          repository: StubSearchRepositoryImplement()
        )
      )
    )
    self.present(vc, animated: true)
  }
  
}

class StubSearchRepositoryImplement: SearchRepository {
  
  func searchBookList(keyword: String, page: UInt) async -> Result<[Book], any Error> {
    return .success([
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
      ),
      Book(
        id: "9781119022220",
        title: "Swift For Dummies",
        subTitle: "",
        price: "$21.03",
        imageUrl: URL(string: "https://itbook.store/img/books/9781119022220.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781119022220")
      ),
      Book(
        id: "9781484204078",
        title: "Transitioning to Swift",
        subTitle: "",
        price: "$25.84",
        imageUrl: URL(string: "https://itbook.store/img/books/9781484204078.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781484204078")
      ),
      Book(
        id: "9781484217535",
        title: "Beginning iPhone Development with Swift 2, 2nd Edition",
        subTitle: "Exploring the iOS 9 SDK",
        price: "$25.00",
        imageUrl: URL(string: "https://itbook.store/img/books/9781484217535.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781484217535")
      ),
      Book(
        id: "9781484218792",
        title: "OS X App Development with CloudKit and Swift",
        subTitle: "",
        price: "$37.87",
        imageUrl: URL(string: "https://itbook.store/img/books/9781484218792.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781484218792")
      ),
      Book(
        id: "9781484230657",
        title: "Learn Computer Science with Swift",
        subTitle: "Computation Concepts, Programming Paradigms, Data Management, and Modern Component Architectures with Swift and Playgrounds",
        price: "$17.23",
        imageUrl: URL(string: "https://itbook.store/img/books/9781484230657.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781484230657")
      ),
      Book(
        id: "9781484263297",
        title: "Deep Learning with Swift for TensorFlow",
        subTitle: "Differentiable Programming with Swift",
        price: "$39.13",
        imageUrl: URL(string: "https://itbook.store/img/books/9781484263297.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781484263297")
      ),
      Book(
        id: "9781491900826",
        title: "OpenStack Swift",
        subTitle: "Using, Administering, and Developing for Swift Object Storage",
        price: "$5.31",
        imageUrl: URL(string: "https://itbook.store/img/books/9781491900826.png"),
        linkUrl: URL(string: "https://itbook.store/books/9781491900826")
      )
    ])
  }
  
}
