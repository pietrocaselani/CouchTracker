import TMDBSwift

final class TMDBEntitiesMock {

	static var configurationMock: Configuration {
		return try! jsonDecoder.decode(Configuration.self, from: ConfigurationService.configuration.sampleData)
	}

	static var jsonDecoder: JSONDecoder {
		return JSONDecoder()
	}

	static func createImagesEntityMock() -> ImagesEntity {
		let images = try! jsonDecoder.decode(Images.self, from: Movies.images(movieId: -1).sampleData)

		return ImagesEntityMapper.entity(for: images, using: configurationMock)
	}

	static func createTMDBConfigurationMock() -> Configuration {
		return try! jsonDecoder.decode(Configuration.self, from: ConfigurationService.configuration.sampleData)
	}

	static func createImagesMock(movieId: Int) -> Images {
		return try! jsonDecoder.decode(Images.self, from: Movies.images(movieId: movieId).sampleData)
	}

}