//
//  CacheManager.swift
//  ImageLoader
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit

final class CacheManager {
  static let shared = CacheManager()
  
  var runningRequests = [URL: [((UIImage?) -> Void)]]()
  let accessQueue = DispatchQueue(label: "com.booksearch.CacheManager")
  
  private init() {}
}
