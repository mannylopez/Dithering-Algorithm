//
//  Algorithm.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/14/25.
//

import Foundation

enum Algorithm: String, CaseIterable {
  case copy = "Copy"
  case grayscale = "Grayscale"
  case thresholding = "Thresholding"
  case atkinson = "Atkinson"
  case floydSteinberg = "Floyd-Steinberg"
  case jarvisJudiceNinke = "Jarvis, Judice, and Ninke"
  case stucki = "Stucki"
  case burkes = "Burkes"
  
  func rgbaMatrix(for image: StockImage = .catFullColor) -> [[RGBA]] {
    switch self {
    case .copy:
      PixelReader.pixelCopyRGBA(from: image)
    case .grayscale:
      PixelReader.grayscaleRGBA(from: image)
    case .thresholding:
      PixelReader.thresholdingRGBA(from: image)
    case .atkinson, .floydSteinberg, .jarvisJudiceNinke, .stucki, .burkes:
      PixelReader.createRGBA(from: image, using: self)
    }
  }
  
  // Found in https://raw.githubusercontent.com/cyotek/Dithering/master/resources/DHALF.TXT
  func pattern() -> [DitherPixel] {
    switch self {
    case .copy:
      []
    case .grayscale:
      []
    case .thresholding:
      []
    case .atkinson:
      //      *   1   1
      //  1   1   1
      //      1
      //
      //  (1/8)
      [
        DitherPixel(y: 0, x: 1, weight: 0.125),
        DitherPixel(y: 0, x: 2, weight: 0.125),
        DitherPixel(y: 1, x: -1, weight: 0.125),
        DitherPixel(y: 1, x: 0, weight: 0.125),
        DitherPixel(y: 1, x: 1, weight: 0.125),
        DitherPixel(y: 2, x: 0, weight: 0.125),
      ]
    case .floydSteinberg:
      //      *   7
      //  3   5   1
      //
      //  (1/16)
      [
        DitherPixel(y: 0, x: 1, weight: 7.0 / 16.0),
        DitherPixel(y: 1, x: -1, weight: 3.0 / 16.0),
        DitherPixel(y: 1, x: 0, weight: 5.0 / 16.0),
        DitherPixel(y: 1, x: 1, weight: 1.0 / 16.0),
      ]
    case .jarvisJudiceNinke:
      //          *   7   5
      //  3   5   7   5   3
      //  1   3   5   3   1
      //
      //  (1/48)
      [
        DitherPixel(y: 0, x: 1, weight: 7.0 / 48.0),
        DitherPixel(y: 0, x: 2, weight: 5.0 / 48.0),
        DitherPixel(y: 1, x: -2, weight: 3.0 / 48.0),
        DitherPixel(y: 1, x: -1, weight: 5.0 / 48.0),
        DitherPixel(y: 1, x: 0, weight: 7.0 / 48.0),
        DitherPixel(y: 1, x: 1, weight: 5.0 / 48.0),
        DitherPixel(y: 1, x: 2, weight: 3.0 / 48.0),
        DitherPixel(y: 2, x: -2, weight: 1.0 / 48.0),
        DitherPixel(y: 2, x: -1, weight: 3.0 / 48.0),
        DitherPixel(y: 2, x: 0, weight: 4.0 / 48.0),
        DitherPixel(y: 2, x: 1, weight: 3.0 / 48.0),
        DitherPixel(y: 2, x: 2, weight: 1.0 / 48.0),
      ]
    case .stucki:
      //          *   8   4
      //  2   4   8   4   2
      //  1   2   4   2   1
      //
      //  (1/42)
      [
        DitherPixel(y: 0, x: 1, weight: 8.0 / 42.0),
        DitherPixel(y: 0, x: 2, weight: 4.0 / 42.0),
        DitherPixel(y: 1, x: -2, weight: 2.0 / 42.0),
        DitherPixel(y: 1, x: -1, weight: 4.0 / 42.0),
        DitherPixel(y: 1, x: 0, weight: 8.0 / 42.0),
        DitherPixel(y: 1, x: 1, weight: 4.0 / 42.0),
        DitherPixel(y: 1, x: 2, weight: 2.0 / 42.0),
        DitherPixel(y: 2, x: -2, weight: 1.0 / 42.0),
        DitherPixel(y: 2, x: -1, weight: 2.0 / 42.0),
        DitherPixel(y: 2, x: 0, weight: 4.0 / 42.0),
        DitherPixel(y: 2, x: 1, weight: 2.0 / 42.0),
        DitherPixel(y: 2, x: 2, weight: 1.0 / 42.0),
      ]
    case .burkes:
      //          *   8   4
      //  2   4   8   4   2
      //
      //  (1/42)
      [
        DitherPixel(y: 0, x: 1, weight: 8.0 / 32.0),
        DitherPixel(y: 0, x: 2, weight: 4.0 / 32.0),
        DitherPixel(y: 1, x: -2, weight: 2.0 / 32.0),
        DitherPixel(y: 1, x: -1, weight: 4.0 / 32.0),
        DitherPixel(y: 1, x: 0, weight: 8.0 / 32.0),
        DitherPixel(y: 1, x: 1, weight: 4.0 / 32.0),
        DitherPixel(y: 1, x: 2, weight: 2.0 / 32.0),
      ]
    }
  }
}
