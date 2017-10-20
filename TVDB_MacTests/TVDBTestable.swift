import Moya

final class TVDBTestable: TVDB {

  override func createProvider<T>(forTarget target: T.Type) -> RxMoyaProvider<T> where T : TVDBType {
    let provider = super.createProvider(forTarget: target)

    return RxMoyaProvider<T>(endpointClosure: provider.endpointClosure,
                             requestClosure: provider.requestClosure,
                             stubClosure: MoyaProvider.immediatelyStub,
                             manager: provider.manager,
                             plugins: provider.plugins,
                             trackInflights: provider.trackInflights)
  }

}
