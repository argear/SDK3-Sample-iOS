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

import ARGearSDK

final class ARGearHelper: NSObject {
  private let humanAR = ARGHumanAR()
  private var isContentDownloaded = [String : Bool]()

  private(set) var categories = [Category]()
  private(set) var currentCategory: Category?
  private(set) var currentContentUUID: String?
  private(set) var isApplyingContent = false

  func initialize() {
    setConfig()
    humanAR.initialize(.face)
  }

  func fetchCategories(key: String = "", completion: @escaping () -> Void) {
    humanAR.getContentCategory { categoryInfos in
      self.categories = categoryInfos.map { Category($0) }

      completion()
    }
  }

  func fetchContents(categoryIndex: Int, completion: @escaping () -> Void) {
    let category = categories[categoryIndex]

    if category.contents.count > 0 { return }

    humanAR.getContentList(category: category.uuid, offset: 0, count: 0) { contentInfos in
      category.setContents(contentInfos)
      self.currentCategory = self.categories[categoryIndex]

      completion()
    }
  }

  func selectContent(contentIndex: Int) {
    if isApplyingContent { return }
    guard let content = currentCategory?.contents[contentIndex] else { return }

    if let applied = currentContentUUID {
      humanAR.cancelContent(uuid: applied)
      currentContentUUID = nil
    }

    isApplyingContent = true

    guard (isContentDownloaded[content.uuid] ?? false) else {
      DispatchQueue(label: "getContent").async {
        self.humanAR.getContent(content)

        DispatchQueue.main.async {
          self.isContentDownloaded.updateValue(true, forKey: content.uuid)
          self.applyContent(uuid: content.uuid)
        }
      }

      return
    }

    applyContent(uuid: content.uuid)
  }

  func reset() {
    humanAR.cancelAllContent()
    currentContentUUID = nil
  }

  func process(cameraFrame: ARGCameraFrameData, options: ARGHumanARProcessOptions = .none) -> ARGResultFrameData? {
    humanAR.process(cameraFrame: cameraFrame, options: options)
  }

  private func setConfig() {
    let config = ARGHumanARConfig()

    config.cmsURL = URL(string: "https://apis.argear.io")!
    config.apiKey = Keys.apiKey
    config.secretKey = Keys.secretKey
    config.authKey = Keys.authKey
    config.compressedContentPath = "CompressedContent"
    config.uncompressedContentPath = "UncompressedContent"

    humanAR.setConfiguration(config)
  }

  private func applyContent(uuid: String) {
    humanAR.applyContent(uuid: uuid)
    currentContentUUID = uuid
    isApplyingContent = false
  }
}
