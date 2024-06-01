//
//  ObservableTests.swift
//  AppFoundation
//
//  Created by hanwe on 5/27/24.
//  Copyright © 2024 Hanwe Lee. All rights reserved.
//

import XCTest
@testable import AppFoundation

class ObservableTests: XCTestCase {
  
  var disposeBag: DisposeBag!
  
  override func setUpWithError() throws {
    self.disposeBag = DisposeBag()
  }
  
  override func tearDownWithError() throws {
    
  }
  
  // Observable이 초기 값으로 구독자에게 값을 전달하는지 테스트
  func testObservableInitialValue() {
    // Given: 초기 값이 있는 Observable을 생성한다.
    let observable = Observable<Int>()
    
    var receivedValue: Int?
    
    // When: Observable에 구독을 추가한다.
    observable.onNext(10)
    observable.subscribe { value in
      receivedValue = value
    }
    .disposed(by: disposeBag)
    
    // Then: 초기 값을 구독자가 받는지 확인한다.
    XCTAssertEqual(receivedValue, 10, "초기 값을 구독자가 받아야 합니다.")
  }
  
  // Observable의 값이 변경될 때 구독자에게 알림이 전달되는지 테스트
  func testObservableValueChange() {
    // Given: 값을 변경할 수 있는 Observable을 생성한다.
    let observable = Observable<Int>()
    
    var receivedValue: Int?
    
    observable.subscribe { value in
      receivedValue = value
    }
    .disposed(by: disposeBag)
    
    // When: Observable의 값을 변경한다.
    observable.onNext(20)
    
    // Then: 변경된 값을 구독자가 받는지 확인한다.
    XCTAssertEqual(receivedValue, 20, "변경된 값을 구독자가 받아야 합니다.")
  }
  
  // 구독 해제 후 더 이상 알림이 전달되지 않는지 테스트
  func testObservableSubscriptionDispose() {
    // Given: 값을 변경할 수 있는 Observable을 생성한다.
    let observable = Observable<Int>()
    
    var receivedValue: Int?
    
    let disposable = observable.subscribe { value in
      receivedValue = value
    }
    
    // When: 구독을 해제하고 값을 변경한다.
    disposable.dispose()
    observable.onNext(30)
    
    // Then: 구독 해제 후에는 알림이 전달되지 않는지 확인한다.
    XCTAssertNil(receivedValue, "구독 해제 후에는 값을 받지 않아야 합니다.")
  }
  
  // DisposeBag이 해제될 때 구독도 해제되는지 테스트
  func testDisposeBagDisposesSubscriptions() {
    // Given: DisposeBag이 해제되었을 때 구독이 해제되었는지 확인하기 위한 설정
    class TestViewController: UIViewController {
      var observable: Observable<Int>?
      var disposeBag = DisposeBag()
    }
    
    let observable = Observable<Int>()
    var disposeCheckFlag = false
    
    var viewController: TestViewController? = TestViewController()
    viewController?.observable = observable
    
    viewController?.observable?.subscribe { _ in
      // 이벤트가 방출되면 true로 set
      disposeCheckFlag = true
    }
    .disposed(by: viewController!.disposeBag)
    
    // When: ViewController를 nil로 설정하여 메모리에서 해제되도록 한다. 그리고 이벤트 방출
    viewController = nil
    observable.onNext(0)
    
    // Then: DisposeBag이 해제되었을 때 구독도 해제되었는지 확인한다.
    XCTAssertFalse(disposeCheckFlag, "DisposeBag이 해제되면 구독도 해제되야해서 Flag가 바뀌면 안됩니다.")
  }
  
}
