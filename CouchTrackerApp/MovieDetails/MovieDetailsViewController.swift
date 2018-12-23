import CouchTrackerCore
import Kingfisher
import RxSwift
import UIKit

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
  @IBOutlet var watchedLabel: UILabel!
  @IBOutlet var watchedSwtich: UISwitch!

  override func viewDidLoad() {
    super.viewDidLoad()

    watchedSwtich.isOn = false

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

  @IBAction func toggleWatched(_: Any) {
    presenter.handleWatched()
      .observeOn(MainScheduler.instance)
      .subscribe(onCompleted: nil) { [weak self] error in
        guard let strongSelf = self else { return }

        strongSelf.showError(error)
      }.disposed(by: disposeBag)
  }

  private func showError(_ error: Error) {
    let message: String

    if let traktError = error as? TraktError {
      switch traktError {
      case .loginRequired: message = "Trakt login required".localized
      }
    } else {
      message = error.localizedDescription
    }

    let alertController = UIAlertController.createErrorAlert(message: message)

    present(alertController, animated: true) {
      let isOn = self.watchedSwtich.isOn
      self.watchedSwtich.isOn = !isOn
    }
  }

  private func handleViewState(_ viewState: MovieDetailsViewState) {
    switch viewState {
    case .loading:
      print("Loading...")
    case let .error(error):
      let errorAlert = UIAlertController.createErrorAlert(message: error.localizedDescription)
      present(errorAlert, animated: true)
    case let .showing(movie):
      show(details: movie)
    }
  }

  private func handleImagesState(_ imagesState: MovieDetailsImagesState) {
    switch imagesState {
    case .loading:
      print("Loading images...")
    case let .error(error):
      print("Error images \(error.localizedDescription)")
    case let .showing(images):
      show(images: images)
    }
  }

  private func show(details: MovieEntity) {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none

    let watchedText: String

    if let watchedDate = details.watchedAt {
      watchedText = "Watched at".localized + formatter.string(from: watchedDate)
    } else {
      watchedText = "Unwatched".localized
    }

    let releaseDate = details.releaseDate.map(formatter.string(from:)) ?? "Unknown".localized
    let genres = details.genres?.map { $0.name }.joined(separator: " | ")

    titleLabel.text = details.title
    taglineLabel.text = details.tagline
    overviewLabel.text = details.overview
    releaseDateLabel.text = releaseDate
    genresLabel.text = genres
    watchedLabel.text = watchedText
    watchedSwtich.isOn = details.watchedAt != nil
  }

  private func show(images: ImagesViewModel) {
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
