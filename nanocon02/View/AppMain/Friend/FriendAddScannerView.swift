//
//  FriendAddScannerView.swift
//  nanocon02
//
//  Created by k22036kk on 2024/11/24.
//

import SwiftUI
import AVFoundation

struct FriendAddScannerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ScannerViewController
    
    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    var scanInterval: Double = 1.0
    var onResult: (String) -> Void
    
    func makeUIViewController(context: Context) -> ScannerViewController {
        let viewController = ScannerViewController()
        viewController.supportedBarcodeTypes = supportedBarcodeTypes
        viewController.scanInterval = scanInterval
        viewController.onResult = onResult
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
        // Update logic if necessary
    }
}

class ScannerViewController: UIViewController {
    var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
    var scanInterval: Double = 1.0
    var onResult: ((String) -> Void)?
    
    private let session = AVCaptureSession()
    private let delegate = QrCodeCameraDelegate()
    private let metadataOutput = AVCaptureMetadataOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraAuthorizationStatus()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    deinit {
        session.stopRunning()
    }
    
    private func setupCamera() {
        guard let backCamera = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the back camera.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            
            session.sessionPreset = .photo
            
            if session.canAddInput(input) {
                session.addInput(input)
            }
            
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.metadataObjectTypes = supportedBarcodeTypes
                metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
            previewLayer?.frame = view.bounds
            if let previewLayer = previewLayer {
                view.layer.addSublayer(previewLayer)
            }
            
            delegate.scanInterval = scanInterval
            delegate.onResult = onResult ?? { _ in }
            session.startRunning()
        } catch {
            print("Error setting up camera input: \(error)")
        }
    }
    
    private func checkCameraAuthorizationStatus() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupCamera()
                    }
                }
            }
        default:
            print("Camera access denied or restricted.")
        }
    }
}
