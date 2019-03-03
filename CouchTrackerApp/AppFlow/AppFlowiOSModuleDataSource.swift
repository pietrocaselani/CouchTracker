import CouchTrackerCore

final class AppFlowiOSModuleDataSource: AppFlowModuleDataSource {
  var modulePages: [ModulePage]

  init() {
    let moviesView = MoviesManagerModule.setupModule()
    let moviesPage = ModulePage(page: moviesView, title: R.string.localizable.movies())

    let showsView = ShowsManagerModule.setupModule()
    let showsPage = ModulePage(page: showsView, title: R.string.localizable.shows())

    let appConfigsView = AppStateModule.setupModule()
    let appConfigsPage = ModulePage(page: appConfigsView, title: R.string.localizable.settings())

    modulePages = [moviesPage, showsPage, appConfigsPage]
  }
}
