import CouchTrackerCore
import Kingfisher
import RxSwift
import UIKit

final class ShowOverviewViewController: UIViewController, ShowOverviewView {
  var presenter: ShowOverviewPresenter!

  private let disposeBag = DisposeBag()

  @IBOutlet var firstAiredLabel: UILabel!
  @IBOutlet var genresLabel: UILabel!
  @IBOutlet var overviewLabel: UILabel!
  @IBOutlet var networkLabel: UILabel!
  @IBOutlet var statusLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var backdropImageView: UIImageView!
  @IBOutlet var posterImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    presenter.observeImagesState()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] imageState in
        self?.handleImageState(imageState)
      }).disposed(by: disposeBag)

    presenter.observeViewState()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleImageState(_ imageState: ShowOverviewImagesState) {
    switch imageState {
    case .empty: break
    case .loading: break
    case let .showing(images):
      show(images: images)
    case let .error(error):
      print(error.localizedDescription)
    }
  }

  private func handleViewState(_ viewState: ShowOverviewViewState) {
    switch viewState {
    case .loading: return
    case let .showing(show):
      self.show(details: show)
    case let .error(error):
      print(error.localizedDescription)
    }
  }

  func show(details: ShowEntity) {
    let firstAired = details.firstAired?.parse() ?? "Unknown".localized

    let genres = details.genres.map { $0.name }.joined(separator: " | ")

    titleLabel.text = details.title ?? "TBA".localized
    statusLabel.text = details.status?.rawValue.localized ?? "Unknown".localized
    networkLabel.text = details.network ?? "Unknown".localized
    overviewLabel.text = details.overview
    genresLabel.text = genres
    firstAiredLabel.text = firstAired
  }

  func show(images: ImagesViewModel) {
    if let posterLink = images.posterLink {
      posterImageView.kf.setImage(with: URL(string: posterLink), placeholder: R.image.posterPlacehoder())
    }

    if let backdropLink = images.backdropLink {
      backdropImageView.kf.setImage(with: URL(string: backdropLink), placeholder: R.image.backdropPlaceholder())
    }
  }
}
