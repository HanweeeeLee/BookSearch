//
//  ViewController.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import UIKit
import Domain
import Detail

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func testStartAction(_ sender: Any) {
    let vc = DetailViewController(
      viewModel: DetailViewModel(
        coordinator: nil, 
        detailUsecase: DetailUsecaseImplement(
          repository: StubDetailRepositoryImplement()
        ),
        bookId: "123"
      )
    )
    self.present(vc, animated: true)
  }
  
}

class StubDetailRepositoryImplement: DetailRepository {
  
  func bookDetail(id: String) async -> Result<BookDetail, Error> {
    return .success(BookDetail(
      id: "123",
      title: "훈민정음",
      subTitle: "백성을 가르치는 바른 소리",
      price: "$99.99",
      imageUrl: URL(string: "https://itbook.store/img/books/9781491900826.png"),
      linkUrl: URL(string: "https://naver.com"),
      page: 480,
      publishedYear: 1444,
      rating: 5.0,
      language: "Korean",
      publisher: "집현전",
      authors: "세종대왕",
      description: "나랏말싸미 듕귁에 달아 문자와로 서르 사맛디 아니할쎄\n이런 젼차로 어린 백셩이 니르고져 홀 배 이셔도\n마참내 제 뜨들 시러펴디 몯 할 노미 하니라\n내 이랄 위하야 어엿비 너겨 새로 스믈 여듧 짜랄 맹가노니\n사람마다 해여 수비 니겨 날로 쑤메 뼌한킈 하고져 할따라미니라",
      pdfUrls: [
        "Chapter 2": URL(string:"https://itbook.store/files/9781617294136/chapter2.pdf")!,
        "Chapter 5": URL(string:"https://itbook.store/files/9781617294136/chapter5.pdf")!
      ]
    ))
  }
  
}

