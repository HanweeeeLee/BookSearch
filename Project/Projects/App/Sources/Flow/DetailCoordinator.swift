//
//  DetailCoordinator.swift
//  App
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Coordinator
import Domain
import Foundation
import UIKit
import Detail
import Data
import UIComponents

final class DetailCoordinator: Coordinator {
  
  // MARK: private property
  
  private var viewModel: DetailViewModel?
  
  // MARK: internal property
  
  var root: UIViewController
  var parentsCoordinator: Coordinator?
  
  // MARK: lifeCycle
  
  init(root: UIViewController, parentsCoordinator: Coordinator? = nil) {
    self.root = root
    self.parentsCoordinator = parentsCoordinator
  }
  
  // MARK: private function
  
  // MARK: internal function
  
  func navigate(to: CoordinatorRoute) {
    switch to {
    case .detailIsRequired(let id, let title):
      let viewModel = DetailViewModel(
        coordinator: self,
        detailUsecase: DetailUsecaseImplement(
          repository: DetailRepositoryImplement()
        ),
        bookId: id
      )
      self.viewModel = viewModel
      let vc = DetailViewController(title: title, viewModel: viewModel)
      (self.root as? UINavigationController)?.pushViewController(vc, animated: true)
    case .webViewIsRequired(let url, let title):
      let vc = CommonWebViewController(url: url, title: title, showType: .present)
      let navigationViewController = UINavigationController(rootViewController: vc)
      navigationViewController.modalPresentationStyle = .fullScreen
      (self.root as? UINavigationController)?.present(navigationViewController, animated: true)
    case .detailIsComplete:
      self.viewModel = nil
      self.parentsCoordinator?.navigate(to: .detailIsComplete)
    default:
      break
    }
  }
  
  
}
