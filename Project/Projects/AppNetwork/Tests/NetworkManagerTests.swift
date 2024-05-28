//
//  NetworkManagerTests.swift
//  AppNetwork
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest
@testable import AppNetwork

class NetworkManagerTests: XCTestCase {

  var networkManager: NetworkManager!

  override func setUpWithError() throws {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    networkManager = NetworkManager.shared
    networkManager.setConfigureSession(configuration)
  }

  override func tearDownWithError() throws {

  }

  // 성공적인 GET 요청 테스트
  func testSuccessfulGetRequest() async throws {
    // Given
    let expectedPost = Post(id: 1, title: "Sample Title", body: "This is a sample body.")
    let mockData = try JSONEncoder().encode(expectedPost)

    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
      return (response, mockData)
    }

    // When
    let result: Result<Post, NetworkManager.NetworkError> = await networkManager.requestData(target: JSONPlaceholderAPI.getPost(id: 1))

    // Then
    switch result {
    case .success(let post):
      XCTAssertEqual(post.id, expectedPost.id)
      XCTAssertEqual(post.title, expectedPost.title)
      XCTAssertEqual(post.body, expectedPost.body)
    case .failure(let error):
      XCTFail("성공해야하는데, 실패했다. \(error)")
    }
  }

  func testFailedGetRequest() async throws {
    // Given
    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
      return (response, nil)
    }

    // When
    let result: Result<Post, NetworkManager.NetworkError> = await networkManager.requestData(target: JSONPlaceholderAPI.getPost(id: 9999))

    // Then
    switch result {
    case .success:
      XCTFail("실패해야하는데, 성공했음.")
    case .failure(let error):
      XCTAssertEqual(error, .invalidResponse)
    }
  }

  func testSuccessfulPostRequest() async throws {
    // Given
    let newPost = CreatedPostResponse(id: 101, title: "Sample Title", body: "This is a sample body.", userId: 1)
    let mockData = try JSONEncoder().encode(newPost)

    MockURLProtocol.requestHandler = { request in
      let response = HTTPURLResponse(url: request.url!, statusCode: 201, httpVersion: nil, headerFields: nil)!
      return (response, mockData)
    }

    // When
    let result: Result<CreatedPostResponse, NetworkManager.NetworkError> = await networkManager.requestData(target: JSONPlaceholderAPI.createPost(title: "Sample Title", body: "This is a sample body.", userId: 1))

    // Then
    switch result {
    case .success(let createdPost):
      XCTAssertEqual(createdPost.id, newPost.id)
      XCTAssertEqual(createdPost.title, newPost.title)
      XCTAssertEqual(createdPost.body, newPost.body)
      XCTAssertEqual(createdPost.userId, newPost.userId)
    case .failure(let error):
      XCTFail("성공해야하는데, 실패했다. \(error)")
    }
  }

  func testPostRequestWithInvalidJSON() async throws {
    // Given
    MockURLProtocol.requestHandler = { request in
      throw URLError(.badURL)
    }

    // When
    let result: Result<CreatedPostResponse, NetworkManager.NetworkError> = await networkManager.requestData(target: JSONPlaceholderAPI.createPost(title: "Invalid JSON", body: "{}", userId: 1))

    // Then
    switch result {
    case .success:
      XCTFail("실패해야하는데, 성공했다.")
    case .failure(let error):
      XCTAssertEqual(error, .requestFailed)
    }
  }
}

struct Post: Codable {
  let id: Int
  let title: String
  let body: String
}

struct CreatedPostResponse: Codable {
  let id: Int
  let title: String
  let body: String
  let userId: Int
}

enum JSONPlaceholderAPI {
  case getPost(id: Int)
  case createPost(title: String, body: String, userId: Int)
}

extension JSONPlaceholderAPI: TargetType {
  var baseURL: URL {
    return URL(string: "https://stubUrl.com/mock")!
  }

  var path: String {
    switch self {
    case .getPost(let id):
      return "/posts/\(id)"
    case .createPost:
      return "/posts"
    }
  }

  var method: NetworkManager.HTTPMethod {
    switch self {
    case .getPost:
      return .get
    case .createPost:
      return .post
    }
  }

  var task: NetworkManager.Task {
    switch self {
    case .getPost:
      return .requestPlain
    case .createPost(let title, let body, let userId):
      return .requestParameters(parameters: [
        "title": title,
        "body": body,
        "userId": userId
      ])
    }
  }

  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
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
