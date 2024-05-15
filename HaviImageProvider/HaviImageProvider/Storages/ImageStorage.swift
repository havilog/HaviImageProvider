//
//  ImageStorage.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/15/24.
//

import Foundation

protocol ImageStorage {
  func store(_ data: Data, for key: ImageStoreKey) throws
  func load(for key: ImageStoreKey) throws -> Data?
  func removeValue(for key: ImageStoreKey) throws
  func removeAll() throws
}
