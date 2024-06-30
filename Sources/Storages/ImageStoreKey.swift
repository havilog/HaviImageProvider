//
//  ImageStoreKey.swift
//  HaviImageProvider
//
//  Created by 한상진 on 5/15/24.
//

import Foundation

public protocol ImageStoreKey {
  var hashValue: String { get }
}

extension URL: ImageStoreKey {
  public var hashValue: String { return self.absoluteString }
}
extension String: ImageStoreKey { 
  public var hashValue: String { return self }
}
