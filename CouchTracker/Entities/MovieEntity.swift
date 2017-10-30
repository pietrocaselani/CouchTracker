import TraktSwift
import Foundation

struct MovieEntity: Hashable {
  let ids: MovieIds
  let title: String?
  let genres: [Genre]?
  let tagline: String?
  let overview: String?
  let releaseDate: Date?

  var hashValue: Int {
    var hash = ids.hashValue

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    if let taglineHash = tagline?.hashValue {
      hash = hash ^ taglineHash
    }

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let releaseDateHash = releaseDate?.hashValue {
      hash = hash ^ releaseDateHash
    }

    genres?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  static func == (lhs: MovieEntity, rhs: MovieEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
