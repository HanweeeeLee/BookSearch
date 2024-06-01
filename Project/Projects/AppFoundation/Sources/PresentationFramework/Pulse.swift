//
//  Pulse.swift
//  AppFoundation
//
//  Created by hanwe on 5/30/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

public struct Pulse<Value: Equatable>: Equatable {
  
  public private(set) var value: Value
  public private(set) var valueUpdatedCount: UInt
  
  public init(wrappedValue: Value, oldPulse: Pulse? = nil) {
    self.value = wrappedValue
    if let oldPulse {
      self.valueUpdatedCount = oldPulse.valueUpdatedCount + 1
    } else {
      self.valueUpdatedCount = 0
    }
  }
  
}
