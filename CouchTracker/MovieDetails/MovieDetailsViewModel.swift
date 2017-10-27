struct MovieDetailsViewModel {
  let title: String
  let tagline: String
  let overview: String
  let genres: String
  let releaseDate: String
}

extension MovieDetailsViewModel: Equatable, Hashable {

  static func == (lhs: MovieDetailsViewModel, rhs: MovieDetailsViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  var hashValue: Int {
    let hash = title.hashValue ^ releaseDate.hashValue ^ tagline.hashValue
    return hash ^ overview.hashValue ^ genres.hashValue ^ releaseDate.hashValue
  }
}
