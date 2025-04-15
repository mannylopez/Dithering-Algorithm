//
//  PixelReader+Thresholding.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/14/25.
//

import CoreGraphics
import UIKit

// MARK: PixelReader + Thresholding

extension PixelReader {
  /// Grab RGBA values and convert to grayscale using ITU-R BT.709 luminance formula
  /// https://en.wikipedia.org/wiki/Rec._709#The_Y'C'BC'R_color_space
  static func thresholdingRGBA(from image: StockImage) -> [[RGBA]] {
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
        
        let red = Self.multiplyPixel(pixelValue: data[pixelOffset], color: .red)
        let green = Self.multiplyPixel(pixelValue: data[pixelOffset + 1], color: .green)
        let blue = Self.multiplyPixel(pixelValue: data[pixelOffset + 2], color: .blue)
        let alpha = data[pixelOffset + 3]
        
        let luminance = luminance(red: red, green: green, blue: blue)
        
        let thresholdValue = luminance > 127 ? UInt8(255) : UInt8(0)
        
        row.append((thresholdValue, thresholdValue, thresholdValue, alpha))
      }
      rgbaValues.append(row)
    }
    return rgbaValues
  }
}
