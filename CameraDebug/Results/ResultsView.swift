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
    let stillImage: UIImage
    let videoFrameImage: UIImage
    
    var body: some View {
        HStack(spacing: 24) {
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .background(Color.gray)
                .cornerRadius(10)
            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .background(Color.gray)
                .cornerRadius(10)
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
    }
}

#Preview {
    ResultsView(
        stillImage: .init(systemName: "pencil")!,
        videoFrameImage: .init(systemName: "pencil")!
    )
}
