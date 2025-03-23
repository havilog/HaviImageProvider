//
//  ImageCacherTests.swift
//  HaviImageTests
//
//  Created by 한상진 on 12/18/24.
//

import Testing
@testable import HaviImage

struct ImageCacherTests {
  let sut = ImageCacher()
  let data: Data = UUID().uuidString.data(using: .utf8)!
  let key: any ImageStoreKey = UUID().uuidString
  
  @Test
  func 메모리와_디스크에_동시에_data를_저장하고_읽어올_수_있다() async throws {
    try await sut.store(data, for: key, option: .all)
    let storedData = await sut.data(for: key, option: .all)
    #expect(storedData == data)
  }
  
  @Test
  func 메모리에_data를_저장하고_읽어올_수_있다() async throws {
    try await sut.store(data, for: key, option: .memory)
    let storedData = await sut.data(for: key, option: .memory)
    #expect(storedData == data)
  }
  
  @Test
  func 메모리에_저장하면_디스크는_비어있다() async throws {
    try await sut.store(data, for: key, option: .memory)
    let storedData = await sut.data(for: key, option: .disk)
    #expect(storedData == .none)
  }
  
  @Test
  func 디스크에_data를_저장하고_읽어올_수_있다() async throws {
    try await sut.store(data, for: key, option: .disk)
    let storedData = await sut.data(for: key, option: .disk)
    #expect(storedData == data)
  }
  
  @Test
  func 디스크에_저장하면_메모리는_비어있다() async throws {
    try await sut.store(data, for: key, option: .disk)
    let storedData = await sut.data(for: key, option: .memory)
    #expect(storedData == .none)
  }
}

