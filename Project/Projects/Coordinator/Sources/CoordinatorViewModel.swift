//
//  CoordinatorViewModel.swift
//  Coordinator
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public protocol CoordinatorViewModel {
  var coordinator: Coordinator? { get }
  
  func endFlow()
}
