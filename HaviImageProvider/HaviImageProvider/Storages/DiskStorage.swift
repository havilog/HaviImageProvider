//
//  DiskStorage.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/15/24.
//

import Foundation

final actor DiskStorage: ImageStorage {
  private let fileManager: FileManager = .default
  private let cryptoManager: CryptoManager
  
  private var diskCacheURL: URL {
    let cachesDirectoryURL: URL = fileManager.urls(
      for: .cachesDirectory,
      in: .userDomainMask
    )[0]
    let appendingPath: String = Bundle.main.bundlePath
    return cachesDirectoryURL.appending(
      component: appendingPath,
      directoryHint: .isDirectory
    )
  }
  
  init(cryptoManager: CryptoManager = .init()) {
    self.cryptoManager = cryptoManager
  }
  
  // MARK: ImageStorage
  
  func store(_ data: Data, for key: any ImageStoreKey) throws {
    let fileURL: URL = cacheFileURL(for: key)
    try prepareDirectory()
    try data.write(to: fileURL)
  }
  
  func load(for key: any ImageStoreKey) throws -> Data? {
    let fileURL: URL = cacheFileURL(for: key)
    guard 
      fileManager.fileExists(atPath: fileURL.path(percentEncoded: false)) 
    else { return nil }
    return try Data(contentsOf: fileURL)
  }
  
  func removeValue(for key: any ImageStoreKey) throws {
    let fileURL: URL = cacheFileURL(for: key)
    try fileManager.removeItem(at: fileURL)
  }
  
  func removeAll() throws {
    try fileManager.removeItem(at: diskCacheURL)
  }
  
  // MARK: Private
  
  private func prepareDirectory() throws {
    let path = diskCacheURL.path(percentEncoded: false)
    guard 
      fileManager.fileExists(atPath: path) == false 
    else { return }
    try fileManager.createDirectory(
      atPath: path,
      withIntermediateDirectories: true,
      attributes: nil
    )
  }
  
  private func encryptedFileName(for key: any ImageStoreKey) -> String {
    guard 
      let data = key.hashValue.data(using: .utf8) 
    else { return  key.hashValue }
    
    let encrytedFileName: String = self.cryptoManager.encrypt(data)
    return encrytedFileName 
  }
  
  private func cacheFileURL(for key: any ImageStoreKey) -> URL {
    let fileName: String = encryptedFileName(for: key)
    return self.diskCacheURL.appending(
      component: fileName,
      directoryHint: .notDirectory
    )
  }
}
