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
  associatedtype Effect
  associatedtype State: Equatable
  
  var state: Observable<State> { get }

  func send(_ input: Action)
  func applyEffect(_ effect: Effect)
}
