//
//  View.swift
//  AppFoundation
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public protocol View {
  associatedtype SpecificViewModel
  
  var viewModel: SpecificViewModel { get }
  var disposeBag: DisposeBag { get }
  
  init(viewModel: SpecificViewModel)
  func bind(viewModel: SpecificViewModel)
}
