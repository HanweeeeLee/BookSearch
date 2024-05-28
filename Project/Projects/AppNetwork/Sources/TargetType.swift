//
//  TargetType.swift
//  AppNetwork
//
//  Created by hanwe on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

//
//  TargetType.swift
//  AppNetwork
//
//  Created by Aaron Hanwe LEE on 5/28/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public protocol TargetType {
  var baseURL: URL { get }
  var path: String { get }
  var method: NetworkManager.HTTPMethod { get }
  var task: NetworkManager.Task { get }
  var headers: [String: String]? { get }
}

extension NetworkManager {
  public enum Task {
    case requestPlain
    case requestParameters(parameters: [String: Any])
  }
}
