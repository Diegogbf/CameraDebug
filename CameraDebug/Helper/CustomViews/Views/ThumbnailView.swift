//
//  ThumbnailView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/15/25.
//

import SwiftUI

struct ThumbnailView: View {
    var image: UIImage?

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: 70, height: 70)
        .cornerRadius(11)
    }
}

#Preview {
    ThumbnailView()
}
