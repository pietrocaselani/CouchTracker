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

struct EpisodeImageSizes {
  let tvdb: TVDBEpisodeImageSize?
  let tmdb: StillImageSize?
}
