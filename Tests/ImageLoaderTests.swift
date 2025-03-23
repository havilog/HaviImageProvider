//
//  ImageLoaderTests.swift
//  HaviImageTests
//
//  Created by 한상진 on 12/18/24.
//

import UIKit
import Testing
@testable import HaviImage

final class ImageLoaderTests {
  private let randomData: Data = UUID().uuidString.data(using: .utf8)!
  private let randomKey: String = UUID().uuidString
  
  @Test
  func 캐시가_없을경우_network로부터_data를_받아온다() async throws {
    let sut = ImageLoader(
      cache: ImageCacherMock(
        storeHandler: { _, _, _ in },
        loadHandler: { _, _ in
          return nil
        }
      ),
      session: ImageDataFetchableMock(
        loadHandler: { [unowned self] _ in
          return (self.randomData, .init())
        }
      )
    )
    
    let loadedData = try await sut.loadData(for: randomKey, option: .all)
    
    #expect(loadedData == randomData)
  }
  
  @Test(
    ".all, .memory 테스트",
    arguments: [ImageCacheOptions.all, ImageCacheOptions.memory]
  )
  func 메모리에_캐시가_있을경우_메모리캐시로부터_data를_받아온다(argument: ImageCacheOptions) async throws {
    let invalidData: Data = "invalid data".data(using: .utf8)!
    let sut = ImageLoader(
      cache: ImageCacherMock(
        storeHandler: { _, _, _ in },
        loadHandler: { [unowned self] _, option in
          switch option {
          case .memory, .all: return self.randomData
          default: return nil
          }
        }
      ),
      session: ImageDataFetchableMock(
        loadHandler: { _ in
          return (invalidData, .init())
        }
      )
    )
    
    let loadedData = try await sut.loadData(for: randomKey, option: argument)
    #expect(loadedData == randomData)
    #expect(loadedData != invalidData)
  }
  
  @Test(
    ".all, .disk 테스트",
    arguments: [ImageCacheOptions.all, ImageCacheOptions.disk]
  )
  func 디스크에_캐시가_있을경우_디스크캐시로부터_data를_받아온다(argument: ImageCacheOptions) async throws {
    let invalidData: Data = "invalid data".data(using: .utf8)!
    let sut = ImageLoader(
      cache: ImageCacherMock(
        storeHandler: { _, _, _ in },
        loadHandler: { [unowned self] _, option in
          switch option {
          case .disk, .all: return self.randomData
          default: return nil
          }
        }
      ),
      session: ImageDataFetchableMock(
        loadHandler: { _ in
          return (invalidData, .init())
        }
      )
    )
    
    let loadedData = try await sut.loadData(for: randomKey, option: argument)
    #expect(loadedData == randomData)
    #expect(loadedData != invalidData)
  }
  
  @Test
  func cache에_저장된_이미지가_있을경우_캐시를_가져온다() async throws {
    let invalidData: Data = "invalid data".data(using: .utf8)!
    let imagePath = Bundle(for: type(of: self)).path(forResource: "9780470404447", ofType: "png")!
    let imageURL = URL(fileURLWithPath: imagePath) // URL(filePath: imagePath)
    let imageData = try! Data(contentsOf: imageURL)
    let expectedData = UIImage(data: imageData)?.pngData()
    let sut = ImageLoader(
      cache: ImageCacherMock(
        storeHandler: { _, _, _ in },
        loadHandler: { _, _ in
          return imageData
        }
      ),
      session: ImageDataFetchableMock(
        loadHandler: { _ in
          return (invalidData, .init())
        }
      )
    )
    
    let maybeData = try await sut.loadData(for: randomKey, option: .all)
    let maybeImage = try await sut.loadImage(for: randomKey, option: .all)
    
    #expect(maybeData == imageData)
    #expect(maybeImage.pngData() == expectedData)
  }
}

fileprivate struct ImageDataFetchableMock: ImageDataFetchable {
  var loadHandler: ((URLRequest) async throws -> (Data, URLResponse))
  
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    return try await loadHandler(request)
  }
}

fileprivate struct ImageCacherMock: ImageCachable {
  var storeHandler: ((Data, any ImageStoreKey, ImageCacheOptions) -> Void)
  var loadHandler: ((any ImageStoreKey, ImageCacheOptions) -> Data?)
  
  func data(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async -> Data? {
    loadHandler(key, option)
  }
  
  func store(
    _ data: Data,
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async throws {
    storeHandler(data, key, option)
  }
  
  func removeAll() async {
    
  }
  
  func removeData(
    for key: any ImageStoreKey,
    option: ImageCacheOptions
  ) async {
    
  }
}

