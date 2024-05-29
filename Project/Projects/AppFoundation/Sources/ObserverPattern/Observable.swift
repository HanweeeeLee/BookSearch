//
//  Observable.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import Foundation

public class Observable<T> {
  
  // MARK: private property
  
  private var observers: [UUID: (T) -> Void] = [:]
  
  // MARK: public property
  
  private(set) public var value: T? {
    didSet {
      notifyObservers()
    }
  }
  
  // MARK: lifeCycle
  
  public init() { }
  
  // MARK: private method
  
  private func notifyObservers() {
    if let value = value {
      observers.values.forEach { $0(value) }
    }
  }
  
  // MARK: public metohd
  
  public func subscribe(_ observer: @escaping (T) -> Void) -> Disposable {
    let id = UUID()
    observers[id] = observer
    if let value = value {
      observer(value)
    }
    return SubscriptionDisposable { [weak self] in
      self?.observers.removeValue(forKey: id)
    }
  }
  
  public func onNext(_ value: T) {
    self.value = value
  }
  
}

public class SubscriptionDisposable: Disposable {
  private let disposeAction: () -> Void
  
  public init(disposeAction: @escaping () -> Void) {
    self.disposeAction = disposeAction
  }
  
  public func dispose() {
    disposeAction()
  }
}
