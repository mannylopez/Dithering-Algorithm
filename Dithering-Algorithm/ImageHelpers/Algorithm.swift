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
  case aman = "Aman"
  case floydSteinberg = "Floyd-Steinberg"
  
  func rgbaMatrix(for image: StockImage = .catFullColor) -> [[RGBA]] {
    switch self {
    case .copy:
      PixelReader.pixelCopyRGBA(from: image)
    case .grayscale:
      PixelReader.grayscaleRGBA(from: image)
    case .thresholding:
      PixelReader.thresholdingRGBA(from: image)
    case .atkinson:
      PixelReader.atkinsonRGBA(from: image)
    case .aman:
      PixelReader.amanRGBA(from: image)
    case .floydSteinberg:
      PixelReader.floydSteinbergRGBA(from: image)
    }
  }
  
  func pattern() -> [DitherPixel] {
    switch self {
    case .copy:
      []
    case .grayscale:
      []
    case .thresholding:
      []
    case .atkinson:
      //      X   1   1
      //  1   1   1
      //      1
      //
      //    (1/8)
      [
        DitherPixel(y: 0, x: 1, weight: 0.125),
        DitherPixel(y: 0, x: 2, weight: 0.125),
        DitherPixel(y: 1, x: -1, weight: 0.125),
        DitherPixel(y: 1, x: 0, weight: 0.125),
        DitherPixel(y: 1, x: 1, weight: 0.125),
        DitherPixel(y: 2, x: 0, weight: 0.125),
      ]
    case .aman:
      [
        DitherPixel(y: 0, x: 1, weight: 0.25),
        DitherPixel(y: 0, x: 2, weight: 0.0625),
        DitherPixel(y: 1, x: -1, weight: 0.125),
        DitherPixel(y: 1, x: 0, weight: 0.25),
        DitherPixel(y: 1, x: 1, weight: 0.125),
        DitherPixel(y: 2, x: 0, weight: 0.0625),
      ]
    case .floydSteinberg:
      //      X   7
      //  3   5   1
      //
      //    (1/16)
      [
        DitherPixel(y: 0, x: 1, weight: 7.0 / 16.0),
        DitherPixel(y: 1, x: -1, weight: 3.0 / 16.0),
        DitherPixel(y: 1, x: 0, weight: 5.0 / 16.0),
        DitherPixel(y: 1, x: 1, weight: 1.0 / 16.0),
      ]
    }
  }
}
