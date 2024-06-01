//
//  SearchViewModel.swift
//  Search
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation
import AppFoundation
import Domain
import Coordinator

public final class SearchViewModel: ViewModel, CoordinatorViewModel {
  
  public struct BookList: Equatable {
    private(set) var id: UUID = UUID()
    let itemList: [Book]
    
    init(itemList: [Book], id: UUID? = nil) {
      self.itemList = itemList
      if let id {
        self.id = id
      }
    }
  }
  
  public enum Action {
    case search(keyword: String)
    case moreSearch
    case moveToDetail(id: String, title: String)
  }
  
  public enum Effect {
    case setIsLoading(Bool)
    case setError(NSError?)
    case setBookList(BookList)
    case appendBookList([Book])
  }
  
  public struct State: Equatable {
    var isLoading: Pulse<Bool> = .init(wrappedValue: false)
    var err: Pulse<NSError?> = .init(wrappedValue: nil)
    var bookList: Pulse<BookList> = .init(wrappedValue: .init(itemList: []))
  }
  
  // MARK: - private property
  
  private let searchUsecase: SearchUsecase
  
  // MARK: - public property
  
  public var state: Observable<State> = Observable<State>()
  public var coordinator: Coordinator?
  
  // MARK: - lifeCycle
  
  public init(
    coordinator: Coordinator?,
    searchUsecase: SearchUsecase
  ) {
    self.coordinator = coordinator
    self.state.onNext(State())
    self.searchUsecase = searchUsecase
  }
  
  public func send(_ input: Action) {
    switch input {
    case .search(let keyword):
      Task { [weak self] in
        self?.applyEffect(.setIsLoading(true))
        guard let searchResult = await self?.searchBookList(keyword: keyword) else { return }
        switch searchResult {
        case .success(let bookList):
          self?.applyEffect(.setBookList(.init(itemList: bookList)))
        case .failure(let err):
          guard !(err is SearchError) else { return }
          self?.applyEffect(.setError(err as NSError))
        }
        self?.applyEffect(.setIsLoading(false))
      }
    case .moreSearch:
      if self.searchUsecase.isEndOfReach || self.searchUsecase.isQuerying { return }
      Task { [weak self] in
        self?.applyEffect(.setIsLoading(true))
        guard let searchResult = await self?.moreBookList() else { return }
        switch searchResult {
        case .success(let bookList):
          self?.applyEffect(.appendBookList(bookList))
        case .failure(let err):
          guard !(err is SearchError) else { return }
          self?.applyEffect(.setError(err as NSError))
        }
        self?.applyEffect(.setIsLoading(false))
      }
    case .moveToDetail(let id, let title):
      self.coordinator?.navigate(to: .detailIsRequired(id: id, title: title))
    }
  }
  
  public func applyEffect(_ effect: Effect) {
    var newState = self.state.value ?? State()
    
    switch effect {
    case .setIsLoading(let isLoading):
      newState.isLoading = .init(wrappedValue: isLoading, oldPulse: newState.isLoading)
    case .setError(let err):
      newState.err = .init(wrappedValue: err, oldPulse: newState.err)
    case .setBookList(let list):
      newState.bookList = .init(wrappedValue: list, oldPulse: newState.bookList)
    case .appendBookList(let list):
      newState.bookList = .init(wrappedValue: .init(itemList: newState.bookList.value.itemList + list, id: newState.bookList.value.id), oldPulse: newState.bookList)
    }
    
    self.state.onNext(newState)
  }
  
  // MARK: - private method
  
  private func searchBookList(keyword: String) async -> Result<[Book], Error> {
    return await self.searchUsecase.searchBookList(keyword: keyword)
  }
  
  private func moreBookList() async -> Result<[Book], Error> {
    return await self.searchUsecase.moreBookList()
  }
  
  // MARK: - public method
  
  public func endFlow() {
    // 뒤로 갈 화면이 없음
  }

}
