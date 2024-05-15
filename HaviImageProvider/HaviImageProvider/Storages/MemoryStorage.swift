//
//  MemoryStorage.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/15/24.
//

import Foundation

final class MemoryStorage: ImageStorage {
  let cache: NSCache<NSString, NSData>
  
  init(cache: NSCache<NSString, NSData> = .init()) {
    self.cache = cache
    self.cache.totalCostLimit = 20_000_000 // 20mb
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
}
