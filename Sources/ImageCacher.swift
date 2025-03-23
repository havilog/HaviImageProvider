//
//  ImageCacher.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

protocol ImageCachable: Sendable {
  func data(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async -> Data?
  func store(
    _ data: Data,
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async throws
  func removeAll() async
  func removeData(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async
}

actor ImageCacher: ImageCachable {
  private let memoryStorage: any ImageStorable
  private let diskStorage: any ImageStorable
  
  init(
    memoryStorage: any ImageStorable = MemoryStorage(),
    diskStorage: any ImageStorable = DiskStorage()
  ) {
    self.memoryStorage = memoryStorage
    self.diskStorage = diskStorage
  }
  
  func data(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async -> Data? {
    switch option {
    case .memory:
      return try? await memoryStorage.load(for: key)
    case .disk:
      return try? await diskStorage.load(for: key)
    case .all:
      if let memoryData = try? await memoryStorage.load(for: key) {
        return memoryData
      } else if let diskData = try? await diskStorage.load(for: key) {
        return diskData
      } else {
        return nil
      }
    case .none:
      return nil
    default:
      return nil
    }
  }
  
  func store(
    _ data: Data,
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async throws {
    switch option {
    case .memory:
      try await memoryStorage.store(data, for: key)
    case .disk:
      try await diskStorage.store(data, for: key)
    case .all:
      try await memoryStorage.store(data, for: key)
      try await diskStorage.store(data, for: key) 
    case .none:
      break
    default:
      break
    }
  }
  
  func removeAll() async {
    try? await memoryStorage.removeAll()
    try? await diskStorage.removeAll()
  }
  
  func removeData(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async {
    switch option {
    case .memory:
      try? await memoryStorage.removeValue(for: key)
    case .disk:
      try? await diskStorage.removeValue(for: key)
    case .all:
      try? await memoryStorage.removeValue(for: key)
      try? await diskStorage.removeValue(for: key) 
    case .none:
      break
    default:
      break
    }
  }
}
