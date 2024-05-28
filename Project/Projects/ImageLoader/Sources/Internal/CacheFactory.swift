//
//  CacheFactory.swift
//  ImageLoader
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit

final class CacheFactory {
  static func createCache(type: ImageLoader.CacheType) -> ImageCache {
    switch type {
    case .memory:
      return MemoryImageCache()
    case .disk:
      return DiskImageCache()
    }
  }
}
