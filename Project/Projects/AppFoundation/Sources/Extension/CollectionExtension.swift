//
//  CollectionExtension.swift
//  AppFoundation
//
//  Created by hanwe on 5/29/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import Foundation

extension Collection {
  public subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
