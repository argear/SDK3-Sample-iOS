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
import ARGearSDK

final class ContentCell: CollectionViewCell {
  private lazy var indicator: UIActivityIndicatorView = {
    if #available(iOS 13, *) {
      let this = UIActivityIndicatorView(style: .medium)
      this.color = .white
      return this
    } else {
      let this = UIActivityIndicatorView(style: .white)
      return this
    }
  }()

  private let imageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    imageView.backgroundColor = .lightGray
    indicator.stopAnimating()
  }

  func set(content: ARGContentInfo) {
    indicator.startAnimating()

    DispatchQueue.global(qos: .background).async {
      guard let data = try? Data(contentsOf: content.thumbnailURI),
            let image = UIImage(data: data)
      else {
        return
      }

      DispatchQueue.main.async {
        self.imageView.image = image
        self.imageView.backgroundColor = .clear
        self.indicator.stopAnimating()
      }
    }
  }

  private func setupUI() {
    [
      imageView,
      indicator
    ].forEach {
      contentView.addSubview($0)
    }

    imageView.backgroundColor = .lightGray
    imageView.frame = contentView.bounds

    indicator.center = contentView.center
  }
}
