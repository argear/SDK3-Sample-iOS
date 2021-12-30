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

import UIKit
import AVFoundation
import ARGearSDK

final class CameraViewController: UIViewController {

  // helpers

  private let cameraHelper = CameraHelper()
  private let argearHelper = ARGearHelper()

  // custom views
  
  private let previewView = PreviewView()

  private let cameraChangeButton = SymbolButton(systemName: "camera.rotate.fill")
  private let contentSelectButton = SymbolButton(systemName: "folder.fill")
  private let resetButton = SymbolButton(systemName: "clock.arrow.circlepath")

  private let selectorStackView = UIStackView()
  private let categoryCollectionView = CategoryCollectionView()
  private let contentCollectionView = ContentCollectionView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupObservers()
    setupUI()
    setupCamera()
    setupARGear()

    argearHelper.fetchCategories()
  }

  private func setupObservers() {
    NotificationCenter.default.addObserver(
      forName: .init(rawValue: "didCategoryFetchComplete"),
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }
      self.categoryCollectionView.reloadData()
    }

    NotificationCenter.default.addObserver(
      forName: .init(rawValue: "didContentsFetchComplete"),
      object: nil,
      queue: .main
    ) { [weak self] _ in
      guard let self = self else { return }
      self.contentCollectionView.reloadData()
    }
  }

  private func setupUI() {
    [
      previewView,
      selectorStackView
    ].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }

    setupPreviewView()
    setupCameraChangeButton()
    setupResetButton()
    setupSelectorStackView()

    cameraChangeButton.addTarget(
      self,
      action: #selector(switchCamera),
      for: .touchUpInside
    )

    contentSelectButton.addTarget(
      self,
      action: #selector(toggleContentSelectorVisible),
      for: .touchUpInside
    )

    resetButton.addTarget(
      self,
      action: #selector(reset),
      for: .touchUpInside
    )

  }

  private func setupCamera() {
    cameraHelper.sampleBufferProvider = self
    cameraHelper.start()
  }

  private func setupARGear() {
    argearHelper.initialize()
  }
  
  @objc private func switchCamera() {
    cameraHelper.switchCamera()
  }

  @objc private func toggleContentSelectorVisible() {
    selectorStackView.isHidden.toggle()
  }

  @objc private func reset() {
    argearHelper.reset()
  }
}


// MARK: - UI setup methods

extension CameraViewController {
  private func setupPreviewView() {
    NSLayoutConstraint.activate([
      previewView.leftAnchor.constraint(equalTo: view.leftAnchor),
      previewView.rightAnchor.constraint(equalTo: view.rightAnchor),
      previewView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      previewView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1920 / 1080)
    ])
  }

  private func setupCameraChangeButton() {
    cameraChangeButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(cameraChangeButton)

    NSLayoutConstraint.activate([
      cameraChangeButton.rightAnchor.constraint(equalTo: previewView.rightAnchor, constant: -8),
      cameraChangeButton.bottomAnchor.constraint(equalTo: previewView.bottomAnchor, constant: -8),
    ])
  }

  private func setupResetButton() {
    resetButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(resetButton)

    NSLayoutConstraint.activate([
      resetButton.rightAnchor.constraint(equalTo: previewView.rightAnchor, constant: -8),
      resetButton.bottomAnchor.constraint(equalTo: cameraChangeButton.topAnchor, constant: -8),
    ])
  }

  private func setupSelectorStackView() {
    // TODO: category selector view

    categoryCollectionView.dataSource = self
    categoryCollectionView.delegate = self

    // TODO: content selector view

    contentCollectionView.dataSource = self
    contentCollectionView.delegate = self

    selectorStackView.axis = .vertical
    selectorStackView.spacing = 4

    [
      categoryCollectionView,
      contentCollectionView
    ].forEach {
      selectorStackView.addArrangedSubview($0)
    }

    NSLayoutConstraint.activate([
      selectorStackView.leftAnchor.constraint(equalTo: previewView.leftAnchor, constant: 8),
      selectorStackView.rightAnchor.constraint(equalTo: cameraChangeButton.leftAnchor, constant: -8),
      selectorStackView.bottomAnchor.constraint(equalTo: previewView.bottomAnchor, constant: -8),
    ])
  }
}


// MARK: - implementation of SampleBufferProvider protocol

extension CameraViewController: SampleBufferProvider {
  func sampleBuffer(_ sampleBuffer: CMSampleBuffer) {
    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

    let isFrontFacing = cameraHelper.position == .front
    let fov = cameraHelper.fieldOfView
    let cameraConfig = ARGCameraConfig(isFrontFacing: isFrontFacing, orientation: 0, horizontalFOV: fov)
    let cameraFrameData = ARGCameraFrameData(cameraConfig: cameraConfig, buffer: pixelBuffer)

    DispatchQueue.main.sync {
      guard let resultFrame = argearHelper.process(cameraFrame: cameraFrameData)?.buffer else {
        self.previewView.layer.contents = pixelBuffer
        return
      }

      self.previewView.layer.contents = resultFrame
    }
  }
}


// MARK: - implementation of UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension CameraViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView is CategoryCollectionView {
      return argearHelper.categories.count
    } else {
      return argearHelper.currentCategory?.contents?.count ?? 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: UICollectionViewCell = {
      let id = collectionView is CategoryCollectionView ? CategoryCell.reuseIdentifier : ContentCell.reuseIdentifier
      return collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
    }()

    if collectionView is CategoryCollectionView {
      return cell as! CategoryCell
    } else {
      let contentCell = cell as! ContentCell
      guard let content = argearHelper.currentCategory?.contents?[indexPath.item] else { return cell }

      contentCell.set(content: content)
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView is CategoryCollectionView {
      argearHelper.fetchContents(categoryIndex: indexPath.item)
      contentCollectionView.isHidden = false
    } else {
      argearHelper.selectContent(contentIndex: indexPath.item)
    }
  }
}
