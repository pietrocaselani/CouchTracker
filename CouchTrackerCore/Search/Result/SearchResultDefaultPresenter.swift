import RxSwift
import TraktSwift

public final class SearchResultDefaultPresenter: SearchResultPresenter, SearchResultOutput {
  private weak var view: SearchResultView?
  private let router: SearchResultRouter
  private var results = [SearchResult]()

  public init(view: SearchResultView, router: SearchResultRouter) {
    self.view = view
    self.router = router
  }

  public func selectResult(at index: Int) {
    let result = results[index]
    router.showDetails(of: result)
  }

  public func searchChangedTo(state: SearchState) {
    guard let view = self.view else { return }

    if state == .searching {
      view.showSearching()
    } else {
      view.showNotSearching()
    }
  }

  public func handleEmptySearchResult() {
    view?.showEmptyResults()
  }

  public func handleSearch(results: [SearchResult]) {
    self.results = results

    guard let view = self.view else { return }

    let viewModels = results.map(mapToViewModel)
    view.show(viewModels: viewModels)
  }

  public func handleError(message: String) {
    view?.showError(message: message)
  }

  private func mapToViewModel(_ result: SearchResult) -> PosterViewModel {
    let viewModel: PosterViewModel

    switch result.type {
    case .show:
      guard let show = result.show else {
        Swift.fatalError("Search result is show, but there is no show associated")
      }
      viewModel = PosterShowViewModelMapper.viewModel(for: show)
    case .movie:
      guard let movie = result.movie else {
        Swift.fatalError("Search result is movie, but there is no movie associated")
      }
      viewModel = PosterMovieViewModelMapper.viewModel(for: movie)
    default:
      Swift.fatalError("Search result mapper not implemented yet")
    }

    return viewModel
  }
}
