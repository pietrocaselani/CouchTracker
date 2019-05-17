import Foundation

public final class HistoryParameters: Hashable {
  public let type: HistoryType?
  public let id: Int?
  public let startAt, endAt: Date?

  public init(type: HistoryType? = nil, id: Int? = nil, startAt: Date? = nil, endAt: Date? = nil) {
    self.type = type
    self.id = id
    self.startAt = startAt
    self.endAt = endAt
  }

  public var hashValue: Int {
    var hash = 11

    if let typeHash = type?.hashValue {
      hash ^= typeHash
    }

    if let idHash = id?.hashValue {
      hash ^= idHash
    }

    if let startAtHash = startAt?.hashValue {
      hash ^= startAtHash
    }

    if let endAtHash = endAt?.hashValue {
      hash ^= endAtHash
    }

    return hash
  }

  public static func == (lhs: HistoryParameters, rhs: HistoryParameters) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
