import Combine

public extension HTTPCallPublisher where Output == HTTPResponse {
    func decoded<Model: Decodable>(
        as type: Model.Type,
        using decoder: JSONDecoder = .init()
    ) -> APICallPublisher<Model> {
      self.flatMap { response -> APICallPublisher<Model> in
        do {
          let model = try response.body.decodeAsModel(type, using: decoder)
          return Just(model).setFailureType(to: HTTPError.self).eraseToAnyPublisher()
        } catch {
          return Fail(
            outputType: Model.self,
            failure: HTTPError.decodingBody(
              request: response.request,
              response: response,
              error: error
            )
          ).eraseToAnyPublisher()
        }
      }.eraseToAnyPublisher()
    }
}
