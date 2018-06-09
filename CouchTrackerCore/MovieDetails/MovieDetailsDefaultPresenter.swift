import RxSwift
import Foundation
import TraktSwift

public final class MovieDetailsDefaultPresenter: MovieDetailsPresenter {
	private let disposeBag = DisposeBag()
	private weak var view: MovieDetailsView?
	private let interactor: MovieDetailsInteractor
	private let router: MovieDetailsRouter
	private let viewStateSubject = BehaviorSubject<MovieDetailsViewState>(value: .loading)

	public init(view: MovieDetailsView, interactor: MovieDetailsInteractor, router: MovieDetailsRouter) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}

	public func observeViewState() -> Observable<MovieDetailsViewState> {
		return viewStateSubject
	}

	public func observeImagesState() -> Observable<MovieDetailsImagesState> {
		return Observable.empty()
	}

	public func viewDidLoad() {
		interactor.fetchImages()
			.map { ImagesViewModelMapper.viewModel(for: $0) }
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [unowned self] imagesViewModel in
				self.view?.show(images: imagesViewModel)
			}).disposed(by: disposeBag)

		interactor.fetchDetails()
			.map { [unowned self] in self.mapToViewModel($0) }
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] viewModel in
				let viewState = MovieDetailsViewState.showing(viewModel: viewModel)
				self?.viewStateSubject.onNext(viewState)

				self?.view?.show(details: viewModel)
				}, onError: { [unowned self] error in
					let viewState = MovieDetailsViewState.error(error: error)
					self.viewStateSubject.onNext(viewState)

					if let detailsError = error as? MovieDetailsError {
						self.router.showError(message: detailsError.message)
					} else {
						self.router.showError(message: error.localizedDescription)
					}
			}).disposed(by: disposeBag)
	}

	private func mapToViewModel(_ movie: MovieEntity) -> MovieDetailsViewModel {
		let releaseDate = movie.releaseDate?.parse() ?? "Unknown".localized
		let genres = movie.genres?.map { $0.name }.joined(separator: " | ")

		return MovieDetailsViewModel(
			title: movie.title ?? "TBA".localized,
			tagline: movie.tagline ?? "",
			overview: movie.overview ?? "",
			genres: genres ?? "",
			releaseDate: releaseDate)
	}
}
