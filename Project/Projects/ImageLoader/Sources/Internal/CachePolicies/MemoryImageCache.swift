//
//  MemoryImageCache.swift
//  ImageLoader
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit

final class MemoryImageCache: ImageCache {
  private let cache = NSCache<NSString, UIImage>()
  
  func setObject(_ object: UIImage, forKey key: String) {
    cache.setObject(object, forKey: key as NSString)
  }
  
  func object(forKey key: String) -> UIImage? {
    return cache.object(forKey: key as NSString)
  }
  
  func removeAll() {
    cache.removeAllObjects()
  }
}
