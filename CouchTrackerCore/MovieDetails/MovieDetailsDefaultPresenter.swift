import RxSwift
import Foundation
import TraktSwift

public final class MovieDetailsDefaultPresenter: MovieDetailsPresenter {
	private let disposeBag = DisposeBag()
	private let interactor: MovieDetailsInteractor
	private let viewStateSubject = BehaviorSubject<MovieDetailsViewState>(value: .loading)
	private let imagesStateSubject = BehaviorSubject<MovieDetailsImagesState>(value: .loading)

	public init(interactor: MovieDetailsInteractor) {
		self.interactor = interactor
	}

	public func observeViewState() -> Observable<MovieDetailsViewState> {
		return viewStateSubject
	}

	public func observeImagesState() -> Observable<MovieDetailsImagesState> {
		return imagesStateSubject
	}

	public func viewDidLoad() {
		interactor.fetchImages()
			.map { MovieDetailsImagesState.showing(images: ImagesViewModelMapper.viewModel(for: $0))}
			.catchError { Maybe.just(MovieDetailsImagesState.error(error: $0)) }
			.ifEmpty(default: MovieDetailsImagesState.error(error: MovieDetailsError.noImageAvailable))
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] viewState in
				self?.imagesStateSubject.onNext(viewState)
			}).disposed(by: disposeBag)

		interactor.fetchDetails()
			.map { [unowned self] in self.mapToViewModel($0) }
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] viewModel in
				let viewState = MovieDetailsViewState.showing(viewModel: viewModel)
				self?.viewStateSubject.onNext(viewState)
				}, onError: { [unowned self] error in
					let viewState = MovieDetailsViewState.error(error: error)
					self.viewStateSubject.onNext(viewState)
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
