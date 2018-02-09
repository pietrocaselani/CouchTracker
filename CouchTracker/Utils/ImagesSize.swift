enum PosterImageSize: String {
  case w92
  case w154
  case w185
  case w342
  case w500
  case w780
  case original
}

enum BackdropImageSize: String {
  case w300
  case w780
  case w1280
  case original
}

enum TVDBEpisodeImageSize: String {
  case normal
  case small
}

enum StillImageSize: String {
  case w92
  case w185
  case w300
  case original
}

struct EpisodeImageSizes: Hashable {
  let tvdb: TVDBEpisodeImageSize?
  let tmdb: StillImageSize?

  var hashValue: Int {
    var hash = 11

    tvdb.run { hash ^= $0.hashValue }
    tmdb.run { hash ^= $0.hashValue }

    return hash
  }

  static func == (lhs: EpisodeImageSizes, rhs: EpisodeImageSizes) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
