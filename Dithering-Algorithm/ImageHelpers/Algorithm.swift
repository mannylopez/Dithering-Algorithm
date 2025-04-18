//
//  Algorithm.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/14/25.
//

import Foundation

enum Algorithm: String, CaseIterable {
  case none = "None"
  case grayscale = "Grayscale"
  case thresholding = "Thresholding"
  case atkinson = "Atkinson"
  case aman = "Aman"
  
  func rgbaMatrix(for image: StockImage = .catFullColor) -> [[RGBA]] {
    switch self {
    case .none:
      PixelReader.pixelsRGBA(from: image)
    case .grayscale:
      PixelReader.grayscaleRGBA(from: image)
    case .thresholding:
      PixelReader.thresholdingRGBA(from: image)
    case .atkinson:
      PixelReader.atkinsonRGBA(from: image)
    case .aman:
      PixelReader.amanRGBA(from: image)
    }
  }
}
