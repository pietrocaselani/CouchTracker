import CouchTrackerCore
import TraktSwift

protocol SearchDataSource: UICollectionViewDataSource {
  var entities: [SearchResultEntity] { get set }
}

enum SearchModule {
  static func setupModule(searchTypes: [SearchType]) -> BaseView {
    let environment = Environment.instance
    let trakt = environment.trakt
    let imageRepository = Environment.instance.imageRepository

    let posterCellInteractor = PosterCellService(imageRepository: imageRepository)

    let dataSource = SearchCollectionViewDataSource(interactor: posterCellInteractor)

    let interactor = SearchService(traktProvider: trakt)
    let router = SearchiOSRouter()

    let presenter = SearchDefaultPresenter(interactor: interactor, types: searchTypes, router: router)

    let viewController = SearchViewController(presenter: presenter, dataSource: dataSource)

    router.viewController = viewController

    return viewController
  }
}
