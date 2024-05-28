//
//  ViewModel.swift
//  AppFoundation
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public protocol ViewModel: AnyObject {

  associatedtype Action
  associatedtype State

  func send(_ input: Action)
  var state: Observable<State> { get }
}
