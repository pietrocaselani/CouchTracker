struct EpisodeImageInputMock: EpisodeImageInput, Hashable {
	var tmdb: Int?
	var tvdb: Int
	var season: Int
	var number: Int

  var hashValue: Int {
    var hash = tvdb.hashValue
    hash ^= season.hashValue
    hash ^= number.hashValue

    tmdb.run { hash ^= $0.hashValue }

    return hash
  }

  static func == (lhs: EpisodeImageInputMock, rhs: EpisodeImageInputMock) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
