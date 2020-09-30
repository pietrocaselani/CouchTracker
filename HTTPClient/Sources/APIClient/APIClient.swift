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
    request.method = .get

    return client.call(request: request)
  }

  public func post(_ postRequest: Requests.POST) -> HTTPCallPublisher {
    var request = HTTPRequest(components: components)
    request.path += "/" + postRequest.path
    request.method = .post
    request.body = postRequest.body ?? .empty

    return client.call(request: request)
  }
}

public enum Requests {
  public struct GET {
    let path: String
    let queryItems: [URLQueryItem]

    public init(path: String, queryItems: [URLQueryItem] = []) {
      self.path = path
      self.queryItems = queryItems
    }
  }

  public struct POST {
    let path: String
    let body: HTTPBody?

    public init(path: String, body: HTTPBody?) {
      self.path = path
      self.body = body
    }
  }
}
