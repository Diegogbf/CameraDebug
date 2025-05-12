//
//  ContentView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/11/25.
//

import SwiftUI

struct StillPhotoView: View {
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Image("")
                    .resizable()
                    .foregroundStyle(.tint)
                    .background(Color.gray)
                    .cornerRadius(10)
                    .padding(35)
                Button(
                    action: {
                        
                    }
                ) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                        Circle()
                            .stroke(Color.gray.opacity(0.6), lineWidth: 5)
                            .frame(width: 70, height: 70)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .shadow(radius: 5)
                .offset(y: -50)
            }
            HStack {
                Button("Retake Photo") {
                    
                }
                .buttonStyle(CustomButton())
                Button("Continue") {
                    
                }
                .buttonStyle(CustomButton())
            }
        }
    }
}

#Preview {
    StillPhotoView()
}
