//
//  FlipCameraButton.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/11/25.
//

import SwiftUI

struct FlipCameraButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.triangle.2.circlepath.camera")
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(Color.black.opacity(0.6)))
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .shadow(radius: 3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
