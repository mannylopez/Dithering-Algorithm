//
//  ContentView.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/13/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
  var body: some View {
    VStack {
      Image("cat_fullcolor")
        .resizable()
        .aspectRatio(contentMode: .fit)
      
      Text(readPixel())
    }
    .padding()
  }
  
  private func readPixel(x: Int = 639, y: Int = 639) -> String {
    guard
      let cgImage = UIImage(named: "cat_fullcolor")?.cgImage,
      let dataProvider = cgImage.dataProvider,
      let pixelData = dataProvider.data,
      let data = CFDataGetBytePtr(pixelData)
    else { return ""}
    
    let bytesPerPixel = 4
    let bytesPerRow = cgImage.bytesPerRow
    print("bytesPerRow", bytesPerRow)
    print("bytesPerPixel", bytesPerPixel)
    let pixelOffset = y * bytesPerRow + x * bytesPerPixel
    
    let red = data[pixelOffset]
    let green = data[pixelOffset + 1]
    let blue = data[pixelOffset + 2]
    let alpha = data[pixelOffset + 3]
    
    let rgba = ImageHelper.readAllPixels(from: StockImage.catFullColor)
    print(rgba.count)
    
    return "\(red), \(green), \(blue), \(alpha)"
    
  }
  
  
}

#Preview {
  ContentView()
}
