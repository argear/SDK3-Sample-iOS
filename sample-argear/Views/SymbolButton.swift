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

class SymbolButton: UIButton {
  override var intrinsicContentSize: CGSize {
    CGSize(width: 50, height: 50)
  }

  init(frame: CGRect = .zero, systemName: String) {
    super.init(frame: frame)

    if frame == .zero {
      NSLayoutConstraint.activate([
        widthAnchor.constraint(equalToConstant: intrinsicContentSize.width),
        heightAnchor.constraint(equalToConstant: intrinsicContentSize.height)
      ])
    }

    let symbolConfig = UIImage.SymbolConfiguration(pointSize: intrinsicContentSize.width / 2)
    let image = UIImage(systemName: systemName, withConfiguration: symbolConfig)

    setImage(image, for: .normal)
    imageView!.contentMode = .scaleAspectFit

    backgroundColor = .white
    tintColor = .black

    layer.cornerRadius = intrinsicContentSize.width / 2
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
