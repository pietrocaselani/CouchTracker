/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.

 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import UIKit

import Kingfisher

final class TrendingCell: UICollectionViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var coverImageView: UIImageView!

  func configure(for movie: TrendingViewModel) {
    titleLabel.text = movie.title

    guard let imageLink = movie.imageLink else {
      coverImageView.image = nil
      return
    }

    coverImageView.kf.setImage(with: URL(string: imageLink))
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    titleLabel.sizeToFit()
  }
}
