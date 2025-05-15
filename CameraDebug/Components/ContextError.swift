//
//  ContextError.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/15/25.
//

import Foundation

enum ContextError: LocalizedError {
    case unexpected
    case cameraDenied
    
    var errorDescription: String? {
        "Attention"
    }

    var message: String {
        switch self {
        case .cameraDenied:
            return "We need Access to your Camera to record. Please allow access to your Camera permission."
        case .unexpected:
            return "An unexpected error occurred"
        }
    }
}
