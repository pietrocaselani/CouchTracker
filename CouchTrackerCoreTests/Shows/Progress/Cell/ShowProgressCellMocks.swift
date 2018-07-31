@testable import CouchTrackerCore
import RxSwift

final class ShowProgressCellMocks {
  final class View: ShowProgressCellView {
    var presenter: ShowProgressCellPresenter!

    var showViewModelInvoked = false
    var showViewModelParameters: WatchedShowViewModel?
    var showPosterImageInvoked = false
    var showPosterImageParameters: URL?

    func show(viewModel: WatchedShowViewModel) {
      showViewModelInvoked = true
      showViewModelParameters = viewModel
    }

    func showPosterImage(with url: URL) {
      showPosterImageInvoked = true
      showPosterImageParameters = url
    }
  }

  final class Interactor: ShowProgressCellInteractor {
    var fetchPosterImageURLInvoked = false
    var fetchPosterImageURLParameters: (tmdbId: Int, size: PosterImageSize?)?
    var imageError: Error?

    init(imageRepository _: ImageRepository) {}
    func fetchPosterImageURL(for tmdbId: Int, with size: PosterImageSize?) -> Maybe<URL> {
      fetchPosterImageURLInvoked = true
      fetchPosterImageURLParameters = (tmdbId, size)

      if let error = imageError {
        return Maybe.error(error)
      }

      let url = URL(fileURLWithPath: "fake/path/image.png")
      return Maybe.just(url)
    }
  }
}
