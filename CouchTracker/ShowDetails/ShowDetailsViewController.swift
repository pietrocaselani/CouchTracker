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

final class ShowDetailsViewController: UIViewController, ShowDetailsView {
  var presenter: ShowDetailsPresenter!

  @IBOutlet weak var firstAiredLabel: UILabel!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var networkLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backdropImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    presenter.viewDidLoad()
  }

  func show(details: ShowDetailsViewModel) {
    titleLabel.text = details.title
    statusLabel.text = details.status
    networkLabel.text = details.network
    overviewLabel.text = details.overview
    genresLabel.text = details.genres
    firstAiredLabel.text = details.firstAired
  }
}
