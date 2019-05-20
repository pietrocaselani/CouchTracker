@testable import CouchTrackerCore

struct EpisodeImageInputMock: EpisodeImageInput, Hashable {
  var tmdb: Int?
  var tvdb: Int?
  var season: Int
  var number: Int
}
