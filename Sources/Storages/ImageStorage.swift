//
//  ImageStorage.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/15/24.
//

import Foundation

#if !os(macOS)
protocol ImageStorage: Actor {
  func store(_ data: Data, for key: any ImageStoreKey) throws
  func load(for key: any ImageStoreKey) throws -> Data?
  func removeValue(for key: any ImageStoreKey) throws
  func removeAll() throws
}
#endif
