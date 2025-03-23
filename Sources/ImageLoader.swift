//
//  ImageLoader.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import UIKit

public protocol ImageLoadable: Sendable {
  func loadData(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async throws -> Data?
  func loadImage(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async throws -> UIImage
}

public struct ImageLoader: ImageLoadable {
  
  public enum Errors: Swift.Error, Sendable, Equatable {
    case loadFailed
  }
  
  private let cache: any ImageCachable
  private let session: any ImageDataFetchable
  
  public static let shared: ImageLoader = .init()
  
  init(
    cache: any ImageCachable = ImageCacher(),
    session: any ImageDataFetchable = URLSession.shared
  ) {
    self.cache = cache
    self.session = session
  }
  
  public func loadImage(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async throws -> UIImage {
    let imageData: Data? = try await self.loadData(for: key, option: option)
    guard
      let imageData,
      let image = UIImage(data: imageData) 
    else { 
      throw Errors.loadFailed
    }
    return image
  }
  
  public func loadData(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async throws -> Data? {
    #if DEBUG
    print("try to load data from cache for \(key)")
    #endif
    if let data = await cache.data(for: key, option: option) {
      #if DEBUG
      print("cache hit!, option: \(option.description)")
      #endif
      return data
    }
    #if DEBUG
    print("no cache, fetch data from remote")
    #endif
    let imageData: Data = try await remoteImage(for: key)
    try? await cache.store(imageData, for: key, option: option)
    return imageData
  }
  
  private func remoteImage(
    for key: any ImageStoreKey
  ) async throws -> Data {
    let url: URL = try key.asURL()
    let urlRequest: URLRequest = .init(url: url)
    let (data, _) = try await session.data(for: urlRequest)
    return data
  }
}

public protocol ImageDataFetchable: Sendable {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: ImageDataFetchable { }
