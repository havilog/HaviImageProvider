//
//  MemoryStorage.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/15/24.
//

import Foundation

final actor MemoryStorage: ImageStorage {
  private let cache: NSCache<NSString, NSData> = .init()
  
  /// - Parameter totalCostLimit: 20mb
  init(totalCostLimit: Int = 20_000_000) {
    self.cache.totalCostLimit = totalCostLimit
  }
  
  func store(_ data: Data, for key: any ImageStoreKey) {
    self.cache.setObject(data as NSData, forKey: key.hashValue as NSString)
  }
  
  func load(for key: any ImageStoreKey) -> Data? {
    return self.cache.object(forKey: key.hashValue as NSString) as? Data
  }
  
  func removeValue(for key: any ImageStoreKey) {
    self.cache.removeObject(forKey: key.hashValue as NSString)
  }
  
  func removeAll() {
    self.cache.removeAllObjects()
  }
  
  // TODO: 엄청나게 많은 저장 해보기
  // TODO: 메모리 워닝 받을 시 지우는 거 해보기
}
