import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import CouchTrackerCore

final class ShowEpisodeViewController: UIViewController, ShowEpisodeView {
	var presenter: ShowEpisodePresenter!

	private let disposeBag = DisposeBag()

	@IBOutlet weak var screenshotImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var numberLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var watchedLabel: UILabel!
	@IBOutlet weak var watchedSwich: UISwitch!

	override func viewDidLoad() {
		super.viewDidLoad()

		guard presenter != nil else { fatalError("view loaded without presenter") }

		presenter.observeViewState()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] viewState in
				self?.handleViewState(viewState)
			}).disposed(by: disposeBag)

		presenter.observeImageState()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] imageState in
				self?.handleImageState(imageState)
			}).disposed(by: disposeBag)

		watchedSwich.isOn = false

		watchedSwich.rx.isOn.changed
			.asMaybe()
			.flatMap { [weak self] _ in
				guard let strongSelf = self else { return Maybe.empty() }
				return strongSelf.presenter.handleWatch()
			}.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] syncResult in
				self?.handleSyncResult(syncResult)
			}).disposed(by: disposeBag)

		presenter.viewDidLoad()
	}

	private func handleSyncResult(_ syncResult: SyncResult) {
		if case .fail(let error) = syncResult {
			let alert = UIAlertController.createErrorAlert(message: error.localizedDescription)
			self.present(alert, animated: true, completion: nil)
		}
	}

	private func showEmptyView() {
		print("Nothing to show here!")
	}

	private func showLoadingView() {
		print("Loading view...")
	}

	private func showErrorView(_ error: Error) {
		print("Error view: \(error.localizedDescription)")
	}

	func show(episode: EpisodeEntity) {
		titleLabel.text = episode.title
		numberLabel.text = "Season \(episode.season) Episode \(episode.number)"
		dateLabel.text = episode.firstAired?.shortString() ?? "Unknown".localized
		watchedSwich.isOn = episode.lastWatched != nil
	}

	private func showDefaultImage() {
		print("No image for episode")
	}

	private func showLoadingImage() {
		print("loading image for episode")
	}

	private func showEpisodeImage(with url: URL) {
		screenshotImageView.kf.setImage(with: url)
	}

	private func handleViewState(_ viewState: ShowEpisodeViewState) {
		switch viewState {
		case .loading:
			self.showLoadingView()
		case .empty:
			self.showEmptyView()
		case .error(let error):
			self.showErrorView(error)
		case .showing(let episode):
			self.show(episode: episode)
		}
	}

	private func handleImageState(_ imageState: ShowEpisodeImageState) {
		switch imageState {
		case .none:
			self.showDefaultImage()
		case .image(let url):
			self.showEpisodeImage(with: url)
		case .loading:
			self.showLoadingImage()
		case .error:
			self.showDefaultImage()
		}
	}
}
