//
//  DiskImageCache.swift
//  ImageLoader
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit

final class DiskImageCache: ImageCache {
  private let fileManager = FileManager.default
  
  private func cacheDirectory() -> URL {
    let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
    return urls[0].appendingPathComponent("ImageCache")
  }
  
  private func fileURL(for key: String) -> URL {
    return cacheDirectory().appendingPathComponent(key)
  }
  
  func setObject(_ object: UIImage, forKey key: String) {
    guard let data = object.pngData() else { return }
    let fileURL = self.fileURL(for: key)
    do {
      if !fileManager.fileExists(atPath: cacheDirectory().path) {
        try fileManager.createDirectory(at: cacheDirectory(), withIntermediateDirectories: true, attributes: nil)
      }
      try data.write(to: fileURL)
    } catch {
      print("Failed to save image to disk: \(error)")
    }
  }
  
  func object(forKey key: String) -> UIImage? {
    let fileURL = self.fileURL(for: key)
    if let data = try? Data(contentsOf: fileURL) {
      return UIImage(data: data)
    }
    return nil
  }
  
  func removeAll() {
    do {
      let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory(), includingPropertiesForKeys: nil, options: [])
      for fileURL in fileURLs {
        try fileManager.removeItem(at: fileURL)
      }
    } catch {
      print("Failed to remove all items from disk cache: \(error)")
    }
  }
}
