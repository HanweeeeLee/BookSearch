//
//  ImageCache.swift
//  ImageLoader
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit

protocol ImageCache {
  func setObject(_ object: UIImage, forKey key: String)
  func object(forKey key: String) -> UIImage?
  func removeAll()
}
