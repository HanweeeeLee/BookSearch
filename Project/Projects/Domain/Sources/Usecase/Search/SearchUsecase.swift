//
//  SearchUsecase.swift
//  Domain
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import AppFoundation
import Foundation

public protocol SearchUsecase {
  
  var isEndOfReach: Bool { get }
  var isQuerying: Bool { get }
  
  func searchBookList(keyword: String) async -> Result<[Book], Error>
  func moreBookList() async -> Result<[Book], Error>
  
}
