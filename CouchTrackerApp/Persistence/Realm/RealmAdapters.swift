import CouchTrackerCore
import CouchTrackerPersistence
import TraktSwift

extension GenreRealm {
  func toEntity() -> Genre {
    return Genre(name: name, slug: slug)
  }
}

extension Genre {
  func toRealm() -> GenreRealm {
    let entity = GenreRealm()

    entity.name = name
    entity.slug = slug

    return entity
  }
}

extension ShowIdsRealm {
  func toEntity() -> ShowIds {
    return ShowIds(trakt: trakt,
                   tmdb: tmdb.value,
                   imdb: imdb,
                   slug: slug,
                   tvdb: tvdb,
                   tvrage: tvrage.value)
  }
}

extension ShowIds {
  func toRealm() -> ShowIdsRealm {
    let entity = ShowIdsRealm()

    entity.trakt = trakt
    entity.tmdb.value = tmdb
    entity.imdb = imdb
    entity.slug = slug
    entity.tvdb = tvdb
    entity.tvrage.value = tvrage

    return entity
  }
}

extension SeasonIdsRealm {
  public func toEntity() -> SeasonIds {
    return SeasonIds(tvdb: tvdb.value, tmdb: tmdb.value, trakt: trakt, tvrage: tvrage.value)
  }
}

extension SeasonIds {
  public func toRealm() -> SeasonIdsRealm {
    let entity = SeasonIdsRealm()

    entity.trakt = trakt
    entity.tmdb.value = tmdb
    entity.tvdb.value = tvdb
    entity.tvrage.value = tvrage

    return entity
  }
}

extension WatchedEpisodeEntityRealm {
  func toEntity() -> WatchedEpisodeEntity {
    guard let episode = episodeEntity?.toEntity() else {
      Swift.fatalError("How episodeEntity is not present on WatchedEpisodeEntityRealm?!")
    }

    return WatchedEpisodeEntity(episode: episode, lastWatched: lastWatched)
  }
}

extension WatchedEpisodeEntity {
  func toRealm() -> WatchedEpisodeEntityRealm {
    let realm = WatchedEpisodeEntityRealm()

    realm.episodeEntity = episode.toRealm()
    realm.lastWatched = lastWatched

    return realm
  }
}

extension EpisodeIdsRealm {
  public func toEntity() -> EpisodeIds {
    return EpisodeIds(trakt: trakt,
                      tmdb: tmdb.value,
                      imdb: imdb,
                      tvdb: tvdb.value,
                      tvrage: tvrage.value)
  }
}

public extension EpisodeIds {
  public func toRealm() -> EpisodeIdsRealm {
    let entity = EpisodeIdsRealm()

    entity.trakt = trakt
    entity.tmdb.value = tmdb
    entity.imdb = imdb
    entity.tvdb.value = tvdb
    entity.tvrage.value = tvrage

    return entity
  }
}

extension WatchedSeasonEntityRealm {
  func toEntity() -> WatchedSeasonEntity {
    guard let seasonIds = seasonIds?.toEntity(), let showIds = showIds?.toEntity() else {
      Swift.fatalError()
    }

    return WatchedSeasonEntity(showIds: showIds, seasonIds: seasonIds, number: number, aired: aired.value,
                               completed: completed.value, episodes: episodes.map { $0.toEntity() },
                               overview: overview, title: title)
  }
}

extension WatchedSeasonEntity {
  func toRealm() -> WatchedSeasonEntityRealm {
    let realm = WatchedSeasonEntityRealm()

    realm.showIds = showIds.toRealm()
    realm.seasonIds = seasonIds.toRealm()
    realm.title = title
    realm.overview = overview
    realm.number = number
    realm.aired.value = aired
    realm.completed.value = completed
    realm.episodes.append(objectsIn: episodes.map { $0.toRealm() })

    return realm
  }
}

extension ShowEntityRealm {
  func toEntity() -> ShowEntity {
    guard let showIds = self.ids?.toEntity() else {
      Swift.fatalError("How could this be saved on Realm without primary key?!")
    }

    return ShowEntity(ids: showIds,
                      title: title,
                      overview: overview,
                      network: network,
                      genres: genres.map { $0.toEntity() },
                      status: Status(rawValue: status ?? ""),
                      firstAired: firstAired)
  }
}

extension ShowEntity {
  func toRealm() -> ShowEntityRealm {
    let entity = ShowEntityRealm()

    entity.ids = ids.toRealm()
    entity.title = title
    entity.overview = overview
    entity.network = network
    entity.status = status?.rawValue
    entity.firstAired = firstAired

    genres.forEach { entity.genres.append($0.toRealm()) }

    return entity
  }
}

extension WatchedShowEntityRealm {
  func toEntity() -> WatchedShowEntity {
    guard let show = self.show?.toEntity() else {
      Swift.fatalError("How show is not present on EpisodeEntityRealm?!")
    }

    return WatchedShowEntity(show: show,
                             aired: aired.value,
                             completed: completed.value,
                             nextEpisode: nextEpisode?.toEntity(),
                             lastWatched: lastWatched,
                             seasons: seasons.map { $0.toEntity() })
  }
}

extension WatchedShowEntity {
  func toRealm() -> WatchedShowEntityRealm {
    let entity = WatchedShowEntityRealm()

    entity.show = show.toRealm()
    entity.aired.value = aired
    entity.completed.value = completed
    entity.nextEpisode = nextEpisode?.toRealm()
    entity.lastWatched = lastWatched
    entity.seasons.append(objectsIn: seasons.map { $0.toRealm() })

    return entity
  }
}

extension EpisodeEntityRealm {
  func toEntity() -> EpisodeEntity {
    guard let showIds = self.showIds?.toEntity() else {
      Swift.fatalError("How showIds is not present on EpisodeEntityRealm?!")
    }

    guard let ids = self.ids?.toEntity() else {
      Swift.fatalError("How ids is not present on EpisodeEntityRealm?!")
    }

    return EpisodeEntity(ids: ids,
                         showIds: showIds,
                         title: title,
                         overview: overview,
                         number: number,
                         season: season,
                         firstAired: firstAired)
  }
}

extension EpisodeEntity {
  func toRealm() -> EpisodeEntityRealm {
    let entity = EpisodeEntityRealm()

    entity.ids = ids.toRealm()
    entity.showIds = showIds.toRealm()
    entity.title = title
    entity.overview = overview
    entity.number = number
    entity.season = season
    entity.firstAired = firstAired

    return entity
  }
}
