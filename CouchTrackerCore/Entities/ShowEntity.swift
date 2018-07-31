import Foundation
import TraktSwift

public struct ShowEntity: Hashable {
  public let ids: ShowIds
  public let title: String?
  public let overview: String?
  public let network: String?
  public let genres: [Genre]?
  public let status: Status?
  public let firstAired: Date?

  public var hashValue: Int {
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

  public static func == (lhs: ShowEntity, rhs: ShowEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
