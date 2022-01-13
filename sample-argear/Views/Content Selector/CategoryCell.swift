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

final class CategoryCell: CollectionViewCell {
  override var isSelected: Bool {
    didSet {
      contentView.backgroundColor = isSelected ? .lightGray : .white
    }
  }

  var category: Category? {
    didSet {
      titleLabel.text = category?.title
    }
  }

  private let button = UIButton()
  private let titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentView.backgroundColor = .white
    contentView.layer.cornerRadius = 8
    contentView.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = .black

    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
      titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
    ])
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    contentView.backgroundColor = .white
  }
}
