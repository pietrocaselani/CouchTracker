public struct ImageEntity: Hashable {
  public let link: String
  public let width: Int
  public let height: Int
  public let iso6391: String?
  public let aspectRatio: Float
  public let voteAverage: Float
  public let voteCount: Int

  public func isBest(then: ImageEntity) -> Bool {
    return voteAverage < then.voteAverage
  }
}
