import CouchTrackerCore
import Kingfisher
import RxSwift
import UIKit

final class PosterCell: UICollectionViewCell, PosterCellView {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var coverImageView: UIImageView!

  var presenter: PosterCellPresenter! {
    didSet {
      presenter.viewWillAppear()
    }
  }

  func show(viewModel: PosterCellViewModel) {
    titleLabel.text = viewModel.title
  }

  func showPosterImage(with url: URL) {
    coverImageView.kf.setImage(with: url, placeholder: R.image.posterPlacehoder())
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    coverImageView.image = nil
    titleLabel.text = nil
  }
}