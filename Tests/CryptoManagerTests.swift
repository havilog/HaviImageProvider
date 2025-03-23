//
//  CryptoManagerTests.swift
//  HaviImageTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
@testable import HaviImage

struct CryptoManagerTests {
  @Test
  func 데이터를_SHA256으로_암호화_할_수_있다() {
    let sut: CryptoManager = .init()
    let data: Data = "foo".data(using: .utf8)!
    let expected: String = "2C26B46B68FFC68FF99B453C1D30413413422D706483BFA0F98A5E886266E7AE"
    
    let result: String = sut.encrypt(data)
    
    #expect(result == expected)
  }
}
