import RxSwift

final class TrendingCelliOSPresenter: TrendingCellPresenter {
  private weak var view: TrendingCellView?
  private let interactor: TrendingCellInteractor
  private let viewModel: TrendingViewModel
  private let disposeBag = DisposeBag()

  init(view: TrendingCellView, interactor: TrendingCellInteractor, viewModel: TrendingViewModel) {
    self.view = view
    self.interactor = interactor
    self.viewModel = viewModel
  }

  func viewWillAppear() {
    view?.show(viewModel: TrendingCellViewModel(title: viewModel.title))

    guard let trendingType = viewModel.type else { return }

    interactor.fetchPosterImageURL(of: trendingType, with: .w185)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] imageURL in
        guard let view = self.view else { return }

        view.showPosterImage(with: imageURL)
      }).disposed(by: disposeBag)
  }
}
