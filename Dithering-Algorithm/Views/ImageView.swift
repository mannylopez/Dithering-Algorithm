//
//  ContentView.swift
//  Dithering-Algorithm
//
//  Created by Manuel Lopez on 4/13/25.
//

import SwiftUI
import UIKit

struct ImageView: View {
  @State private var topAlgorithmSelection = Algorithm.floydSteinberg
  @State private var topImageSelection = StockImage.catFullColor
  
  @State private var bottomAlgorithmSelection = Algorithm.atkinson
  @State private var bottomImageSelection = StockImage.space
  
  @State private var rgba: [[RGBA]] = []
  @State private var topImage: Image = Image(systemName: "xmark.circle")
  @State private var bottomImage: Image = Image(systemName: "xmark.circle")
  
  var body: some View {
    VStack {
      topPickers()
      
      topImage
        .resizable()
        .scaledToFit()
      
      bottomPickers()
      
      bottomImage
        .resizable()
        .scaledToFit()
      
    }
    .onAppear {
      updateTopImage()
      updateBottomImage()
    }
    .onChange(of: topAlgorithmSelection, {
      updateTopImage()
    })
    .onChange(of: bottomAlgorithmSelection, {
      updateBottomImage()
    })
    .onChange(of: topImageSelection, {
      updateTopImage()
    })
    .onChange(of: bottomImageSelection, {
      updateBottomImage()
    })
    .padding()
  }
  
  private func updateTopImage() {
    rgba = topAlgorithmSelection.rgbaMatrix(for: topImageSelection)
    if let cgImage = PixelReader.makeCGImage(from: rgba) {
      topImage = Image(decorative: cgImage, scale: 1.0)
    } else {
      topImage = Image(systemName: "xmark.circle")
    }
  }
  
  private func updateBottomImage() {
    rgba = bottomAlgorithmSelection.rgbaMatrix(for: bottomImageSelection)
    if let cgImage = PixelReader.makeCGImage(from: rgba) {
      bottomImage = Image(decorative: cgImage, scale: 1.0)
    } else {
      bottomImage = Image(systemName: "xmark.circle")
    }
  }
  
  @ViewBuilder
  private func topPickers() -> some View {
    HStack {
      topImagePicker()
      topAlgoPicker()
    }
  }
  
  @ViewBuilder
  private func topAlgoPicker() -> some View {
    Picker("Algo", selection: $topAlgorithmSelection) {
      ForEach(Algorithm.allCases, id: \.self) { algo in
        Text(algo.rawValue)
      }
    }
  }
  
  @ViewBuilder
  private func topImagePicker() -> some View {
    Picker("Image", selection: $topImageSelection) {
      ForEach(StockImage.allCases, id: \.self) { image in
        Text(image.name())
      }
    }
  }
  
  @ViewBuilder
  private func bottomPickers() -> some View {
    HStack {
      bottomImagePicker()
      bottomAlgoPicker()
    }
  }
  
  @ViewBuilder
  private func bottomAlgoPicker() -> some View {
    Picker("Algo", selection: $bottomAlgorithmSelection) {
      ForEach(Algorithm.allCases, id: \.self) { algo in
        Text(algo.rawValue)
      }
    }
  }
  
  @ViewBuilder
  private func bottomImagePicker() -> some View {
    Picker("Image", selection: $bottomImageSelection) {
      ForEach(StockImage.allCases, id: \.self) { image in
        Text(image.name())
      }
    }
  }
}

#Preview {
  ImageView()
}
