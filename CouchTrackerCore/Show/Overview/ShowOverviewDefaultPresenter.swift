import RxSwift
import TraktSwift

public final class ShowOverviewDefaultPresenter: ShowOverviewPresenter {
	private let interactor: ShowOverviewInteractor
	private let disposeBag = DisposeBag()
	private let viewStateSubject = BehaviorSubject<ShowOverviewViewState>(value: .loading)
	private let imagesStateSubject = BehaviorSubject<ShowOverviewImagesState>(value: .loading)

	public init(interactor: ShowOverviewInteractor) {
		self.interactor = interactor
	}

	public func viewDidLoad() {
		interactor.fetchImages()
			.map {
				let viewModel = ImagesViewModelMapper.viewModel(for: $0)
				return ShowOverviewImagesState.showing(images: viewModel)
			}.catchError { error -> Maybe<ShowOverviewImagesState> in
				return Maybe.just(ShowOverviewImagesState.error(error: error))
			}.ifEmpty(default: ShowOverviewImagesState.empty)
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] state in
				self?.imagesStateSubject.onNext(state)
			}).disposed(by: disposeBag)

		interactor.fetchDetailsOfShow()
			.map { ShowOverviewViewState.showing(show: $0) }
			.catchError { Single.just(ShowOverviewViewState.error(error: $0)) }
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [weak self] state in
				self?.viewStateSubject.onNext(state)
			}).disposed(by: disposeBag)
	}

	public func observeViewState() -> Observable<ShowOverviewViewState> {
		return viewStateSubject
	}

	public func observeImagesState() -> Observable<ShowOverviewImagesState> {
		return imagesStateSubject
	}
}
