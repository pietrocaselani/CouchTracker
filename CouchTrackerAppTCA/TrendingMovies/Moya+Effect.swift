import ComposableArchitecture
import Moya

extension MoyaProvider {
    func requestAsEffect(_ target: Target) -> Effect<Response, MoyaError> {
        Effect.future { completion in
            self.request(target, callbackQueue: nil, progress: nil, completion: completion)
        }
    }
}

extension Effect where Output == Response, Failure == MoyaError {
    func decoded<Model: Decodable>(
        as modelType: Model.Type,
        using decoder: JSONDecoder = .init()
    ) -> Effect<Model, Error> {
        self.tryMap { response -> Model in
            try response.map(modelType, atKeyPath: nil, using: decoder, failsOnEmptyData: true)
        }.eraseToEffect()
    }
}

extension MoyaProvider {
    func makeRequest(_ target: Target) throws -> URLRequest {
        try self.endpoint(target).urlRequest()
    }
}
