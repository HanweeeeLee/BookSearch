//
//  ClassIdentifiable.swift
//  AppFoundation
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public protocol ClassIdentifiable: AnyObject {
  static var identifier: String { get }
}

extension ClassIdentifiable {
  public static var identifier: String {
    return String(describing: self)
  }
  
  public var identifier: String {
    return String(describing: type(of: self))
  }
}
