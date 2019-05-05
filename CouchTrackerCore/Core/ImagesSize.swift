public enum PosterImageSize: String {
  case w92
  case w154
  case w185
  case w342
  case w500
  case w780
  case original
}

public enum BackdropImageSize: String {
  case w300
  case w780
  case w1280
  case original
}

public enum TVDBEpisodeImageSize: String {
  case normal
  case small
}

public enum StillImageSize: String {
  case w92
  case w185
  case w300
  case original
}

public struct EpisodeImageSizes: Hashable {
  public let tvdb: TVDBEpisodeImageSize?
  public let tmdb: StillImageSize?
}
