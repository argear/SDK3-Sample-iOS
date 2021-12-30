/*******************************************************************************
 * Copyright(C) 2021 SEERSLAB Inc. All Rights Reserved.
 *
 * PROPRIETARY/CONFIDENTIAL
 *
 * This software is the confidential and proprietary information of
 * SEERSLAB Inc. You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license
 * agreement you entered into with SEERSLAB Inc.
 *
 * "SEERSLAB Inc." MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
 * NON-INFRINGEMENT. "SEERSLAB Inc." SHALL NOT BE LIABLE FOR ANY DAMAGES
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS
 * SOFTWARE OR ITS DERIVATIVES.
 *******************************************************************************/

import AVFoundation
import ARGearSDK

protocol SampleBufferProvider: AnyObject {
  func sampleBuffer(_ sampleBuffer: CMSampleBuffer)
}

final class CameraHelper: NSObject {
  private let queue = DispatchQueue(label: "CameraHelper")
  private let session = AVCaptureSession()
  private var devices = [AVCaptureDevice.Position : AVCaptureDevice]()
  private var videoDataOutput: AVCaptureVideoDataOutput?
  
  private(set) var position: AVCaptureDevice.Position = .front
  private(set) var pixelSize: CGSize = CGSize(width: 1080, height: 1920)
  
  weak var sampleBufferProvider: SampleBufferProvider?

  var fieldOfView: Float {
    devices[position]?.activeFormat.videoFieldOfView ?? 0
  }
  
  func start() {
    queue.async {
      if self.session.isRunning { return }
      
      self.devices = self.discoveryDevices()
      self.connectCamera(position: self.position)
      self.connectPixelBufferProvider()
      self.setPreset(.hd1920x1080)
      self.session.startRunning()
    }
  }
  
  func stop() {
    queue.async {
      guard self.session.isRunning else { return }
      
      self.session.stopRunning()
      self.devices = [:]
    }
  }
  
  func switchCamera() {
    queue.async {
      guard let currentCamera = self.session.inputs.first else { return }
      
      let nextPosition: AVCaptureDevice.Position = self.position == .front ? .back : .front
      
      self.position = nextPosition
      self.session.removeInput(currentCamera)
      self.connectCamera(position: nextPosition)
    }
  }
  
  private func discoveryDevices() -> [AVCaptureDevice.Position : AVCaptureDevice] {
    typealias Position = AVCaptureDevice.Position
    typealias Device = AVCaptureDevice
    
    let cameras = AVCaptureDevice.DiscoverySession(
      deviceTypes: [.builtInWideAngleCamera],
      mediaType: .video,
      position: .unspecified
    ).devices
    
    let inputs: [Position : Device] = cameras.reduce([:]) { result, device in
      var result = result
      result[device.position] = device
      return result
    }
    
    return inputs
  }
  
  private func connectCamera(position: AVCaptureDevice.Position) {
    session.beginConfiguration()
    
    guard let device = devices[position],
          let input = try? AVCaptureDeviceInput(device: device),
          session.canAddInput(input)
    else { return }
    
    session.addInput(input)
    session.commitConfiguration()
  }
  
  private func connectPixelBufferProvider() {
    if videoDataOutput != nil { return }
    
    session.beginConfiguration()
    
    let output = AVCaptureVideoDataOutput()
    
    guard session.canAddOutput(output) else { return }
    
    output.setSampleBufferDelegate(self, queue: queue)
    output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
    
    videoDataOutput = output
    
    session.addOutput(output)
    session.commitConfiguration()
  }
  
  private func setPreset(_ preset: AVCaptureSession.Preset) {
    guard session.canSetSessionPreset(preset) else { return }
    
    session.beginConfiguration()
    session.sessionPreset = preset
    session.commitConfiguration()
  }
}

extension CameraHelper: AVCaptureVideoDataOutputSampleBufferDelegate {
  func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    guard let connection = output.connections.first else { return }
    
    connection.videoOrientation = .portrait
    connection.isVideoMirrored = position == .front
    
    self.sampleBufferProvider?.sampleBuffer(sampleBuffer)
  }
}
