import RxSwift
import TMDBSwift

public protocol ConfigurationRepository: class {
    init(tmdbProvider: TMDBProvider)

    func fetchConfiguration() -> Observable<Configuration>
}
