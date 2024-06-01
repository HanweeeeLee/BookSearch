//
//  PulseTests.swift
//  AppFoundationTests
//
//  Created by hanwe on 6/1/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest

@testable import AppFoundation

class PulseTests: XCTestCase {
  
  func testInitialValue() {
    // Given
    let initialValue = 10
    
    // When
    let pulse = Pulse(wrappedValue: initialValue)
    
    // Then
    XCTAssertEqual(pulse.value, initialValue, "초기 값이 올바르게 설정되어야 합니다")
    XCTAssertEqual(pulse.valueUpdatedCount, 0, "초기 업데이트 카운트는 0이어야 합니다")
  }
  
  func testUpdatedValue() {
    // Given
    let initialValue = 10
    let updatedValue = 20
    let oldPulse = Pulse(wrappedValue: initialValue)
    
    // When
    let newPulse = Pulse(wrappedValue: updatedValue, oldPulse: oldPulse)
    
    // Then
    XCTAssertEqual(newPulse.value, updatedValue, "업데이트된 값이 올바르게 설정되어야 합니다")
    XCTAssertEqual(newPulse.valueUpdatedCount, 1, "업데이트 카운트가 증가해야 합니다")
  }
  
  func testMultipleUpdates() {
    // Given
    let initialValue = 10
    let secondValue = 20
    let thirdValue = 30
    let oldPulse1 = Pulse(wrappedValue: initialValue)
    
    // When
    let oldPulse2 = Pulse(wrappedValue: secondValue, oldPulse: oldPulse1)
    let newPulse = Pulse(wrappedValue: thirdValue, oldPulse: oldPulse2)
    
    // Then
    XCTAssertEqual(newPulse.value, thirdValue, "세 번째 값이 올바르게 설정되어야 합니다")
    XCTAssertEqual(newPulse.valueUpdatedCount, 2, "업데이트 카운트가 두 번 증가해야 합니다")
  }
}
