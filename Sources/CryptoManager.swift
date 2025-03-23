//
//  CryptoManager.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import CryptoKit
import Foundation

protocol Encryptable {
  func encrypt(
    _ data: Data,
    with hashFunction: any HashFunction.Type
  ) -> String
}

struct CryptoManager: Encryptable {
  func encrypt(
    _ data: Data,
    with hashFunction: any HashFunction.Type = SHA256.self
  ) -> String {
    let hashedData: String = hashFunction.hash(data: data).map { String(format: "%02X", $0) }.joined()
    return hashedData
  }
}
