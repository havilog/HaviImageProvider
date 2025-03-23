//
//  ImageStoreKey.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import Foundation

public protocol ImageStoreKey: Sendable {
  var hashValue: String { get }
  func asURL() throws -> URL
}

extension URL: ImageStoreKey {
  public var hashValue: String { return self.absoluteString }
  public func asURL() throws -> URL {
    return self
  }
}
extension String: ImageStoreKey { 
  public var hashValue: String { return self }
  public func asURL() throws -> URL {
    guard 
      let url = URL(string: self) 
    else { throw NSError() }
    return url
  }  
}
