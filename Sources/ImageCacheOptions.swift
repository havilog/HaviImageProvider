//
//  CacheOptions.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import Foundation
public struct ImageCacheOptions: OptionSet, Sendable {
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  public static let all: Self = [.memory, .disk]
  public static let none: Self = []
  public static let memory: Self = .init(rawValue: 1 << 0)
  public static let disk: Self = .init(rawValue: 1 << 1)
  
  public var description: String {
    switch self {
    case .none: return "none"
    case .memory: return "memory"
    case .disk: return "disk"
    case .all: return "all"
    default: return "unknown"
    }
  }
}
