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

final class MovieDetailsViewController: UIViewController, MovieDetailsView {

  var presenter: MovieDetailsPresenter!

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var taglineLabel: UILabel!
  @IBOutlet var overviewLabel: UILabel!
  @IBOutlet var releaseDateLabel: UILabel!
  @IBOutlet var genresLabel: UILabel!
  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var posterImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    presenter.viewDidLoad()
  }

  func show(details: MovieDetailsViewModel) {
    titleLabel.text = details.title
    taglineLabel.text = details.tagline
    overviewLabel.text = details.overview
    releaseDateLabel.text = details.releaseDate
    genresLabel.text = details.genres
  }

}
