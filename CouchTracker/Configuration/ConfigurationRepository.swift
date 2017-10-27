import RxSwift
import TMDBSwift

protocol ConfigurationRepository: class {
  init(tmdbProvider: TMDBProvider)

  func fetchConfiguration() -> Observable<Configuration>
}
