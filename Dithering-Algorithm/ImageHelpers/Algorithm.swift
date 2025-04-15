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
  
  func rgbaMatrix() -> [[RGBA]] {
    switch self {
    case .none:
      PixelReader.pixelsRGBA(from: .catFullColor)
    case .grayscale:
      PixelReader.grayscaleRGBA(from:.catFullColor)
    case .thresholding:
      PixelReader.thresholdingRGBA(from:.catFullColor)
    }
  }
}
