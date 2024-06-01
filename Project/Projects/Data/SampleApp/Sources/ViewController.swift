//
//  ViewController.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import UIKit
import Data
import Domain

class ViewController: UIViewController {
  
  @IBOutlet weak var bookSearchTextField: UITextField!
  @IBOutlet weak var detailBookTextField: UITextField!
  
  let searchUsecase: SearchUsecase = SearchUsecaseImplement(
    countOfResponsesPerQuestion: 10,
    repository: SearchRepositoryImplement()
  )
  
  let detailUsecase: DetailUsecase = DetailUsecaseImplement(
    repository: DetailRepositoryImplement()
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    self.detailBookTextField.text = "9780134431598"
  }

  @IBAction func searchBook(_ sender: Any) {
    Task {
      guard let keyword = self.bookSearchTextField.text else { return }
      let result = await self.searchUsecase.searchBookList(keyword: keyword)
      switch result {
      case .success(let bookList):
        print("bookList: \(bookList)")
      case .failure(let err):
        print("book search err:\(err.localizedDescription)")
      }
    }
  }
  
  @IBAction func bookDetail(_ sender: Any) {
    Task {
      guard let searchId = self.detailBookTextField.text else { return }
      let result = await self.detailUsecase.bookDetail(id: searchId)
      switch result {
      case .success(let detail):
        print("detail: \(detail)")
      case .failure(let err):
        print("book detail err:\(err.localizedDescription)")
      }
    }
  }
  
}
