//
//  AppCoordinator.swift
//  App
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Coordinator
import Domain
import Foundation
import UIKit

final class AppCoordinator: Coordinator {

  // MARK: private property

  // MARK: internal property

  var root: UIViewController
  var parentsCoordinator: Coordinator? = nil

  // MARK: lifeCycle

  init(root: UIViewController) {
    self.root = root
  }

  // MARK: private function

  // MARK: internal function

  func navigate(to: CoordinatorRoute) {
    switch to {
    case .searchIsRequired:
      let searchCoordinator = SearchCoordinator(
        root: self.root,
        parentsCoordinator: self
      )
      searchCoordinator.navigate(to: .searchIsRequired)
    default:
      break
    }
  }


}
