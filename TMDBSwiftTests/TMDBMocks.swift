import Foundation
import TMDBSwift

func createConfigurationsMock() -> Configuration {
  do {
    return try JSONDecoder().decode(Configuration.self, from: ConfigurationService.configuration.sampleData)
  } catch {
    fatalError("Unable to decode data. Error: \(error.localizedDescription)")
  }
}

func createMovieImagesMock() -> Images {
  do {
    let data = Movies.images(movieId: 23).sampleData
    return try JSONDecoder().decode(Images.self, from: data)
  } catch {
    fatalError("Unable to decode data. Error: \(error.localizedDescription)")
  }
}
