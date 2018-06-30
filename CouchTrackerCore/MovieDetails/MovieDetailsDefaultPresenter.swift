import RxSwift
import Foundation
import TraktSwift

public final class MovieDetailsDefaultPresenter: MovieDetailsPresenter {
	private let disposeBag = DisposeBag()
	private let interactor: MovieDetailsInteractor
	private let viewStateSubject = BehaviorSubject<MovieDetailsViewState>(value: .loading)
	private let imagesStateSubject = BehaviorSubject<MovieDetailsImagesState>(value: .loading)
	private var loginState = LoginState.notLogged

	public init(interactor: MovieDetailsInteractor, appConfigObservable: AppConfigurationsObservable) {
		self.interactor = interactor

		appConfigObservable.observe()
			.subscribe(onNext: { [weak self] appConfig in
				self?.loginState = appConfig.loginState
			}).disposed(by: disposeBag)
	}

	public func observeViewState() -> Observable<MovieDetailsViewState> {
		return viewStateSubject
	}

	public func observeImagesState() -> Observable<MovieDetailsImagesState> {
		return imagesStateSubject
	}

	public func handleWatched() -> Completable {
		guard let viewState = try? viewStateSubject.value(),
			case .showing(let movie) = viewState else {
			return Completable.empty()
		}

		guard case .logged = loginState else {
			return Completable.error(TraktError.loginRequired)
		}

		return interactor.toggleWatched(movie: movie)
			.do(onCompleted: { [weak self] in
				self?.updateDetails()
			})
	}

	public func viewDidLoad() {
		updateImages()

		updateDetails()
	}

	private func updateImages() {
		interactor.fetchImages()
			.map { MovieDetailsImagesState.showing(images: ImagesViewModelMapper.viewModel(for: $0))}
			.catchError { Maybe.just(MovieDetailsImagesState.error(error: $0)) }
			.ifEmpty(default: MovieDetailsImagesState.error(error: MovieDetailsError.noImageAvailable))
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] viewState in
				self?.imagesStateSubject.onNext(viewState)
			}).disposed(by: disposeBag)
	}

	private func updateDetails() {
		interactor.fetchDetails()
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] movie in
				let viewState = MovieDetailsViewState.showing(movie: movie)
				self?.viewStateSubject.onNext(viewState)
				}, onError: { [unowned self] error in
					let viewState = MovieDetailsViewState.error(error: error)
					self.viewStateSubject.onNext(viewState)
			}).disposed(by: disposeBag)
	}
}
