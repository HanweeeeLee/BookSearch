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

public final class SearchViewModel: ViewModel {
  
  public enum Action {
    case search(keyword: String)
    case moreSearch
  }
  
  public enum Effect {
    case setIsLoading(Bool)
    case setError(NSError?)
    case setBookList([Book])
    case appendBookList([Book])
  }
  
  public struct State: Equatable {
    var isLoading: Pulse<Bool> = .init(wrappedValue: false)
    var err: Pulse<NSError?> = .init(wrappedValue: nil)
    var bookList: Pulse<[Book]> = .init(wrappedValue: [])
  }
  
  // MARK: - private property
  
  private let searchUsecase: SearchUsecase
  
  // MARK: - public property
  
  public var state: Observable<State> = Observable<State>()
  
  // MARK: - lifeCycle
  
  public init(
    searchUsecase: SearchUsecase
  ) {
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
          self?.applyEffect(.setBookList(bookList))
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
      newState.bookList = .init(wrappedValue: newState.bookList.value + list, oldPulse: newState.bookList)
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
  
}
