import Trakt
import Foundation

struct ShowEntity: Hashable {
  let ids: ShowIds
  let title: String?
  let overview: String?
  let network: String?
  let genres: [Genre]?
  let status: Status?
  let firstAired: Date?

  var hashValue: Int {
    var hash = ids.hashValue

    if let titleHash = title?.hashValue {
      hash = hash ^ titleHash
    }

    if let overviewHash = overview?.hashValue {
      hash = hash ^ overviewHash
    }

    if let statusHash = status?.hashValue {
      hash = hash ^ statusHash
    }

    if let firstAiredHash = firstAired?.hashValue {
      hash = hash ^ firstAiredHash
    }

    if let networkHash = network?.hashValue {
      hash = hash ^ networkHash
    }

    genres?.forEach { hash = hash ^ $0.hashValue }

    return hash
  }

  static func == (lhs: ShowEntity, rhs: ShowEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
