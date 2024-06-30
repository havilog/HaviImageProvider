//
//  ImageCachable.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/12/24.
//

import Foundation

protocol ImageCacheable {
  func store(data: Data, url: URL, option: ImageCacheOptions) async throws
  func load(url: URL) async throws -> Data
}
