import TMDBSwift

let configurationMock = try! JSONDecoder().decode(Configuration.self, from: ConfigurationService.configuration.sampleData)

func createImagesEntityMock() -> ImagesEntity {
  let images = try! JSONDecoder().decode(Images.self, from: Movies.images(movieId: -1).sampleData)

  return ImagesEntityMapper.entity(for: images, using: configurationMock)
}
