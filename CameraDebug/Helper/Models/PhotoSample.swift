//
//  PhotoSample.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/15/25.
//

import AVFoundation
import UIKit

struct PhotoSample: Hashable {
    enum PhotoType: String {
        case stillPhoto = "Still Photo"
        case videoFrame = "Video Frame"
    }

    var postionDescription: String {
        switch position {
        case .back:
            return "Back"
        default:
            return "Front"
        }
    }

    let type: PhotoType
    let position: AVCaptureDevice.Position
    let image: UIImage
}
