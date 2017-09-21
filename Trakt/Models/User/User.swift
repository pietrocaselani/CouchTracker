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

public final class User: ImmutableMappable, Hashable {
  public let username: String
  public let isPrivate: Bool
  public let name: String
  public let vip: Bool
  public let vipExecuteProducer: Bool
  public let ids: UserIds
  public let joinedAt: Date
  public let location: String
  public let about: String
  public let gender: String
  public let age: Int
  public let images: Images

  public init(map: Map) throws {
    self.username = try map.value("username")
    self.isPrivate = try map.value("private")
    self.name = try map.value("name")
    self.vip = try map.value("vip")
    self.vipExecuteProducer = try map.value("vip_ep")
    self.ids = try map.value("ids")
    self.joinedAt = try map.value("joined_at", using: TraktDateTransformer.dateTimeTransformer)
    self.location = try map.value("location")
    self.about = try map.value("about")
    self.gender = try map.value("gender")
    self.age = try map.value("age")
    self.images = try map.value("images")
  }

  public func mapping(map: Map) {
    username >>> map["username"]
    isPrivate >>> map["private"]
    name >>> map["name"]
    vip >>> map["vip"]
    vipExecuteProducer >>> map["vip_ep"]
    ids >>> map["ids"]
    joinedAt >>> map["joined_at"]
    location >>> map["location"]
    about >>> map["about"]
    gender >>> map["gender"]
    age >>> map["age"]
    images >>> map["images"]
  }

  public var hashValue: Int {
    var hash = username.hashValue ^ isPrivate.hashValue ^ name.hashValue ^ vip.hashValue ^ vipExecuteProducer.hashValue
    hash ^= ids.hashValue ^ joinedAt.hashValue ^ location.hashValue ^ about.hashValue ^ gender.hashValue
    return hash ^ age.hashValue ^ images.hashValue
  }

  public static func == (lhs: User, rhs: User) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
