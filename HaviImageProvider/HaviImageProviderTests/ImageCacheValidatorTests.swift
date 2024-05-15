//
//  ImageCacheValidatorTests.swift
//  ImageCacheValidatorTests
//
//  Created by 한상진 on 5/12/24.
//

import XCTest
@testable import HaviImageProvider

final class ImageCacheValidatorTests: XCTestCase {
  private var sut: ImageCacheValidator!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = .init(lifetime: 0.01)
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
    sut = .none
  }
  
  func test_유효기간이_지나지_않은_캐시는_유효하다() async {
    // given
    let data: Data = "foo".data(using: .utf8)!
    let key: String = "bar"
    
    // when
    await sut.register(data: data, for: key)
    let isValid = await sut.isValid(for: key)
    try? await Task.sleep(for: .seconds(0.005))
    let stillValid = await sut.isValid(for: key)
    
    // then
    XCTAssertTrue(isValid)
    XCTAssertTrue(stillValid)
  }
  
  func test_여러개의_유효기간이_지나지_않은_캐시는_유효하다() async {
    // given
    let data1: Data = "foo1".data(using: .utf8)!
    let key1: String = "bar1"
    let data2: Data = "foo2".data(using: .utf8)!
    let key2: String = "bar2"
    
    // when
    await sut.register(data: data1, for: key1)
    await sut.register(data: data2, for: key2)
    
    let isValid1 = await sut.isValid(for: key1)
    let isValid2 = await sut.isValid(for: key2)
    
    try? await Task.sleep(for: .seconds(0.005))
    
    let stillValid1 = await sut.isValid(for: key1)
    let stillValid2 = await sut.isValid(for: key2)
    
    // then
    XCTAssertTrue(isValid1)
    XCTAssertTrue(isValid2)
    XCTAssertTrue(stillValid1)
    XCTAssertTrue(stillValid2)
  }
  
  func test_데이터를_등록하고_바로_삭제하면_유효하지_않다() async {
    // given
    let data: Data = "foo".data(using: .utf8)!
    let key: String = "bar"
    
    // when
    await sut.register(data: data, for: key)
    await sut.removeValue(for: key)
    let isValid = await sut.isValid(for: key)
    
    // then
    XCTAssertFalse(isValid)
  }
  
  func test_없는_데이터를_삭제하면_유효하지_않다() async {
    // given
    let key: String = "bar"
    
    // when
    await sut.removeValue(for: key)
    let isValid = await sut.isValid(for: key)
    
    // then
    XCTAssertFalse(isValid)
  }
  
  func test_모든_캐시를_삭제하면_유효하지_않다() async {
    // given
    let data1: Data = "foo1".data(using: .utf8)!
    let key1: String = "bar1"
    let data2: Data = "foo2".data(using: .utf8)!
    let key2: String = "bar2"
    
    // when
    await sut.register(data: data1, for: key1)
    await sut.register(data: data2, for: key2)
    await sut.removeAll()
    
    let isValid1 = await sut.isValid(for: key1)
    let isValid2 = await sut.isValid(for: key2)
    
    // then
    XCTAssertFalse(isValid1)
    XCTAssertFalse(isValid2)
  }
  
  func test_lifetime을_지나면_캐시는_유효하지_않다() async {
    // given
    let data: Data = "foo".data(using: .utf8)!
    let key: String = "bar"
    
    // when
    await sut.register(data: data, for: key)
    let valid = await sut.isValid(for: key)
    try? await Task.sleep(for: .seconds(0.01))
    let invalid = await sut.isValid(for: key)
    
    // then
    XCTAssertTrue(valid)
    XCTAssertFalse(invalid)
  }
}
