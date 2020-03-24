public struct Show: DataStruct, Codable {
  public let ids: ShowIds
  public let title: String?
  public let overview: String?
  public let network: String?
  public let genres: [Genre]
  public let status: Status?
  public let firstAired: Date?
  public let seasons: [Season]
  public let aired: Int?
  public let nextEpisode: Episode?
  public let watched: Watched?

  public struct Watched: Hashable, Codable {
    public let completed: Int
    public let lastEpisode: Episode

    public init(completed: Int, lastEpisode: Episode) {
      self.completed = completed
      self.lastEpisode = lastEpisode
    }
  }

  public init(ids: ShowIds, title: String?, overview: String?, network: String?, genres: [Genre], status: Status?,
              firstAired: Date?, seasons: [Season], aired: Int?, nextEpisode: Episode?, watched: Watched?) {
    self.ids = ids
    self.title = title
    self.overview = overview
    self.network = network
    self.genres = genres
    self.status = status
    self.firstAired = firstAired
    self.seasons = seasons
    self.aired = aired
    self.nextEpisode = nextEpisode
    self.watched = watched
  }

  // sourcery:inline:Show.TemplateName
  internal func copy(
    ids: CopyValue<ShowIds> = .same,
    title: OptionalCopyValue<String> = .same,
    overview: OptionalCopyValue<String> = .same,
    network: OptionalCopyValue<String> = .same,
    genres: CopyValue<[Genre]> = .same,
    status: OptionalCopyValue<Status> = .same,
    firstAired: OptionalCopyValue<Date> = .same,
    seasons: CopyValue<[Season]> = .same,
    aired: OptionalCopyValue<Int> = .same,
    nextEpisode: OptionalCopyValue<Episode> = .same,
    watched: OptionalCopyValue<Watched> = .same
  ) -> Show {
    let newIds: ShowIds = setValue(ids, self.ids)
    let newTitle: String? = setValueOptional(title, self.title)
    let newOverview: String? = setValueOptional(overview, self.overview)
    let newNetwork: String? = setValueOptional(network, self.network)
    let newGenres: [Genre] = setValue(genres, self.genres)
    let newStatus: Status? = setValueOptional(status, self.status)
    let newFirstAired: Date? = setValueOptional(firstAired, self.firstAired)
    let newSeasons: [Season] = setValue(seasons, self.seasons)
    let newAired: Int? = setValueOptional(aired, self.aired)
    let newNextEpisode: Episode? = setValueOptional(nextEpisode, self.nextEpisode)
    let newWatched: Watched? = setValueOptional(watched, self.watched)

    return Show(ids: newIds, title: newTitle, overview: newOverview, network: newNetwork, genres: newGenres,
                status: newStatus, firstAired: newFirstAired, seasons: newSeasons, aired: newAired,
                nextEpisode: newNextEpisode, watched: newWatched)
  }
  // sourcery:end
}
