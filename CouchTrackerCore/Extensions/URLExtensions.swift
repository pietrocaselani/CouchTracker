import Foundation

extension URL {
  init(validURL: StaticString) {
    guard let url = URL(string: "\(validURL)") else {
      fatalError("Invalid URL! \(validURL)")
    }

    self = url
  }
}
