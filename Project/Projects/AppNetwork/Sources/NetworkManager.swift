//
//  NetworkManager.swift
//  AppNetwork
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public class NetworkManager {

  public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
  }

  public enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingFailed
  }

  // MARK: - private property
  private var session: URLSession

  // MARK: - public property
  public static let shared = NetworkManager()

  // MARK: - lifeCycle
  private init() {
    self.session = URLSession(configuration: URLSessionConfiguration.default)
  }

  // MARK: - public method
  public func setConfigureSession(_ configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }

  public func requestData<T: Decodable>(target: TargetType) async -> Result<T, NetworkError> {
    let url = target.baseURL.appendingPathComponent(target.path)
    var request = URLRequest(url: url)
    request.httpMethod = target.method.rawValue

    if let headers = target.headers {
      for (key, value) in headers {
        request.setValue(value, forHTTPHeaderField: key)
      }
    }

    switch target.task {
    case .requestPlain:
      break
    case .requestParameters(let parameters):
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      } catch {
        return .failure(.requestFailed)
      }
    }

    do {
      let (data, response) = try await session.data(for: request)

      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        return .failure(.invalidResponse)
      }

      do {
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return .success(decodedData)
      } catch {
        return .failure(.decodingFailed)
      }
    } catch {
      return .failure(.requestFailed)
    }
  }
}
