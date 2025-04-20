//
//  PixelReader+PixelCopy.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/19/25.
//

import CoreGraphics
import UIKit

// MARK: PixelReader + Pixel copy

extension PixelReader {
  /// Extracts RGBA color values from each pixel in the given image.
  /// This is a pixel for pixel copy of the incoming image.
  ///
  /// - Parameters:
  ///   - image: The `StockImage` to process.
  /// - Returns: An array of arrays containing the RGBA color values for each pixel in the source image.
  /// Each inner array represents a row, and each element within those arrays is an `RGBA` tuple representing a single pixel's color components.
  static func pixelCopyRGBA(from image: StockImage) -> [[RGBA]] {
    guard
      let cgImage = UIImage(named: image.rawValue)?.cgImage,
      let dataProvider = cgImage.dataProvider,
      let pixelData = dataProvider.data,
      let data = CFDataGetBytePtr(pixelData)
    else { return [] }
    
    let width = cgImage.width
    let height = cgImage.height
    
    let bytesPerPixel = 4
    let bytesPerRow = cgImage.bytesPerRow
    
    var rgbaValues: [[RGBA]] = []
    
    for y in 0..<height {
      var row: [RGBA] = []
      for x in 0..<width {
        let pixelOffset = y * bytesPerRow + x * bytesPerPixel
        let red = data[pixelOffset]
        let green = data[pixelOffset + 1]
        let blue = data[pixelOffset + 2]
        let alpha = data[pixelOffset + 3]
        row.append((red, green, blue, alpha))
      }
      rgbaValues.append(row)
    }
    return rgbaValues
  }
}
