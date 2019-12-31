import TraktSwift
import Moya

protocol TraktProvider: AnyObject {
  var movies: MoyaProvider<Movies> { get }
  var genres: MoyaProvider<Genres> { get }
  var search: MoyaProvider<Search> { get }
  var shows: MoyaProvider<Shows> { get }
  var users: MoyaProvider<Users> { get }
  var episodes: MoyaProvider<Episodes> { get }
  var sync: MoyaProvider<Sync> { get }
  var seasons: MoyaProvider<Seasons> { get }
}

extension Trakt: TraktProvider {}
