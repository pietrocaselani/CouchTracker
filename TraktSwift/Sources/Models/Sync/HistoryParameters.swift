import Foundation

public struct HistoryParameters: Hashable {
  public let type: HistoryType?
  public let id: Int?
  public let startAt, endAt: Date?

  public init(type: HistoryType? = nil, id: Int? = nil, startAt: Date? = nil, endAt: Date? = nil) {
    self.type = type
    self.id = id
    self.startAt = startAt
    self.endAt = endAt
  }
}
