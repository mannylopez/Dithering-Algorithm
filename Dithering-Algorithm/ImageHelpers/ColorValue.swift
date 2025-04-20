//
//  ColorValue.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/19/25.
//

import Foundation

enum ColorValue {
  case red
  case green
  case blue
  
  func luminance() -> Double {
    switch self {
    case .red:
      0.2126
    case .green:
      0.7152
    case .blue:
      0.0722
    }
  }
}
