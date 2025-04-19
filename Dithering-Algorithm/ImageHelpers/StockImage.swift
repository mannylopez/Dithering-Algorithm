//
//  StockImage.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/14/25.
//

import Foundation

enum StockImage: String, CaseIterable {
  case catFullColor = "cat_fullcolor"
  case space = "spacemd"
  
  func name() -> String {
    switch self {
    case .catFullColor:
      "Cat"
    case .space:
      "Carina nebula"
    }
  }
}
