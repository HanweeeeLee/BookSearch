//
//  ImageLoader.swift
//  ImageLoader
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import UIKit

public class ImageLoader {
  
  public enum CacheType {
    case memory
    case disk
  }
  
  // MARK: - private property
  
  private var session: URLSession
  
  // MARK: - public property
  private(set) var cache: ImageCache
  
  // MARK: - lifeCycle
  
  public init(cacheType: CacheType, session: URLSession = URLSession.shared) {
    self.cache = CacheFactory.createCache(type: cacheType)
    self.session = session
  }
  
  // MARK: - public method
  
  public func loadImage(_ url: URL, completion: @escaping (UIImage?) -> Void) {
    let cacheKey = url.absoluteString
    
    CacheManager.shared.accessQueue.sync { // 캐시에서 이미지 찾기
      if let cachedImage = cache.object(forKey: cacheKey) {
        DispatchQueue.main.async {
          completion(cachedImage)
        }
        return
      }
      
      if CacheManager.shared.runningRequests[url] != nil { // 이미 진행 중인 요청이 있는지 확인
        CacheManager.shared.runningRequests[url]?.append(completion)
        return
      } else {
        CacheManager.shared.runningRequests[url] = [completion]
      }
    }
    
    let task = session.dataTask(with: url) { data, response, error in
      
      guard let data,
            let image = UIImage(data: data) else {
        DispatchQueue.main.async {
          CacheManager.shared.accessQueue.async {
            CacheManager.shared.runningRequests[url]?.forEach { $0(nil) }
            CacheManager.shared.runningRequests[url] = nil
          }
        }
        return
      }
      
      CacheManager.shared.accessQueue.async {
        self.cache.setObject(image, forKey: cacheKey)
        DispatchQueue.main.async {
          CacheManager.shared.runningRequests[url]?.forEach { $0(image) }
          CacheManager.shared.runningRequests[url] = nil
        }
      }
    }
    
    task.resume()
  }
}

extension UIImageView {
  
  @MainActor
  public func setImage(from url: URL, cacheType: ImageLoader.CacheType = .memory) {
    let imageLoader = ImageLoader(cacheType: cacheType)
    imageLoader.loadImage(url) { [weak self] image in
      self?.image = image
    }
  }
  
}
