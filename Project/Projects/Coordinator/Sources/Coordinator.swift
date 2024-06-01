//
//  Coordinator.swift
//  Coordinator
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: AnyObject {
  
  var root: UIViewController { get }
  var parentsCoordinator: Coordinator? { get }
  
  func navigate(to: CoordinatorRoute)
  
}
