struct ImageEntity: Hashable {
  let link: String
  let width: Int
  let height: Int
  let iso6391: String?
  let aspectRatio: Float
  let voteAverage: Float
  let voteCount: Int

  func isBest(then: ImageEntity) -> Bool {
    return self.voteCount < then.voteCount
  }

  var hashValue: Int {
    var hash = link.hashValue
    hash = hash ^ width.hashValue
    hash = hash ^ height.hashValue

    if let iso6391Hash = iso6391?.hashValue {
      hash = hash ^ iso6391Hash
    }

    hash = hash ^ aspectRatio.hashValue
    hash = hash ^ voteAverage.hashValue
    hash = hash ^ voteCount.hashValue

    return hash
  }

  static func == (lhs: ImageEntity, rhs: ImageEntity) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
