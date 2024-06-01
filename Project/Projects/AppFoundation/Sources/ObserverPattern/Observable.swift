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
      self.previousValue = oldValue
      notifyObservers()
    }
  }
  
  private(set) public var previousValue: T?
  
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
  
  public func map<U>(_ transform: @escaping (T) -> U) -> Observable<U> {
    let newObservable = Observable<U>()
    _ = self.subscribe { value in
      newObservable.onNext(transform(value))
    }
    return newObservable
  }
  
  public func withPrevious(_ predicate: @escaping (T, T?) -> Bool) -> Observable<T> {
    let newObservable = Observable<T>()
    _ = self.subscribe { newValue in
      if predicate(newValue, self.previousValue) {
        newObservable.onNext(newValue)
      }
    }
    return newObservable
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
