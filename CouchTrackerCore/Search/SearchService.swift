import RxSwift
import TraktSwift

public final class SearchService: SearchInteractor {
  private let repository: SearchRepository

  public init(repository: SearchRepository) {
    self.repository = repository
  }

  public func search(query: String, types: [SearchType]) -> Single<[SearchResult]> {
    return repository.search(query: query, types: types, page: 0, limit: 50)
  }
}
