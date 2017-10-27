struct ShowDetailsViewModel: Hashable {
  let title: String
  let overview: String
  let network: String
  let genres: String
  let firstAired: String
  let status: String

  var hashValue: Int {
    var hash = title.hashValue ^ overview.hashValue
    hash = hash ^ network.hashValue ^ genres.hashValue
    hash = hash ^ firstAired.hashValue ^ status.hashValue
    return hash
  }

  static func == (lhs: ShowDetailsViewModel, rhs: ShowDetailsViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
