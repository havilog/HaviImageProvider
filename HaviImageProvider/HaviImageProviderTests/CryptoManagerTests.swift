//
//  CryptoManagerTests.swift
//  HaviImageProviderTests
//
//  Created by 한상진 on 5/15/24.
//

import XCTest
@testable import HaviImageProvider

final class CryptoManagerTests: XCTestCase {
  var sut: CryptoManager!
  
  override func setUp() {
    super.setUp()
    sut = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = .none
  }
  
  func test_데이터를_SHA256으로_암호화_할_수_있다() {
    let data: Data = "foo".data(using: .utf8)!
    let expected: String = "2C26B46B68FFC68FF99B453C1D30413413422D706483BFA0F98A5E886266E7AE"
    
    let result: String = sut.encrypt(data)
    
    XCTAssertEqual(result, expected)
  }
}
