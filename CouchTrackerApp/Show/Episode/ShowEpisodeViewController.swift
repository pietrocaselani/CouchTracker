import CouchTrackerCore
import Kingfisher
import RxCocoa
import RxSwift

final class ShowEpisodeViewController: UIViewController, ShowEpisodeView {
  var presenter: ShowEpisodePresenter!

  private let disposeBag = DisposeBag()

  @IBOutlet var screenshotImageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var numberLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var watchedLabel: UILabel!
  @IBOutlet var watchedSwich: UISwitch!

  override func viewDidLoad() {
    super.viewDidLoad()

    guard presenter != nil else { fatalError("view loaded without presenter") }

    view.backgroundColor = Colors.View.background

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
      .flatMap { [weak self] _ -> Observable<Never> in
        guard let strongSelf = self else { return Observable.empty() }
        return strongSelf.presenter.handleWatch().asObservable()
      }.observeOn(MainScheduler.instance)
      .subscribe(onError: { [weak self] error in
        self?.handleSync(error: error)
      }).disposed(by: disposeBag)

    presenter.viewDidLoad()
  }

  private func handleSync(error: Error) {
    let alert = UIAlertController.createErrorAlert(message: error.localizedDescription)
    present(alert, animated: true, completion: nil)
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

  private func show(episode: WatchedEpisodeEntity) {
    titleLabel.text = episode.episode.title
    numberLabel.text = "Season \(episode.episode.season) Episode \(episode.episode.number)"
    dateLabel.text = episode.episode.firstAired?.shortString() ?? "Unknown".localized
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
      showLoadingView()
    case .empty:
      showEmptyView()
    case let .error(error):
      showErrorView(error)
    case let .showing(episode):
      show(episode: episode)
    }
  }

  private func handleImageState(_ imageState: ShowEpisodeImageState) {
    switch imageState {
    case .none:
      showDefaultImage()
    case let .image(url):
      showEpisodeImage(with: url)
    case .loading:
      showLoadingImage()
    case .error:
      showDefaultImage()
    }
  }
}
