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
  
  /// Calculates the grayscale luminance value from red, green, and blue channel contributions.
  ///
  /// This function assumes the input color channels have already been weighted by their respective luminance coefficients (e.g., from Rec. 709),
  /// and simply adds them together to compute the final luminance value. The result is
  /// clamped to a maximum of 255 and converted to an 8-bit unsigned integer.
  ///
  /// - Parameters:
  ///   - red: The weighted red channel value as a `Double`.
  ///   - green: The weighted green channel value as a `Double`.
  ///   - blue: The weighted blue channel value as a `Double`.
  ///
  /// - Returns: A grayscale luminance value as a `UInt8`, clamped to the range 0...255.
  static func luminance(red: Double, green: Double, blue: Double) -> UInt8{
    return UInt8(min(round(red + green + blue), 255))
    
  }
  
  /// Multiplies a raw pixel value by a color-specific luminance coefficient.
  ///
  /// This function is used to apply perceptual weighting to a color channel based on
  /// its contribution to overall luminance (e.g., red has a lower weight than green).
  ///
  /// - Parameters:
  ///   - pixelValue: The raw pixel intensity for a color channel (0–255).
  ///   - color: A `ColorValue` representing the channel (e.g., `.red`, `.green`, `.blue`).
  ///
  /// - Returns: The weighted luminance contribution of the color channel as a `Double`.
  static func multiplyPixel(pixelValue: UInt8, color: ColorValue) -> Double {
    Double(pixelValue) * color.luminance()
  }
  
  /// Converts a stock image into a 2D array of RGBA pixels using a specified dithering algorithm.
  ///
  /// This method loads a `StockImage`, converts it to grayscale using the ITU-R BT.709 luminance formula,
  /// applies the given dithering algorithm to distribute quantization error, and returns the result
  /// as a 2D array of `RGBA` tuples. The final output consists of grayscale RGBA values, where the R, G, and B
  /// channels are set to the same luminance value and the original alpha channel is preserved.
  ///
  /// - Parameters:
  ///   - image: The `StockImage` to be converted. This must correspond to a valid image asset in the app bundle.
  ///   - algorithm: A dithering `Algorithm` that provides a pattern of error diffusion via `DitherPixel`.
  ///
  /// - Returns: A two-dimensional array of `RGBA` tuples, where each row represents a line of pixels
  ///   in the output image. If the image fails to load, an empty array is returned.
  ///
  /// - Important: This method assumes the image data uses 4 bytes per pixel (RGBA format) and performs
  ///   in-place luminance error diffusion using the supplied dithering pattern.
  ///
  /// - SeeAlso:
  ///   - [Rec. 709 Luminance](https://en.wikipedia.org/wiki/Rec._709#The_Y'C'BC'R_color_space)
  ///
  /// - Note: This method does not resize or crop the image; the output will match the original image's dimensions.
  static func createRGBA(
    from image: StockImage,
    using algorithm: Algorithm)
  -> [[RGBA]]
  {
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
    
    let ditherPattern: [DitherPixel] = algorithm.pattern()
    
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
