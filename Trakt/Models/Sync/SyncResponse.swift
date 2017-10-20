import ObjectMapper

public struct SyncResponse: ImmutableMappable {
  public let added: SyncStats?
  public let existing: SyncStats?
  public let deleted: SyncStats?
  public let notFound: SyncStats?
  
  public init(added: SyncStats?, existing: SyncStats?, deleted: SyncStats?, notFound: SyncStats?) {
    self.added = added
    self.existing = existing
    self.deleted = deleted
    self.notFound = notFound
  }
  
  public init(map: Map) throws {
    self.added = try? map.value("added")
    self.existing = try? map.value("existing")
    self.deleted = try? map.value("deleted")
    self.notFound = try? map.value("not_found")
  }
  
  public func mapping(map: Map) {
    self.added >>> map["added"]
    self.existing >>> map["existing"]
    self.deleted >>> map["deleted"]
    self.notFound >>> map["not_found"]
  }
}
