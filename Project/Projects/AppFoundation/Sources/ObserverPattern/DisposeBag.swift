//
//  DisposeBag.swift
//  CustomObservable
//
//  Created by hanwe on 5/27/24.
//

import Foundation

extension Disposable {
  func disposed(by disposeBag: DisposeBag) {
    disposeBag.add(self)
  }
}

class DisposeBag {
  private var disposables: [Disposable] = []
  
  public func add(_ disposable: Disposable) {
    disposables.append(disposable)
  }
  
  deinit {
    disposables.forEach { $0.dispose() }
  }
}
