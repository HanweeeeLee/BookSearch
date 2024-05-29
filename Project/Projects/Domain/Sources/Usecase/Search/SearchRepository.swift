//
//  SearchRepository.swift
//  Domain
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import AppFoundation
import Foundation

public protocol SearchRepository {
  func searchBookList(keyword: String, page: UInt) async -> Result<[Book], Error>
}
