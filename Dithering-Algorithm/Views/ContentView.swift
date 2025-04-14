//
//  ContentView.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/13/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
  init() {
    let rgba = PixelReader.pixelsRGBA(from: .catFullColor)
    let cgImage = PixelReader.makeCGImage(from: rgba)
    if let cgImage {
      rebuiltImage = Image(decorative: cgImage, scale: 1.0)
    } else {
      rebuiltImage = Image(systemName: "xmark.circle")
    }
  }
  
  let rebuiltImage: Image
  
  var body: some View {
    VStack {
      Image("cat_fullcolor")
        .resizable()
        .aspectRatio(contentMode: .fit)
      
      rebuiltImage
        .resizable()
        .scaledToFit()
      
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
