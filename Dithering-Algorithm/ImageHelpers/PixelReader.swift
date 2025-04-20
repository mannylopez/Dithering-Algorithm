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
  
  static func luminance(red: Double, green: Double, blue: Double) -> UInt8{
    return UInt8(min(round(red + green + blue), 255))
    
  }
  
  static func multiplyPixel(pixelValue: UInt8, color: ColorValue) -> Double {
    Double(pixelValue) * color.luminance()
  }
}
  
