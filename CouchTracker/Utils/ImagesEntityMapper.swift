import TMDBSwift
import Foundation

final class ImagesEntityMapper {
  private init() {
    Swift.fatalError("No instances for you!")
  }

  static func entity(for images: Images, using configuration: Configuration,
                     posterSize: PosterImageSize = .w342,
                     backdropSize: BackdropImageSize = .w780,
                     stillSize: StillImageSize = .w300) -> ImagesEntity {
    let baseURL = configuration.images.secureBaseURL as NSString

    let backdrops = images.backdrops.map { imageEntity(for: $0, with: baseURL, size: backdropSize.rawValue) }
    let posters = images.posters.map { imageEntity(for: $0, with: baseURL, size: posterSize.rawValue) }
    let stills = images.stills.map { imageEntity(for: $0, with: baseURL, size: stillSize.rawValue) }

    return ImagesEntity(identifier: images.identifier, backdrops: backdrops, posters: posters, stills: stills)
  }

  static func imageEntity(for image: Image, with baseURL: NSString, size: String) -> ImageEntity {
    let link = (baseURL.appendingPathComponent(size) as NSString).appendingPathComponent(image.filePath)

    return ImageEntity(link: link,
                       width: image.width,
                       height: image.height,
                       iso6391: image.iso6391,
                       aspectRatio: image.aspectRatio,
                       voteAverage: image.voteAverage,
                       voteCount: image.voteCount)
  }
}
