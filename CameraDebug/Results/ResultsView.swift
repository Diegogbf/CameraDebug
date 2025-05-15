//
//  ResultsView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/13/25.
//

import SwiftUI

struct ResultsView: View {
    @State private var currentZoom = 0.0
    @State private var lastPosition = 1.0
    var stillPhotoSample: PhotoSample?
    var videoFrameSample: PhotoSample?
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 24) {
                createSampleView(stillPhotoSample)
                createSampleView(videoFrameSample)
            }
            .scaleEffect(currentZoom + lastPosition)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentZoom = value.magnification - 1
                    }
                    .onEnded { value in
                        lastPosition += currentZoom
                        currentZoom = 0
                    }
            )
            .frame(height: geometry.size.height * 0.7)
            .padding(
                .vertical, geometry.size.width * 0.2
            )
            .padding(
                .horizontal, 20
            )
        }
    }

    private func createSampleView(_ sample: PhotoSample?) -> some View {
        VStack(spacing: 24) {
            if let sample {
                ResultImageView(image: sample.image)
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(sample.type.rawValue)")
                    Text("Camera position: \(sample.postionDescription)")
                }
            }
        }
    }
}

struct ResultImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
    }
}

#Preview {
    ResultsView()
}
