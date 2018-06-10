import UIKit
import Kingfisher
import CouchTrackerCore
import RxSwift

final class MovieDetailsViewController: UIViewController, MovieDetailsView {
	var presenter: MovieDetailsPresenter!

	private let disposeBag = DisposeBag()

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var taglineLabel: UILabel!
	@IBOutlet var overviewLabel: UILabel!
	@IBOutlet var releaseDateLabel: UILabel!
	@IBOutlet var genresLabel: UILabel!
	@IBOutlet var backdropImageView: UIImageView!
	@IBOutlet var posterImageView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()

		presenter.observeViewState()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] viewState in
				self?.handleViewState(viewState)
			}).disposed(by: disposeBag)

		presenter.observeImagesState()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] imagesState in
				self?.handleImagesState(imagesState)
			}).disposed(by: disposeBag)

		presenter.viewDidLoad()
	}

	private func handleViewState(_ viewState: MovieDetailsViewState) {
		switch viewState {
		case .loading:
			print("Loading...")
		case .error(let error):
			let errorAlert = UIAlertController.createErrorAlert(message: error.localizedDescription)
			self.present(errorAlert, animated: true)
		case .showing(let viewModel):
			show(details: viewModel)
		}
	}

	private func handleImagesState(_ imagesState: MovieDetailsImagesState) {
		switch imagesState {
		case .loading:
			print("Loading images...")
		case .error(let error):
			print("Error images \(error.localizedDescription)")
		case .showing(let images):
			self.show(images: images)
		}
	}

	func show(details: MovieDetailsViewModel) {
		titleLabel.text = details.title
		taglineLabel.text = details.tagline
		overviewLabel.text = details.overview
		releaseDateLabel.text = details.releaseDate
		genresLabel.text = details.genres
	}

	func show(images: ImagesViewModel) {
		if let backdropLink = images.backdropLink {
			backdropImageView.kf.setImage(with: URL(string: backdropLink), placeholder: R.image.backdropPlaceholder(),
																		options: nil, progressBlock: nil, completionHandler: nil)
		}

		if let posterLink = images.posterLink {
			posterImageView.kf.setImage(with: URL(string: posterLink), placeholder: R.image.posterPlacehoder(),
																	options: nil, progressBlock: nil, completionHandler: nil)
		}
	}
}
