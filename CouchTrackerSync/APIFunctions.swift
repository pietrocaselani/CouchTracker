import RxSwift

func syncWatchedShows(extended: [Extended]) -> Single<[BaseShow]> {
  return trakt.sync.rx
    .request(.watched(type: .shows, extended: extended))
    .observeOn(scheduler)
    .filterSuccessfulStatusAndRedirectCodes()
    .map([BaseShow].self)
}

func watchedProgress(options: WatchedProgressOptions, showIds: ShowIds) -> Single<BaseShow> {
  return trakt.shows.rx.request(
    .watchedProgress(
      showId: showIds.realId,
      hidden: options.countSpecials,
      specials: options.countSpecials,
      countSpecials: options.countSpecials
    )
  ).observeOn(scheduler)
    .filterSuccessfulStatusAndRedirectCodes()
    .map(BaseShow.self)
}

func seasonsForShow(showIds: ShowIds, extended: [Extended]) -> Single<[TraktSwift.Season]> {
  return trakt.seasons.rx
    .request(.summary(showId: showIds.realId, extended: extended))
    .observeOn(scheduler)
    .filterSuccessfulStatusAndRedirectCodes()
    .map([TraktSwift.Season].self)
}

func genresForMoviesAndShows() -> Single<Set<Genre>> {
  let genresForType: (GenreType) -> Single<[Genre]> = { type in
    trakt.genres.rx.request(.list(type))
      .observeOn(scheduler)
      .filterSuccessfulStatusAndRedirectCodes()
      .map([Genre].self)
  }

  return Single.zip(genresForType(.movies), genresForType(.shows)) { (movies, shows) in
    Set(movies + shows)
  }
}
