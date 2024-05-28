//
//  ImageLoaderTests.swift
//  ImageLoader
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest
import CryptoKit
@testable import ImageLoader

class ImageLoaderTests: XCTestCase {
  
  var imageLoader: ImageLoader!

  override func setUpWithError() throws {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    imageLoader = ImageLoader(cacheType: .memory, session: URLSession(configuration: configuration))
    imageLoader.cache.removeAll()
  }

  override func tearDownWithError() throws {
    imageLoader.cache.removeAll()
    URLProtocol.unregisterClass(MockURLProtocol.self)
    imageLoader = nil
  }

  // Given When Then 원칙에 따라 테스트 케이스를 작성합니다.

  func testLoadImageFromCache() {
    // Given: 캐시에 이미지가 저장되어 있는 상황
    let url = URL(string: "https://example.com/image.png")!
    let cacheKey = url.absoluteString
    let expectedImage = UIImage(systemName: "person.fill")!
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, nil)
    }
    
    imageLoader.cache.setObject(expectedImage, forKey: cacheKey)
    
    // When: 이미지를 로드할 때
    let expectation = self.expectation(description: "이미지를 읽어오는중")
    var loadedImage: UIImage?
    
    imageLoader.loadImage(url) { image in
      loadedImage = image
      expectation.fulfill()
      // Then: 이미지를 캐시에서 로드해야 함
      XCTAssertEqual(loadedImage, expectedImage)
    }
    
    waitForExpectations(timeout: 1, handler: nil)
  }
  
  func testLoadImageFromNetwork() {
    // Given: 캐시에 이미지가 없고, 네트워크에서 이미지를 받아야 하는 상황
    let url = URL(string: "https://example.com/image.png")!
    let expectedImage = UIImage(systemName: "person.fill")!
    let mockData = expectedImage.pngData()!

    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, mockData)
    }
    // When: 이미지를 로드할 때
    let expectation = self.expectation(description: "이미지를 읽어오는중")
    imageLoader.loadImage(url) { image in
      expectation.fulfill()
      // Then: 이미지를 캐시해야함
      XCTAssertEqual(self.imageLoader.cache.object(forKey: url.absoluteString)!.sha256(), expectedImage.sha256())
    }
    
    waitForExpectations(timeout: 10, handler: nil)
  }

}


class MockURLProtocol: URLProtocol {
  static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override func startLoading() {
    guard let handler = MockURLProtocol.requestHandler else {
      fatalError("Handler is unavailable.")
    }

    do {
      let (response, data) = try handler(request)
      self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      if let data = data {
        self.client?.urlProtocol(self, didLoad: data)
      }
      self.client?.urlProtocolDidFinishLoading(self)
    } catch {
      self.client?.urlProtocol(self, didFailWithError: error)
    }
  }

  override func stopLoading() {}
}

extension UIImage {
  func sha256() -> String? {
    guard let imageData = self.pngData() else { return nil }
    let hash = SHA256.hash(data: imageData)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
  }
}
