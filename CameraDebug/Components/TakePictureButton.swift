//
//  TakePictureButton.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/11/25.
//

import SwiftUI

struct TakePictureButton: View {
    let isRecording: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isRecording ? .red : .white)
                    .frame(width: 80, height: 80)
                Circle()
                    .stroke(isRecording ? .white : Color.gray.opacity(0.6), lineWidth: 5)
                    .frame(width: 70, height: 70)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .shadow(radius: 5)
    }
}
