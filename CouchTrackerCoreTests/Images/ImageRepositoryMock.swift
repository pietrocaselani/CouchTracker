@testable import CouchTrackerCore
import Moya
import RxSwift
import TMDBSwift
import TVDBSwift

final class EmptyImageRepositoryMock: ImageRepository {
  init(tmdb _: TMDBProvider, tvdb _: TVDBProvider, cofigurationRepository _: ConfigurationRepository) {}

  func fetchMovieImages(for _: Int, posterSize _: PosterImageSize?, backdropSize _: BackdropImageSize?) -> Maybe<ImagesEntity> {
    return Maybe.empty()
  }

  func fetchShowImages(for _: Int, posterSize _: PosterImageSize?, backdropSize _: BackdropImageSize?) -> Maybe<ImagesEntity> {
    return Maybe.empty()
  }

  func fetchEpisodeImages(for _: EpisodeImageInput, size _: EpisodeImageSizes?) -> Maybe<URL> {
    return Maybe.empty()
  }
}

final class ImagesRepositorySampleMock: ImageRepository {
  var images: ImagesEntity
  var fetchMoviesImagesInvoked = false
  var fetchMoviesImagesParameters: (movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?)?
  var fetchShowsImagesInvoked = false
  var fetchShowsImagesParameters: (showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?)?
  var fetchEpisodeImagesInvoked = false
  var fetchEpisodeImagesParameters: (episode: EpisodeImageInput, size: EpisodeImageSizes?)?

  init() {
    let imageEntities = [ImageEntity(link: "", width: 10, height: 10, iso6391: nil, aspectRatio: 1.2, voteAverage: 2.3, voteCount: 5)]
    images = ImagesEntity(identifier: -1, backdrops: imageEntities, posters: imageEntities, stills: [ImageEntity]())
  }

  init(images: ImagesEntity) {
    self.images = images
  }

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    fetchMoviesImagesInvoked = true
    fetchMoviesImagesParameters = (movieId, posterSize, backdropSize)
    return Maybe.just(images)
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    fetchShowsImagesInvoked = true
    fetchShowsImagesParameters = (showId, posterSize, backdropSize)
    return Maybe.just(images)
  }

  func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL> {
    fetchEpisodeImagesInvoked = true
    fetchEpisodeImagesParameters = (episode, size)
    return Maybe.empty()
  }
}

final class ImageRepositoryMock: ImageRepository {
  typealias TMDBEpisodes = TMDBSwift.Episodes
  typealias TVDBEpisodes = TVDBSwift.Episodes

  private let tmdb: TMDBProvider
  private let tvdb: TVDBProvider
  private let configuration: ConfigurationRepository
  var fetchMovieImagesInvoked = false
  var fetchShowImagesInvoked = false
  var fetchEpisodeImagesInvoked = false
  var fetchEpisodeImagesParameters: (input: EpisodeImageInput, sizes: EpisodeImageSizes?)?

  init(tmdb: TMDBProvider, tvdb: TVDBProvider, cofigurationRepository: ConfigurationRepository) {
    self.tmdb = tmdb
    self.tvdb = tvdb
    configuration = cofigurationRepository
  }

  func fetchMovieImages(for movieId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    fetchMovieImagesInvoked = true
    let observable = configuration.fetchConfiguration().asObservable().flatMap { [unowned self] config -> Observable<ImagesEntity> in
      return self.tmdb.movies.rx.request(.images(movieId: movieId)).asObservable().map(Images.self).map {
        let posterSize = posterSize ?? .w342
        let backdropSize = backdropSize ?? .w300

        return ImagesEntityMapper.entity(for: $0, using: config, posterSize: posterSize, backdropSize: backdropSize)
      }
    }

    return observable.asMaybe()
  }

  func fetchShowImages(for showId: Int, posterSize: PosterImageSize?, backdropSize: BackdropImageSize?) -> Maybe<ImagesEntity> {
    fetchShowImagesInvoked = true
    let configurationObservable = configuration.fetchConfiguration()
    let imagesObservable = tmdb.shows.rx.request(.images(showId: showId)).map(Images.self).asObservable()

    return Observable.combineLatest(imagesObservable, configurationObservable) { images, configuration -> ImagesEntity in
      let posterSize = posterSize ?? .w342
      let backdropSize = backdropSize ?? .w300
      return ImagesEntityMapper.entity(for: images, using: configuration, posterSize: posterSize, backdropSize: backdropSize)
    }.asMaybe()
  }

  func fetchEpisodeImages(for episode: EpisodeImageInput, size: EpisodeImageSizes?) -> Maybe<URL> {
    fetchEpisodeImagesInvoked = true
    fetchEpisodeImagesParameters = (episode, size)

    let tmdbObservable = fetchEpisodeImageFromTMDB(episode, size)
    let tvdbObservable = fetchEpisodeImageFromTVDB(episode, size)

    return tmdbObservable.ifEmpty(switchTo: tvdbObservable).catchError { _ in tvdbObservable }
  }

  private func fetchEpisodeImageFromTVDB(_ episode: EpisodeImageInput, _ size: EpisodeImageSizes?) -> Maybe<URL> {
			guard let tvdbId = episode.tvdb else {
				return Maybe.empty()
			}

			let single = tvdb.episodes.rx.request(TVDBEpisodes.episode(id: tvdbId)).map(EpisodeResponse.self)

    return single.flatMapMaybe { response -> Maybe<URL> in
      guard let filename = response.episode.filename else { return Maybe.empty() }

      let size = size?.tvdb ?? TVDBEpisodeImageSize.normal
      let baseURL = size == TVDBEpisodeImageSize.normal ? TVDB.bannersImageURL : TVDB.smallBannersImageURL
      return Maybe.just(baseURL.appendingPathComponent(filename))
    }
  }

  private func fetchEpisodeImageFromTMDB(_ episode: EpisodeImageInput, _ size: EpisodeImageSizes?) -> Maybe<URL> {
    guard let tmdbId = episode.tmdb else {
      return Maybe.empty()
    }

    let target = TMDBEpisodes.images(showId: tmdbId, season: episode.season, episode: episode.number)
    let tmdbImages = tmdb.episodes.rx.request(target).map(Images.self).asObservable()
    let configurationObservable = configuration.fetchConfiguration()

    let imagesObservable = Observable.combineLatest(tmdbImages, configurationObservable) { (images, configuration) -> ImagesEntity in
      let tmdbSize = size?.tmdb ?? StillImageSize.w300
      return ImagesEntityMapper.entity(for: images, using: configuration, stillSize: tmdbSize)
    }

    let tmdbURLObservable = imagesObservable.flatMap { images -> Observable<URL> in
      guard let link = images.stillImage()?.link, let url = URL(string: link) else { return Observable.empty() }
      return Observable.just(url)
    }

    return tmdbURLObservable.asMaybe()
  }
}
