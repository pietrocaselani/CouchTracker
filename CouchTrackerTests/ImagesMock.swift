import TMDBSwift

let configurationMock = try! Configuration(JSON: JSONParser.toObject(data: ConfigurationService.configuration.sampleData))

func createImagesEntityMock() -> ImagesEntity {
  let images = try! Images(JSON: JSONParser.toObject(data: Movies.images(movieId: -1).sampleData))

  return ImagesEntityMapper.entity(for: images, using: configurationMock)
}
