import Combine

// Experimental API

public typealias APICallPublisher<T> = AnyPublisher<T, HTTPError>

public struct APIClient {
  public enum Error: Swift.Error {
    case baseURL(URL)
  }
  private let components: URLComponents
  private let client: HTTPClient

  public init(client: HTTPClient, baseURL: URL) throws {
    guard let components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
      throw Error.baseURL(baseURL)
    }

    self.client = client
    self.components = components
  }

  public func get(_ getRequest: Requests.GET) -> HTTPCallPublisher {
    var request = HTTPRequest(components: components)
    request.path += "/" + getRequest.path
    request.method = getRequest.method

    return client.call(request: request)
  }
}

public enum Requests {
  public struct GET {
    let method = HTTPMethod.get
    let path: String

    public init(path: String) {
      self.path = path
    }
  }
}
