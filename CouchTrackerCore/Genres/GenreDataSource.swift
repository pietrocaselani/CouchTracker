import RxSwift
import TraktSwift

public protocol GenreDataSource {
  func fetchGenres() -> Maybe<[Genre]>
  func save(genres: [Genre]) throws
}
