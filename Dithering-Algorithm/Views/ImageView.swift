//
//  ContentView.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/13/25.
//

import SwiftUI
import UIKit

struct ImageView: View {
  @State private var selectedAlgorithm = Algorithm.none
  @State private var rgba: [[RGBA]] = []
  @State private var rebuiltImage: Image = Image(systemName: "xmark.circle")
  
  var body: some View {
    VStack {
      Picker("Algo", selection: $selectedAlgorithm) {
        ForEach(Algorithm.allCases, id: \.self) { algo in
          Text(algo.rawValue)
        }
      }
      
      Image("cat_fullcolor")
        .resizable()
        .aspectRatio(contentMode: .fit)
      
      rebuiltImage
        .resizable()
        .scaledToFit()
      
    }
    .onAppear {
      updateImage()
    }
    .onChange(of: selectedAlgorithm, {
      updateImage()
    })
    .padding()
  }
  
  private func updateImage() {
    rgba = selectedAlgorithm.rgbaMatrix()
    if let cgImage = PixelReader.makeCGImage(from: rgba) {
      rebuiltImage = Image(decorative: cgImage, scale: 1.0)
    } else {
      rebuiltImage = Image(systemName: "xmark.circle")
    }
  }
}

#Preview {
  ImageView()
}
