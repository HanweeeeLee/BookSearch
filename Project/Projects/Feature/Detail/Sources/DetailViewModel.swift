//
//  DetailViewModel.swift
//  Detail
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation
import AppFoundation
import Domain

public final class DetailViewModel: ViewModel {
  
  public enum Action {
    case requestDetail
  }
  
  public enum Effect {
    case setIsLoading(Bool)
    case setError(NSError?)
    case setBookDetail(BookDetail)
  }
  
  public struct State: Equatable {
    var isLoading: Pulse<Bool> = .init(wrappedValue: false)
    var err: Pulse<NSError?> = .init(wrappedValue: nil)
    var bookDetail: Pulse<BookDetail?> = .init(wrappedValue: nil)
  }
  
  // MARK: - private property
  
  private let detailUsecase: DetailUsecase
  private let bookId: String
  
  // MARK: - public property
  
  public var state: Observable<State> = Observable<State>()
  
  // MARK: - lifeCycle
  
  public init(
    detailUsecase: DetailUsecase,
    bookId: String
  ) {
    self.state.onNext(State())
    self.bookId = bookId
    self.detailUsecase = detailUsecase
  }
  
  public func send(_ input: Action) {
    switch input {
    case .requestDetail:
      Task { [weak self] in
        self?.applyEffect(.setIsLoading(true))
        guard let searchResult = await self?.bookDetail(id: self?.bookId ?? "") else { return }
        switch searchResult {
        case .success(let info):
          self?.applyEffect(.setBookDetail(info))
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
    case .setBookDetail(let info):
      newState.bookDetail = .init(wrappedValue: info, oldPulse: newState.bookDetail)
    }
    
    self.state.onNext(newState)
  }
  
  // MARK: - private method
  
  private func bookDetail(id: String) async -> Result<BookDetail, Error> {
    return await self.detailUsecase.bookDetail(id: id)
  }
  
  // MARK: - public method
  
}
