//
//  SearchCoordinator.swift
//  App
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Coordinator
import Domain
import Foundation
import UIKit
import Search
import Data

final class SearchCoordinator: Coordinator {

  // MARK: private property
  
  private var viewModel: SearchViewModel?

  // MARK: internal property

  var root: UIViewController
  var parentsCoordinator: Coordinator?

  // MARK: lifeCycle

  init(root: UIViewController, parentsCoordinator: Coordinator? = nil) {
    self.root = root
    self.parentsCoordinator = parentsCoordinator
  }
  
  deinit {
    print("\(self) deinit")
  }

  // MARK: private function

  // MARK: internal function

  func navigate(to: CoordinatorRoute) {
    switch to {
    case .searchIsRequired:
      let viewModel = SearchViewModel(
        coordinator: self,
        searchUsecase: SearchUsecaseImplement(
          repository: SearchRepositoryImplement()
        )
      )
      self.viewModel = viewModel
      let vc = SearchViewController(viewModel: viewModel)
      (self.root as? UINavigationController)?.pushViewController(vc, animated: true)
    case .detailIsRequired(let id, let title):
      let coordinator = DetailCoordinator(
        root: self.root,
        parentsCoordinator: self
      )
      coordinator.navigate(to: .detailIsRequired(id: id, title: title))
    default:
      break
    }
  }


}
