/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.
 
 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

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
