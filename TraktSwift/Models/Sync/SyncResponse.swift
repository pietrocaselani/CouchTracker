public struct SyncResponse: Codable {
  public let added: SyncStats?
  public let existing: SyncStats?
  public let deleted: SyncStats?
  public let notFound: SyncErrors?

  private enum CodingKeys: String, CodingKey {
    case added, existing, deleted
    case notFound = "not_found"
  }

  public init(added: SyncStats?, existing: SyncStats?, deleted: SyncStats?, notFound: SyncErrors?) {
    self.added = added
    self.existing = existing
    self.deleted = deleted
    self.notFound = notFound
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    added = try container.decodeIfPresent(SyncStats.self, forKey: .added)
    existing = try container.decodeIfPresent(SyncStats.self, forKey: .existing)
    deleted = try container.decodeIfPresent(SyncStats.self, forKey: .deleted)
    notFound = try container.decodeIfPresent(SyncErrors.self, forKey: .notFound)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(added, forKey: .added)
    try container.encodeIfPresent(existing, forKey: .existing)
    try container.encodeIfPresent(deleted, forKey: .deleted)
    try container.encodeIfPresent(notFound, forKey: .notFound)
  }
}
