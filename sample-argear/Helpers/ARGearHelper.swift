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
  private let fetchDataQueue = DispatchQueue(label: "fetch")
  private var isContentDownloaded = [String : Bool]()

  private(set) var categories = [Category]()
  private(set) var currentCategory: Category?
  private(set) var currentContentUUID: String?

  func initialize() {
    setConfig()
    humanAR.initialize(.face)
  }

  func fetchCategories(key: String = "") {
    fetchDataQueue.async {
      let categories = self.humanAR.getContentCategory(key).map { Category(uuid: $0) }

      DispatchQueue.main.sync {
        self.categories = categories
      }
      
      NotificationCenter.default.post(
        name: .init(rawValue: "didCategoryFetchComplete"),
        object: nil
      )
    }
  }

  func fetchContents(categoryIndex: Int) {
    fetchDataQueue.async {
      let category = self.categories[categoryIndex]

      if let contents = category.contents, contents.count > 0 { return }

      let contentList = self.humanAR.getContentList(category.uuid, offset: 0, count: 0)
      category.setContents(contentList)

      DispatchQueue.main.sync {
        self.currentCategory = self.categories[categoryIndex]
      }

      NotificationCenter.default.post(
        name: .init(rawValue: "didContentsFetchComplete"),
        object: nil
      )
    }
  }

  func selectContent(contentIndex: Int) {
    guard let category = currentCategory,
          let content = category.contents?[contentIndex]
    else { return }

    if let uuid = currentContentUUID {
      if uuid == content.uuid { return }

      humanAR.cancelContent(uuid: uuid)
    }

    currentContentUUID = content.uuid

    fetchDataQueue.async {
      if !(self.isContentDownloaded[content.uuid] ?? false) {
        self.humanAR.getContent(content)
        self.isContentDownloaded.updateValue(true, forKey: content.uuid)
      }

      DispatchQueue.main.sync {
        self.humanAR.applyContent(uuid: content.uuid)
      }
    }
  }

  func reset() {
    guard let contentUUID = currentContentUUID else { return }
    humanAR.cancelContent(uuid: contentUUID)
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
}
