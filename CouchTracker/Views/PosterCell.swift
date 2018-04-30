import UIKit
import Kingfisher
import RxSwift
import CouchTrackerCore

final class PosterCell: UICollectionViewCell, PosterCellView {
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var coverImageView: UIImageView!

	var presenter: PosterCellPresenter! {
		didSet {
			presenter.viewWillAppear()
		}
	}

	func show(viewModel: PosterCellViewModel) {
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
