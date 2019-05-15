import Foundation

extension TMDB {
  // swiftlint:disable force_unwrapping
  public static let baseURL = URL(string: "https://\(TMDB.apiHost)/\(TMDB.apiVersion)")!

  static let apiHost = "api.themoviedb.org"
  static let apiVersion = "3"
  static let defaultSecureImageURL = "https://image.tmdb.org/t/p/"
  static let defaultBackdropSizes = ["w300", "w780", "w1280", "original"]
  static let defaultPosterSizes = ["w92", "w154", "w185", "w342", "w500", "w780", "original"]
  static let defaultStillSizes = ["w92", "w185", "w300", "original"]
}
