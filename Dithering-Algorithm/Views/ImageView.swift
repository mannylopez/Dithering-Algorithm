//
//  ContentView.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/13/25.
//

import SwiftUI
import UIKit

struct ImageView: View {
  @State private var topAlgorithm = Algorithm.floydSteinberg
  @State private var bottomAlgorithm = Algorithm.atkinson
  @State private var rgba: [[RGBA]] = []
  @State private var topImage: Image = Image(systemName: "xmark.circle")
  @State private var bottomImage: Image = Image(systemName: "xmark.circle")
  
  var body: some View {
    VStack {
      topPicker()
      
      topImage
        .resizable()
        .scaledToFit()
      
      bottomPicker()
      
      bottomImage
        .resizable()
        .scaledToFit()
      
    }
    .onAppear {
      updateTopImage()
      updateBottomImage()
    }
    .onChange(of: topAlgorithm, {
      updateTopImage()
    })
    .onChange(of: bottomAlgorithm, {
      updateBottomImage()
    })
    .padding()
  }
  
  private func updateTopImage() {
    rgba = topAlgorithm.rgbaMatrix(for: .space)
    if let cgImage = PixelReader.makeCGImage(from: rgba) {
      topImage = Image(decorative: cgImage, scale: 1.0)
    } else {
      topImage = Image(systemName: "xmark.circle")
    }
  }
  
  private func updateBottomImage() {
    rgba = bottomAlgorithm.rgbaMatrix(for: .space)
    if let cgImage = PixelReader.makeCGImage(from: rgba) {
      bottomImage = Image(decorative: cgImage, scale: 1.0)
    } else {
      bottomImage = Image(systemName: "xmark.circle")
    }
  }
  
  @ViewBuilder
  private func topPicker() -> some View {
    Picker("Algo", selection: $topAlgorithm) {
      ForEach(Algorithm.allCases, id: \.self) { algo in
        Text(algo.rawValue)
      }
    }
  }
  
  @ViewBuilder
  private func bottomPicker() -> some View {
    Picker("Algo", selection: $bottomAlgorithm) {
      ForEach(Algorithm.allCases, id: \.self) { algo in
        Text(algo.rawValue)
      }
    }
  }
}

#Preview {
  ImageView()
}
