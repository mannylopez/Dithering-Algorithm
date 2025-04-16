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
  
  func rgbaMatrix() -> [[RGBA]] {
    switch self {
    case .none:
      PixelReader.pixelsRGBA(from: .catFullColor)
    case .grayscale:
      PixelReader.grayscaleRGBA(from:.catFullColor)
    case .thresholding:
      PixelReader.thresholdingRGBA(from:.catFullColor)
    case .atkinson:
      PixelReader.atkinsonRGBA(from:.catFullColor)
    case .aman:
      PixelReader.amanRGBA(from: .catFullColor)
    }
  }
}
