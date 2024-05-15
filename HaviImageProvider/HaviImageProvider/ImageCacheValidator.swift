//
//  CacheValidatable.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/12/24.
//

import Foundation

protocol ImageCacheValidatable {
  func isValid(for key: String) async -> Bool
  func register(data: Data, for key: String) async
  func removeValue(for key: String) async
  func removeAll() async
}

final actor ImageCacheValidator: ImageCacheValidatable {
  typealias CacheKey = String
  
  private let lifetime: TimeInterval
  private var caches: [CacheKey: Date]
  
  init(
    lifetime: TimeInterval = 60 * 60,
    caches: [CacheKey: Date] = .init()
  ) {
    self.lifetime = lifetime
    self.caches = caches
  }
  
  func isValid(for key: String) async -> Bool {
    guard let date = caches[key] else { return false }
    return date.addingTimeInterval(lifetime).timeIntervalSinceNow > .zero
  }
  
  func register(data: Data, for key: String) async {
    self.caches[key] = .now 
  }
  
  func removeValue(for key: String) async {
    self.caches.removeValue(forKey: key)
  }
  
  func removeAll() async {
    self.caches.removeAll()
  }
} 
