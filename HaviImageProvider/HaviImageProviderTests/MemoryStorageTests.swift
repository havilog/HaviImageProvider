//
//  MemoryStorageTests.swift
//  HaviImageProviderTests
//
//  Created by 한상진 on 5/15/24.
//

import XCTest
@testable import HaviImageProvider

final class MemoryStorageTests: XCTestCase {
  var sut: MemoryStorage!
  
  override func setUp() {
    super.setUp()
    sut = .init()
  }
  
  override func tearDown() {
    super.tearDown()
    sut = .none
  }
  
  func test_메모리_캐시에_문자를_저장하고_불러올_수_있다() throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: ImageStoreKey = "bar"
    
    sut.store(data, for: key)
    let result = sut.load(for: key)
    XCTAssertEqual(result, data)
  }
  
  func test_메모리_캐시에_문자를_저장하고_삭제할_수_있다() throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: ImageStoreKey = "bar"
    
    sut.store(data, for: key)
    sut.removeValue(for: key)
    let result = sut.load(for: key)
    XCTAssertNil(result)
  }
  
  func test_메모리_캐시에_한개의_문자를_저장하고_삭제후_다시_저장할_수_있다() throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: ImageStoreKey = "bar"
    
    sut.store(data, for: key)
    sut.removeValue(for: key)
    sut.store(data, for: key)
    let result = sut.load(for: key)
    XCTAssertEqual(result, data)
  }

  func test_random한_key로_문자를_저장할_수_있다() throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: ImageStoreKey = UUID().uuidString
    
    sut.store(data, for: key)
    let result = sut.load(for: key)
    XCTAssertEqual(result, data)
  }
  
  func test_메모리_캐시에_여러개의_문자를_저장하고_하나를_삭제할_수_있다() throws {
    let data1: Data = "foo1".data(using: .utf8)!
    let key1: any ImageStoreKey = "bar1"
    let data2: Data = "foo2".data(using: .utf8)!
    let key2: any ImageStoreKey = "bar2"
    
    sut.store(data1, for: key1)
    sut.store(data2, for: key2)
    sut.removeValue(for: key1)
    let result1 = sut.load(for: key1)
    let result2 = sut.load(for: key2)
    XCTAssertNil(result1)
    XCTAssertEqual(result2, data2)
  }
}
