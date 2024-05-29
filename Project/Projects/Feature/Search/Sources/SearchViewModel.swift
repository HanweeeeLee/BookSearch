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
    var isLoading: Bool = false
    var err: NSError?
    var bookList: [Book] = []
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
      newState.isLoading = isLoading
    case .setError(let err):
      newState.err = err
    case .setBookList(let list):
      newState.bookList = list
    case .appendBookList(let list):
      newState.bookList = newState.bookList + list
    }
    
    self.state.onNext(newState)
    if let _ = newState.err {
      var clearErrState = newState
      clearErrState.err = nil
      self.state.onNext(clearErrState)
    }
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
