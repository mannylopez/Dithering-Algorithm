//
//  PixelReader.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/13/25.
//

import CoreGraphics
import UIKit

typealias RGBA = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)

struct PixelReader {
  
  /// Extracts RGBA color values from each pixel in the given image.
  ///
  /// - Parameters:
  ///   - image: The `StockImage` to process.
  /// - Returns: An array of arrays containing the RGBA color values for each pixel in the image.
  /// Each inner array represents a row, and each element within those arrays is an `RGBA` tuple representing a single pixel's color components.
  static func pixelsRGBA(from image: StockImage) -> [[RGBA]] {
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
  
  /// Creates a `CGImage` from an array of RGBA color values.
  ///
  /// This function converts a matrix of RGBA tuples into a `CGImage`.
  /// Each element in the input matrix represents a pixel's color components, and the function organizes
  /// these values to create an image suitable for use with Core Graphics.
  ///
  /// - Parameters:
  ///   - rgbaMatrix: A 2D array where each inner array contains `RGBA` tuples representing the red, green, blue, and alpha components of pixels.
  ///   Each row in this matrix corresponds to a row of pixels in the resulting image.
  /// - Returns: An optional `CGImage` object created from the provided RGBA values. If the input matrix is empty or invalid data provider creation fails, returns `nil`.
  static func makeCGImage(from rgbaMatrix: [[RGBA]]) -> CGImage? {
    let height = rgbaMatrix.count
    guard height > 0 else { return nil }
    let width = rgbaMatrix[0].count
    
    let bytesPerPixel = 4
    let bitsPerComponent = 8
    let bytesPerRow = width * bytesPerPixel
    
    var pixelData = [UInt8](repeating: 0, count: height * bytesPerRow)
    
    for y in 0..<height {
      for x in 0..<width {
        let offset = y * bytesPerRow + x * bytesPerPixel
        let pixel = rgbaMatrix[y][x]
        pixelData[offset]     = pixel.r
        pixelData[offset + 1] = pixel.g
        pixelData[offset + 2] = pixel.b
        pixelData[offset + 3] = pixel.a
      }
    }
    
    guard let providerRef = CGDataProvider(
      data: NSData(
        bytes: &pixelData,
        length: pixelData.count))
    else {
      return nil
    }
    
    return CGImage(
      width: width,
      height: height,
      bitsPerComponent: bitsPerComponent,
      bitsPerPixel: bitsPerComponent * bytesPerPixel,
      bytesPerRow: bytesPerRow,
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue),
      provider: providerRef,
      decode: nil,
      shouldInterpolate: false,
      intent: .defaultIntent
    )
  }
}
