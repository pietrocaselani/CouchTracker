@testable import CouchTrackerCore
import Moya
import RxSwift
import TraktSwift

enum SearchMocks {
  final class Interactor: SearchInteractor {
    var searchInvoked = false
    var searchParameters: (query: String, types: [SearchType])?

    private var results: [SearchResult]
    private var error: Error?

    init(results: [SearchResult] = [SearchResult](), error: Error? = nil) {
      self.results = results
      self.error = error
    }

    func search(query _: String, types _: [SearchType], page _: Int, limit _: Int) -> Single<[SearchResult]> {
      guard let realError = error else {
        return Single.just(results)
      }

      return Single.error(realError)
    }
  }

  final class Router: SearchRouter {
    var showViewInvokedCount = 0
    var showViewLastParameter: SearchResultEntity?

    func showViewFor(entity: SearchResultEntity) {
      showViewInvokedCount += 1
      showViewLastParameter = entity
    }
  }
}

//    func search(query: String, types: [SearchType]) -> Single<[SearchResult]> {
//      searchInvoked = true
//      searchParameters = (query, types)
//
//      let lowercaseQuery = query.lowercased()
//
//      return repository.search(query: query, types: [.movie], page: 0, limit: 50).map { results -> [SearchResult] in
//        results.filter { result -> Bool in
//          let containsMovie = result.movie?.title?.lowercased().contains(lowercaseQuery) ?? false
//          let containsShow = result.show?.title?.lowercased().contains(lowercaseQuery) ?? false
//          return containsMovie || containsShow
//        }
//      }
