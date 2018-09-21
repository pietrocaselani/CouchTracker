import Moya
import RxSwift
import TraktSwift

public final class DefaultGenreSynchronizer: GenreSynchronizer {
  private let trakt: TraktProvider
  private let holder: GenreDataHolder
  private let schedulers: Schedulers

  public init(trakt: TraktProvider, holder: GenreDataHolder, schedulers: Schedulers) {
    self.trakt = trakt
    self.holder = holder
    self.schedulers = schedulers
  }

  public func syncMoviesGenres() -> Single<[Genre]> {
    let stream = fetchGenresFromAPI(of: .movies)
    return saveGenresIntoHolder(genresStream: stream)
  }

  public func syncShowsGenres() -> Single<[Genre]> {
    let stream = fetchGenresFromAPI(of: .shows)
    return saveGenresIntoHolder(genresStream: stream)
  }

  private func fetchGenresFromAPI(of type: GenreType) -> Single<[Genre]> {
    return trakt.genres.rx.request(.list(type)).map([Genre].self)
  }

  private func saveGenresIntoHolder(genresStream: Single<[Genre]>) -> Single<[Genre]> {
    return genresStream.observeOn(schedulers.dataSourceScheduler)
      .do(onSuccess: { [weak self] genres in
        try self?.holder.save(genres: genres)
      })
  }
}
