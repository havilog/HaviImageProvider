//
//  HaviAsyncImage.swift
//  HaviImage
//
//  Created by 한상진 on 12/18/24.
//

import SwiftUI

@MainActor
public struct HaviAsyncImage<Content: View>: View {
  @State private var phase: AsyncImagePhase = .empty
  
  private let urlString: String
  private let content: (AsyncImagePhase) -> Content
  private let cachOption: ImageCacheOptions 
  
  public init(
    urlString: String,
    cachOption: ImageCacheOptions,
    @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
  ) {
    self.urlString = urlString
    self.content = content
    self.cachOption = cachOption
  }
  
  public var body: some View {
    content(phase)
      .task(id: urlString) { 
        do {
          if case .failure = phase { self.phase = .empty }
          let image = try await ImageLoader.shared.loadImage(
            for: urlString,
            option: cachOption
          )
          self.phase = .success(.init(uiImage: image))
        }
        catch {
          self.phase = .failure(error)
        }
      }
  }
}
