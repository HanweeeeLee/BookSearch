//
//  DisposeBag.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import Foundation

extension Disposable {
  public func disposed(by disposeBag: DisposeBag) {
    disposeBag.add(self)
  }
}

public class DisposeBag {
  private var disposables: [Disposable] = []
  
  public func add(_ disposable: Disposable) {
    disposables.append(disposable)
  }
  
  public init() { }
  
  deinit {
    disposables.forEach { $0.dispose() }
  }
}
