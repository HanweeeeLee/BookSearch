//
//  DetailRepository.swift
//  Domain
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public protocol DetailRepository {
  func bookDetail(id: String) async -> Result<BookDetail, any Error>
}
