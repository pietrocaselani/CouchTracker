import RxSwift
import TMDBSwift

public protocol ConfigurationRepository: AnyObject {
  init(tmdbProvider: TMDBProvider)

  func fetchConfiguration() -> Observable<Configuration>
}
