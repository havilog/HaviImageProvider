//
//  MemoryStorage.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

final actor MemoryStorage: ImageStorable {
  private let cache: NSCache<NSString, NSData> = .init()
  
  /// - Parameter 
  /// `totalCostLimit`: 20mb
  /// `countLimit`: 최대 50개 
  init(
    totalCostLimit: Int = 20_000_000,
    countLimit: Int = 50
  ) {
    self.cache.totalCostLimit = totalCostLimit
    self.cache.countLimit = countLimit
  }
  
  func store(_ data: Data, for key: any ImageStoreKey) {
    self.cache.setObject(data as NSData, forKey: key.hashValue as NSString)
    
  }
  
  func load(for key: any ImageStoreKey) -> Data? {
    let data = self.cache.object(forKey: key.hashValue as NSString) as? Data
    return data
  }
  
  func removeValue(for key: any ImageStoreKey) {
    self.cache.removeObject(forKey: key.hashValue as NSString)
  }
  
  func removeAll() {
    self.cache.removeAllObjects()
  }
}
