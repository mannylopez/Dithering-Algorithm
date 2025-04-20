//
//  PixelReader+Atkinson.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/14/25.
//

import CoreGraphics
import UIKit

// MARK: PixelReader + Atkinson

extension PixelReader {
  /// Grab RGBA values and convert to grayscale using ITU-R BT.709 luminance formula
  /// https://en.wikipedia.org/wiki/Rec._709#The_Y'C'BC'R_color_space
  static func atkinsonRGBA(from image: StockImage) -> [[RGBA]] {
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
    
    let ditherPattern: [DitherPixel] = Algorithm.atkinson.pattern()
    
    var grayscaleVector = [UInt8](repeating: 0, count: height * width)
    
    func setPixelLuminance(i: Int, j: Int, value: UInt8) {
      grayscaleVector[j + (i * width)] = value
    }
    
    func getPixelLuminance(i: Int, j: Int) -> UInt8 {
      grayscaleVector[j + (i * width)]
    }
    
    /// Grab RGBA values and convert to grayscale using ITU-R BT.709 luminance formula
    /// https://en.wikipedia.org/wiki/Rec._709#The_Y'C'BC'R_color_space
    for y in 0..<height {
      for x in 0..<width {
        let pixelOffset = y * bytesPerRow + x * bytesPerPixel
        
        let red = Self.multiplyPixel(pixelValue: data[pixelOffset], color: .red)
        let green = Self.multiplyPixel(pixelValue: data[pixelOffset + 1], color: .green)
        let blue = Self.multiplyPixel(pixelValue: data[pixelOffset + 2], color: .blue)
        let luminance = luminance(red: red, green: green, blue: blue)
        
        setPixelLuminance(i: y, j: x, value: luminance)
      }
    }
    
    // Apply dither algorithm
    for y in 0..<height {
      for x in 0..<width {
        let luminance = getPixelLuminance(i: y, j: x)
        let thresholdValue = luminance > 127 ? UInt8(255) : UInt8(0)
        let quantError = Double(luminance) - Double(thresholdValue)
        
        for ditherPixel in ditherPattern {
          let neighborY = y + ditherPixel.y
          let neighborX = x + ditherPixel.x
          
          // Only update neighbors that are within image bounds
          if
            neighborY >= 0,
            neighborY < height,
            neighborX >= 0,
            neighborX < width
          {
            let currentLuminance = getPixelLuminance(i: neighborY, j: neighborX)
            let distributedError = round(quantError * ditherPixel.weight)
            // Clamp new value between 0 and 255
            let newLuminance = max(min(Double(currentLuminance) + distributedError, 255), 0)
            // Set current pixel to threshold value
            setPixelLuminance(i: neighborY, j: neighborX, value: UInt8(newLuminance))
          }
          setPixelLuminance(i: y, j: x, value: thresholdValue)
        }
      }
    }
    
    var rgbaValues: [[RGBA]] = []
    
    for y in 0..<height {
      var row: [RGBA] = []
      for x in 0..<width {
        let pixelOffset = y * bytesPerRow + x * bytesPerPixel
        let luminance = getPixelLuminance(i: y, j: x)
        let alpha = data[pixelOffset + 3]
        row.append((luminance, luminance, luminance, alpha))
      }
      rgbaValues.append(row)
    }
    return rgbaValues
  }
}
