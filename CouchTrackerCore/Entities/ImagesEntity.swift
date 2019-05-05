public struct ImagesEntity: Hashable {
  public let identifier: Int
  public let backdrops: [ImageEntity]
  public let posters: [ImageEntity]
  public let stills: [ImageEntity]

  public func posterImage() -> ImageEntity? {
    return bestImage(of: posters)
  }

  public func backdropImage() -> ImageEntity? {
    return bestImage(of: backdrops)
  }

  public func stillImage() -> ImageEntity? {
    return bestImage(of: stills)
  }

  private func bestImage(of images: [ImageEntity]) -> ImageEntity? {
    return images.max(by: { (lhs, rhs) -> Bool in
      lhs.isBest(then: rhs)
    })
  }

  public static func empty() -> ImagesEntity {
    let imageEntities = [ImageEntity]()
    return ImagesEntity(identifier: -1, backdrops: imageEntities, posters: imageEntities, stills: imageEntities)
  }
}
