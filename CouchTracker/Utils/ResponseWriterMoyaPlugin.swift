import Moya
import Result

final class ResponseWriterMoyaPlugin: PluginType {

  func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    guard let response = result.value else { return }

    guard let requestURL = response.request?.url else { return }

    do {
      try writeBody(response, requestURL)
      try writeHeaders(response, requestURL)
    } catch {
      print(error)
    }
  }

  private func writeBody(_ response: Response, _ requestURL: URL) throws {
    let titleBody = "trakt\(requestURL.path.replacingOccurrences(of: "/", with: "_"))_body"

    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    var fileURL = URL(fileURLWithPath: documentsDirectory, isDirectory: true)
    fileURL.appendPathComponent(titleBody)

    try response.data.write(to: fileURL, options: .atomicWrite)
  }

  private func writeHeaders(_ response: Response, _ requestURL: URL) throws {
    let title = "trakt\(requestURL.path.replacingOccurrences(of: "/", with: "_"))_headers"

    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    var fileURL = URL(fileURLWithPath: documentsDirectory, isDirectory: true)
    fileURL.appendPathComponent(title)

    guard let headers = response.response?.allHeaderFields else { return }

    let headersData = headers.map { (key, value) -> String in
      return "\(key): \(value)"
    }.joined(separator: "\n")
    .data(using: .utf8)

    guard let data = headersData else { return }

    try data.write(to: fileURL, options: .atomicWrite)
  }
}
