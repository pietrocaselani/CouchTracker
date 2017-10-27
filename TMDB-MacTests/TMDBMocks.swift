import Foundation

private func toObject(data: Data) -> [String: AnyObject] {
  let options = JSONSerialization.ReadingOptions(rawValue: 0)
  return try! JSONSerialization.jsonObject(with: data, options: options) as! [String: AnyObject]
}

private func toArray(data: Data) -> [[String: AnyObject]] {
  let options = JSONSerialization.ReadingOptions(rawValue: 0)
  return try! JSONSerialization.jsonObject(with: data, options: options) as! [[String: AnyObject]]
}

func createConfigurationsMock() -> Configuration {
  let jsonObject = toObject(data: ConfigurationService.configuration.sampleData)
  return try! Configuration(JSON: jsonObject)
}

func createMovieImagesMock() -> Images {
  let jsonObject = toObject(data: Movies.images(movieId: 23).sampleData)
  return try! Images(JSON: jsonObject)
}
