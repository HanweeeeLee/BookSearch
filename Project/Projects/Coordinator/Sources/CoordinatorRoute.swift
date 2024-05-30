//
//  CoordinatorRoute.swift
//  Coordinator
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation
import Domain

public enum CoordinatorRoute {
  
  case searchIsRequired
  
  case detailIsRequired(id: String, title: String)
  case detailIsComplete
  
}
