import TraktSwift

public protocol EpisodeImageInput {
  var tmdb: Int? { get }
  var tvdb: Int? { get }
  var season: Int { get }
  var number: Int { get }
}

struct HashableEpisodeImageInput: EpisodeImageInput, Hashable {
  private let episodeImageInput: EpisodeImageInput

  var tmdb: Int? {
    episodeImageInput.tmdb
  }

  var tvdb: Int? {
    episodeImageInput.tvdb
  }

  var season: Int {
    episodeImageInput.season
  }

  var number: Int {
    episodeImageInput.number
  }

  init(_ episodeImageInput: EpisodeImageInput) {
    self.episodeImageInput = episodeImageInput
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(season)
    hasher.combine(number)

    tmdb.run { hasher.combine($0) }
    tvdb.run { hasher.combine($0) }
  }

  static func == (lhs: HashableEpisodeImageInput, rhs: HashableEpisodeImageInput) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}
