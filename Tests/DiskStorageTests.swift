//
//  DiskStorageTests.swift
//  HaviImageTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
@testable import HaviImage

struct DiskStorageTests {
  private let sut: DiskStorage = .init()
  private let randomData: Data = UUID().uuidString.data(using: .utf8)!
  private let randomKey: String = UUID().uuidString
  
  @Test
  func 디스크_캐시에_문자를_저장하고_불러올_수_있다() async throws {
    let data: Data = "foo".data(using: .utf8)!
    let key: ImageStoreKey = "bar"
    
    try await sut.store(data, for: key)
    let result = try await sut.load(for: key)
    #expect(result == data)
  }
  
  @Test
  func 디스크_캐시에_문자를_저장하고_삭제할_수_있다() async throws {
    try await sut.store(randomData, for: randomKey)
    try await sut.removeValue(for: randomKey)
    let result = try await sut.load(for: randomKey)
    #expect(result == .none)
  }
  
  @Test
  func 디스크_캐시에_한개의_문자를_저장하고_삭제후_다시_저장할_수_있다() async throws {
    try await sut.store(randomData, for: randomKey)
    try await sut.removeValue(for: randomKey)
    try await sut.store(randomData, for: randomKey)
    let result = try await sut.load(for: randomKey)
    #expect(result == randomData)
  }

  @Test
  func random한_key로_문자를_저장할_수_있다() async throws {
    try await sut.store(randomData, for: randomKey)
    let result = try await sut.load(for: randomKey)
    #expect(result == randomData)
  }
  
  @Test
  func 디스크_캐시에_여러개의_문자를_저장하고_하나를_삭제할_수_있다() async throws {
    let data1: Data = "foo1".data(using: .utf8)!
    let key1: any ImageStoreKey = "bar1"
    let data2: Data = "foo2".data(using: .utf8)!
    let key2: any ImageStoreKey = "bar2"
    
    try await sut.store(data1, for: key1)
    try await sut.store(data2, for: key2)
    try await sut.removeValue(for: key1)
    let result1 = try await sut.load(for: key1)
    let result2 = try await sut.load(for: key2)
    #expect(result1 == .none)
    #expect(result2 == data2)
  }
}

