import Foundation

public struct User: Codable, Hashable {
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

  private enum CodingKeys: String, CodingKey {
    case username, name, vip, ids, location, about, gender, age, images
    case vipExecuteProducer = "vip_ep"
    case joinedAt = "joined_at"
    case isPrivate = "private"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    username = try container.decode(String.self, forKey: .username)
    isPrivate = try container.decode(Bool.self, forKey: .isPrivate)
    name = try container.decode(String.self, forKey: .name)
    vip = try container.decode(Bool.self, forKey: .vip)
    vipExecuteProducer = try container.decode(Bool.self, forKey: .vipExecuteProducer)
    ids = try container.decode(UserIds.self, forKey: .ids)
    location = try container.decode(String.self, forKey: .location)
    about = try container.decode(String.self, forKey: .about)
    gender = try container.decode(String.self, forKey: .gender)
    age = try container.decode(Int.self, forKey: .age)
    images = try container.decode(Images.self, forKey: .images)

    let joinedAt = try container.decode(String.self, forKey: .joinedAt)
    guard let joinedAtDate = TraktDateTransformer.dateTimeTransformer.transformFromJSON(joinedAt) else {
      let message = "JSON key: joined_at - Value: \(joinedAt) - Error: Could not transform to date"
      throw TraktError.missingJSONValue(message: message)
    }

    self.joinedAt = joinedAtDate
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(username, forKey: .username)
    try container.encode(isPrivate, forKey: .isPrivate)
    try container.encode(name, forKey: .name)
    try container.encode(vip, forKey: .vip)
    try container.encode(vipExecuteProducer, forKey: .vipExecuteProducer)
    try container.encode(ids, forKey: .ids)
    try container.encode(location, forKey: .location)
    try container.encode(about, forKey: .about)
    try container.encode(gender, forKey: .gender)
    try container.encode(age, forKey: .age)
    try container.encode(images, forKey: .images)

    let joinedAtJSON = TraktDateTransformer.dateTimeTransformer.transformToJSON(joinedAt)
    try container.encode(joinedAtJSON, forKey: .joinedAt)
  }
}
