//
//  MemoryStorageTests.swift
//  HaviImageTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
@testable import HaviImage

struct MemoryStorageTests {
  private let sut: MemoryStorage = .init()
  
  @Test 
  func 메모리_캐시에_문자를_저장하고_불러올_수_있다() async throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: any ImageStoreKey = "bar"
    
    await sut.store(data, for: key)
    let result = await sut.load(for: key)
    #expect(result == data)
  }
  
  @Test 
  func 메모리_캐시에_문자를_저장하고_삭제할_수_있다() async throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: any ImageStoreKey = "bar"
    
    await sut.store(data, for: key)
    await sut.removeValue(for: key)
    let result = await sut.load(for: key)
    #expect(result == .none)
  }
  
  @Test 
  func 메모리_캐시에_한개의_문자를_저장하고_삭제후_다시_저장할_수_있다() async throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: any ImageStoreKey = "bar"
    
    await sut.store(data, for: key)
    await sut.removeValue(for: key)
    await sut.store(data, for: key)
    let result = await sut.load(for: key)
    #expect(result == data)
  }

  @Test 
  func random한_key로_문자를_저장할_수_있다() async throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: any ImageStoreKey = UUID().uuidString
    
    await sut.store(data, for: key)
    let result = await sut.load(for: key)
    #expect(result == data)
  }
  
  @Test 
  func 메모리_캐시에_여러개의_문자를_저장하고_하나를_삭제할_수_있다() async throws {
    let data1: Data = "foo1".data(using: .utf8)!
    let key1: any ImageStoreKey = "bar1"
    let data2: Data = "foo2".data(using: .utf8)!
    let key2: any ImageStoreKey = "bar2"
    
    await sut.store(data1, for: key1)
    await sut.store(data2, for: key2)
    await sut.removeValue(for: key1)
    let result1 = await sut.load(for: key1)
    let result2 = await sut.load(for: key2)
    #expect(result1 == .none)
    #expect(result2 == data2)
  }
}
