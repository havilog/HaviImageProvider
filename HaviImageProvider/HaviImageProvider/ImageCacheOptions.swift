//
//  ImageCacheOptions.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/12/24.
//

import Foundation

public struct ImageCacheOptions: OptionSet {
  public let rawValue: Int
  public init(rawValue: Int) {
    self.rawValue = rawValue
  }
  
  public static let all: Self = [.memory, .disk]
  public static let none: Self = []
  public static let memory: Self = .init(rawValue: 1 << 0)
  public static let disk: Self = .init(rawValue: 1 << 1)
}
