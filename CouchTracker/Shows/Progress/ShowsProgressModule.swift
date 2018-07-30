import CouchTrackerCore
import UIKit

final class ShowsProgressModule {
    private init() {
        Swift.fatalError("No instances for you!")
    }

    static func setupModule() -> BaseView {
        guard let view = R.storyboard.showsProgress.showsProgressViewController() else {
            Swift.fatalError("Can't instantiate showsProgressController from Shows storyboard")
        }

        let trakt = Environment.instance.trakt
        let tmdb = Environment.instance.tmdb
        let tvdb = Environment.instance.tvdb
        let schedulers = Environment.instance.schedulers
        let realmProvider = Environment.instance.realmProvider
        let appConfigsObservable = Environment.instance.appConfigurationsObservable
        let hideSpecials = Environment.instance.currentAppState.hideSpecials
        let traktLoginObservable = Environment.instance.loginObservable

        let configurationRepository = ConfigurationCachedRepository(tmdbProvider: tmdb)
        let imageRepository = ImageCachedRepository(tmdb: tmdb,
                                                    tvdb: tvdb,
                                                    cofigurationRepository: configurationRepository,
                                                    schedulers: schedulers)

        let showProgressRepository = ShowProgressAPIRepository(trakt: trakt)

        let listStateDataSource = ShowsProgressListStateDefaultDataSource(userDefaults: UserDefaults.standard)

        let dataSource = ShowsProgressRealmDataSource(realmProvider: realmProvider, schedulers: schedulers)
        let router = ShowsProgressiOSRouter(viewController: view)
        let viewDataSource = ShowsProgressTableViewDataSource(imageRepository: imageRepository)
        let showsProgressNetwork = ShowsProgressMoyaNetwork(trakt: trakt)
        let repository = ShowsProgressAPIRepository(network: showsProgressNetwork,
                                                    dataSource: dataSource,
                                                    schedulers: schedulers,
                                                    showProgressRepository: showProgressRepository,
                                                    appConfigurationsObservable: appConfigsObservable,
                                                    hideSpecials: hideSpecials)
        let interactor = ShowsProgressService(repository: repository,
                                              listStateDataSource: listStateDataSource,
                                              schedulers: schedulers)
        let presenter = ShowsProgressDefaultPresenter(view: view,
                                                      interactor: interactor,
                                                      viewDataSource: viewDataSource,
                                                      router: router,
                                                      loginObservable: traktLoginObservable)

        view.presenter = presenter

        return view
    }
}
