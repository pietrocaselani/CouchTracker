import RxSwift
import TraktSwift

public protocol GenreDataHolder {
  func save(genres: [Genre]) throws
}

public protocol GenreDataSource: GenreDataHolder {
  func fetchGenres() -> Maybe<[Genre]>
}
