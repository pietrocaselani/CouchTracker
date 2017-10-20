import UIKit
import Kingfisher

final class ShowDetailsViewController: UIViewController, ShowDetailsView {
  var presenter: ShowDetailsPresenter!

  @IBOutlet weak var firstAiredLabel: UILabel!
  @IBOutlet weak var genresLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var networkLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backdropImageView: UIImageView!
  @IBOutlet weak var posterImageView: UIImageView!

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

  func show(images: ImagesViewModel) {
    if let posterLink = images.posterLink {
      posterImageView.kf.setImage(with: URL(string: posterLink), placeholder: R.image.posterPlacehoder(),
                                  options: nil, progressBlock: nil, completionHandler: nil)
    }

    if let backdropLink = images.backdropLink {
      backdropImageView.kf.setImage(with: URL(string: backdropLink), placeholder: R.image.backdropPlaceholder(),
                                    options: nil, progressBlock: nil, completionHandler: nil)
    }
  }
}
