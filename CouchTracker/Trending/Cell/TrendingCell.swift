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
import RxSwift

final class TrendingCell: UICollectionViewCell, TrendingCellView {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var coverImageView: UIImageView!

  var presenter: TrendingCellPresenter! {
    didSet {
      presenter.viewWillAppear()
    }
  }

  func show(viewModel: TrendingCellViewModel) {
    titleLabel.text = viewModel.title
  }

  func showPosterImage(with url: URL) {
    coverImageView.kf.setImage(with: url, placeholder: R.image.posterPlacehoder(),
                               options: nil, progressBlock: nil, completionHandler: nil)
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    coverImageView.image = nil
    titleLabel.text = nil
  }
}
