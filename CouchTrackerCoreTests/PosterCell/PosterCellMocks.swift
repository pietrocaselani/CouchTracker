@testable import CouchTrackerCore
import Foundation
import RxSwift

final class PosterCellViewMock: PosterCellView {
    var presenter: PosterCellPresenter!
    var invokedShowPosterImage = false
    var invokedShowViewModel = false
    var invokedPosterImageParameters: (url: URL, Void)?
    var invokedShowViewModelParameters: (viewModel: PosterCellViewModel, Void)?

    func showPosterImage(with url: URL) {
        invokedShowPosterImage = true
        invokedPosterImageParameters = (url, ())
    }

    func show(viewModel: PosterCellViewModel) {
        invokedShowViewModel = true
        invokedShowViewModelParameters = (viewModel, ())
    }
}

final class TrendingCellInteractorMock: PosterCellInteractor {
    private let imageRepository: ImageRepository

    init(imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
    }

    func fetchPosterImageURL(of type: PosterViewModelType, with size: PosterImageSize?) -> Maybe<URL> {
        if case let .movie(tmdbId) = type {
            let observable = imageRepository.fetchMovieImages(for: tmdbId, posterSize: size, backdropSize: nil).asObservable()
            return observable.flatMap { imageEntity -> Observable<URL> in
                guard let imageLink = imageEntity.posterImage()?.link, let url = URL(string: imageLink) else {
                    return Observable.empty()
                }

                return Observable.just(url)
            }.asMaybe()
        }

        return Maybe.empty()
    }
}
