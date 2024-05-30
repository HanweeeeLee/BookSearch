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
  
  private var bookList: Pulse<[Book]> = .init(wrappedValue: []) {
    didSet {
      if oldValue.valueUpdatedCount != bookList.valueUpdatedCount {
        DispatchQueue.main.async { [weak self] in
          self?.tableView.reloadData()
        }
      }
    }
  }
  
  private var isLoading: Pulse<Bool> = .init(wrappedValue: false) {
    didSet {
      if oldValue.valueUpdatedCount != isLoading.valueUpdatedCount {
        DispatchQueue.main.async { [weak self] in
          if self?.isLoading.value == true {
            self?.loadingIndicator.startAnimating()
          } else {
            self?.loadingIndicator.stopAnimating()
          }
        }
      }
    }
  }
  
  private var err: Pulse<NSError?> = .init(wrappedValue: nil) {
    didSet {
      if oldValue.valueUpdatedCount != err.valueUpdatedCount {
        guard let err = self.err.value else { return }
        DispatchQueue.main.async { [weak self] in
          let alertController = UIAlertController(title: "Error", message: err.localizedDescription, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
          alertController.addAction(okAction)
          self?.present(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  
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
    bind(viewModel: self.viewModel)
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public func bind(viewModel: SearchViewModel) {
    
    viewModel.state.subscribe { [weak self] state in
      self?.isLoading = state.isLoading
      self?.bookList = state.bookList
      self?.err = state.err
    }
    .disposed(by: self.disposeBag)
    
  }
  
  // MARK: - private method
  
  private func setupUI() {
    view.addSubview(backgroundView)
    backgroundView.fillSuperview()
    
    backgroundView.addSubview(baseView)
    baseView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    
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
    return self.bookList.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell: BookTableViewCell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
    if let info = self.bookList.value[safe: indexPath.row] {
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
      self.viewModel.send(.moreSearch)
    }
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
