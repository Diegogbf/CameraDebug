# CameraDebug

A modular Swift iOS application to handle photo and video capture using the device camera. The app provides clean separation of camera logic and UI, and includes a safe abstraction layer for managing `AVCaptureSession` to avoid race conditions.

## 📱 Features

- **StillPhotoView**
  - Capture still photos
  - Switch between front and rear cameras
  - Preview captured photos

- **VideoCaptureView**
  - Live video frame processing
  - Switch between front and rear cameras

- **ResultsView**
  - Display captured photos and video frames
  - Pinch-to-zoom functionality for image inspection

- **ZoomableScrollView**
  - Reusable SwiftUI-compatible scroll view
  - Handles pinch-to-zoom interactions using a UIKit bridge

- **CameraPreviewView**
  - Encapsulates live camera preview rendering
  - SwiftUI-compatible via UIKit bridge for seamless integration

## 🧱 Architecture

The project follows a modular structure with clear responsibility layers:

- **CameraLayer**
  - Encapsulates camera setup (input/output, session configuration, switching cameras)
  - Responsible for photo and video capture delegation

- **SessionAccessLayer**
  - Acts as a safe gatekeeper for accessing `AVCaptureSession`
  - Ensures thread-safe interaction to avoid race conditions during session manipulation

- **UIKit Bridge Components**
  - `ZoomableScrollView`: Uses `UIScrollView` to support zoom in SwiftUI
  - `CameraPreviewView`: Wraps `AVCaptureVideoPreviewLayer` in a SwiftUI-compatible `UIViewRepresentable`

## 📂 Project Structure

SwiftMediaCaptureApp/
├── CameraLayer/
│ ├── CameraManager.swift
│ ├── PhotoCaptureHandler.swift
│ └── VideoCaptureHandler.swift
├── SessionAccessLayer/
│ └── SessionController.swift
├── Views/
│ ├── StillPhotoViewController.swift
│ ├── VideoCaptureViewController.swift
│ └── ResultsViewController.swift
├── UIKitBridge/
│ ├── ZoomableScrollView.swift
│ └── CameraPreviewView.swift


## 🛠 Requirements

- iOS 18.4+
- Swift 5+
- Xcode 16+

## 📦 Installation

Clone this repository and open the project in Xcode:

```bash
git clone https://github.com/Diegogbf/CameraDebug.git
cd CameraDebug
open CameraDebug.xcodeproj


