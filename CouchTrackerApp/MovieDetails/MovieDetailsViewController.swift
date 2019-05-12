import CouchTrackerCore
import Kingfisher
import RxSwift

public final class MovieDetailsViewController: UIViewController {
  private typealias Strings = CouchTrackerCoreStrings
  private let presenter: MovieDetailsPresenter
  private let schedulers: Schedulers
  private let disposeBag = DisposeBag()

  private var movieView: MovieDetailsView {
    guard let movieView = self.view as? MovieDetailsView else {
      preconditionFailure("self.view should be of type MovieDetailsView")
    }
    return movieView
  }

  public init(presenter: MovieDetailsPresenter, schedulers: Schedulers = DefaultSchedulers.instance) {
    self.presenter = presenter
    self.schedulers = schedulers
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    view = MovieDetailsView()
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    adjustForNavigationBar()

    presenter.observeViewState()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] viewState in
        self?.handleViewState(viewState)
      }).disposed(by: disposeBag)

    presenter.observeImagesState()
      .observeOn(schedulers.mainScheduler)
      .subscribe(onNext: { [weak self] imagesState in
        self?.handleImagesState(imagesState)
      }).disposed(by: disposeBag)

    movieView.didTouchOnWatch = { [weak self] in
      self?.handleWatch()
    }

    presenter.viewDidLoad()
  }

  private func handleWatch() {
    presenter.handleWatched()
      .observeOn(schedulers.mainScheduler)
      .do(onSubscribe: { [weak self] in
        self?.movieView.watchButton.isLoading = true
      }, onDispose: { [weak self] in
        self?.movieView.watchButton.isLoading = false
      }).subscribe(onCompleted: nil) { [weak self] error in
        self?.showError(error)
      }.disposed(by: disposeBag)
  }

  private func handleViewState(_ viewState: MovieDetailsViewState) {
    switch viewState {
    case .loading:
      showLoadingView()
    case let .error(error):
      showErrorView(error)
    case let .showing(movie):
      show(details: movie)
    }
  }

  private func handleImagesState(_ imagesState: MovieDetailsImagesState) {
    switch imagesState {
    case let .showing(images):
      show(images: images)
    default: break
    }
  }

  private func showLoadingView() {}

  private func showErrorView(_ error: Error) {
    let errorAlert = UIAlertController.createErrorAlert(message: error.localizedDescription)
    present(errorAlert, animated: true)
  }

  private func showError(_ error: Error) {
    let message: String

    if let traktError = error as? TraktError {
      switch traktError {
      case .loginRequired: message = Strings.requiresTraktLogin()
      }
    } else {
      message = error.localizedDescription
    }

    let alertController = UIAlertController.createErrorAlert(message: message)

    present(alertController, animated: true)
  }

  private func show(details: MovieEntity) {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none

    let watchedText: String
    let watchButtonTitle: String

    if let watchedDate = details.watchedAt {
      watchedText = formatter.string(from: watchedDate)
      watchButtonTitle = Strings.removeFromHistory()
    } else {
      watchedText = Strings.unwatched()
      watchButtonTitle = Strings.addToHistory()
    }

    let releaseDate = details.releaseDate.map(formatter.string(from:)) ?? Strings.unknown()
    let genres = details.genres?.map { $0.name }.joined(separator: ", ") ?? Strings.unknown()

    movieView.titleLabel.text = details.title
    movieView.taglineLabel.text = details.tagline
    movieView.overviewLabel.text = details.overview
    movieView.releaseDateLabel.setText(title: "Release date", detail: releaseDate) // TODO: Translate
    movieView.genresLabel.setText(title: "Genres", detail: genres) // TODO: Translate
    movieView.watchedAtLabel.setText(title: "Watched at", detail: watchedText) // TODO: Translate
    movieView.watchButton.button.setTitle(watchButtonTitle, for: .normal)
  }

  private func show(images: ImagesViewModel) {
    if let backdropLink = images.backdropLink {
      movieView.backdropImageView.kf.setImage(with: backdropLink.toURL, placeholder: Images.backdropPlaceholder())
    }

    if let posterLink = images.posterLink {
      movieView.posterImageView.kf.setImage(with: posterLink.toURL, placeholder: Images.posterPlacehoder())
    }
  }
}
