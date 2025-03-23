//
//  ImageStorable.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

protocol ImageStorable: Actor {
  func store(_ data: Data, for key: any ImageStoreKey) throws
  func load(for key: any ImageStoreKey) throws -> Data?
  func removeValue(for key: any ImageStoreKey) throws
  func removeAll() throws
}
