//
//  SearchViewController.swift
//  Search
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit
import Domain
import AppFoundation

public final class SearchViewController: UIViewController, View {
  
  // MARK: - UIProperty
  
  private let backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    return view
  }()
  
  private let baseView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    return view
  }()
  
  private lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "책 검색"
    searchBar.delegate = self
    searchBar.returnKeyType = .search
    return searchBar
  }()
  
  private lazy var tableView: UITableView = {
    let view = UITableView(frame: .zero, style: .plain)
    view.delegate = self
    view.dataSource = self
    view.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
    return view
  }()
  
  private let loadingIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.hidesWhenStopped = true
    return indicator
  }()
  
  // MARK: - private property
  
  public var viewModel: SearchViewModel
  public var disposeBag = DisposeBag()
  
  private var bookList: SearchViewModel.BookList = .init(itemList: [])
  
  // MARK: - public property
  
  // MARK: - lifeCycle
  
  public init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func loadView() {
    super.loadView()
    setupUI()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "검색"
    bind(viewModel: self.viewModel)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public func bind(viewModel: SearchViewModel) {
    
    viewModel.state.map { $0.bookList }
      .withPrevious { newValue, oldValue in
        return newValue.valueUpdatedCount != oldValue?.valueUpdatedCount
      }
      .subscribe { [weak self] bookList in
        if let oldBookList = self?.bookList {
          self?.bookList = bookList.value
          if bookList.value.id != oldBookList.id {
            DispatchQueue.main.async { [weak self] in
              self?.tableView.reloadData()
            }
          } else {
            let startIndex = oldBookList.itemList.count
            let endIndex = startIndex + bookList.value.itemList.count - oldBookList.itemList.count
            let indexPaths = (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
            DispatchQueue.main.async { [weak self] in
              self?.tableView.beginUpdates()
              self?.tableView.insertRows(at: indexPaths, with: .automatic)
              self?.tableView.endUpdates()
            }
          }
        } else {
          self?.bookList = bookList.value
          DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
          }
        }
      }
      .disposed(by: self.disposeBag)
    
    viewModel.state.map { $0.err }
      .withPrevious { newValue, oldValue in
        return newValue.valueUpdatedCount != oldValue?.valueUpdatedCount
      }
      .subscribe { [weak self] err in
        if let err = err.value {
          DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
          }
        }
      }
      .disposed(by: self.disposeBag)
    
    viewModel.state.map { $0.isLoading }
      .withPrevious { newValue, oldValue in
        return newValue.valueUpdatedCount != oldValue?.valueUpdatedCount
      }
      .subscribe { [weak self] isLoading in
        DispatchQueue.main.async {
          if isLoading.value {
            self?.loadingIndicator.startAnimating()
          } else {
            self?.loadingIndicator.stopAnimating()
          }
        }
      }
      .disposed(by: self.disposeBag)
    
  }
  
  // MARK: - private method
  
  private func setupUI() {
    view.addSubview(backgroundView)
    backgroundView.fillSuperview()
    
    backgroundView.addSubview(baseView)
    baseView.fillSuperview()
    
    baseView.addSubview(searchBar)
    baseView.addSubview(tableView)
    baseView.addSubview(loadingIndicator)
    
    searchBar.anchor(top: baseView.safeAreaLayoutGuide.topAnchor, leading: baseView.leadingAnchor, trailing: baseView.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
    
    tableView.anchor(top: searchBar.bottomAnchor, leading: baseView.leadingAnchor, bottom: baseView.bottomAnchor, trailing: baseView.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    loadingIndicator.centerInSuperview()
  }
  
  // MARK: - public method
  
  
  
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.bookList.itemList.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
    if let info = self.bookList.itemList[safe: indexPath.row] {
      cell.setConfigure(info)
    }
    return cell
  }
  
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    
    if offsetY > contentHeight - scrollView.frame.height {
      if self.bookList.itemList.count > 0 {
        self.viewModel.send(.moreSearch)
      }
    }
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = self.bookList.itemList[safe: indexPath.row] else { return }
    self.viewModel.send(.moveToDetail(id: item.id, title: item.title))
  }
  
}

extension SearchViewController: UISearchBarDelegate {
  
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    DispatchQueue.main.async { [weak self] in
      guard let keyword = searchBar.text, !keyword.isEmpty else { return }
      self?.viewModel.send(.search(keyword: keyword))
    }
  }
  
}
