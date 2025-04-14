//
//  ImageHelper.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/13/25.
//

import UIKit

typealias RGBA = (r: UInt8, g: UInt8, b: UInt8, a: UInt8)

struct ImageHelper {
  static func readAllPixels(from image: StockImage) -> [[RGBA]] {
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
    
    print("bytesPerRow", bytesPerRow)
    print("bytesPerPixel", bytesPerPixel)
    
    //    var rgbaValues: [[RGBA]] = [[]]
    
    var rgbaValues: [[RGBA]] = Array(
      repeating: Array(repeating: (0, 0, 0, 0), count: width),
      count: height
    )
    
    for y in 0..<height {
      for x in 0..<width {
        let pixelOffset = y * bytesPerRow + x * bytesPerPixel
        let red = data[pixelOffset]
        let green = data[pixelOffset + 1]
        let blue = data[pixelOffset + 2]
        let alpha = data[pixelOffset + 3]
        rgbaValues[y][x] = (red, green, blue, alpha)
      }
    }
    return rgbaValues
  }
}

enum StockImage: String {
  case catFullColor = "cat_fullcolor"
}
