import CouchTrackerCore
import CouchTrackerDebug

final class AppFlowiOSModuleDataSource: AppFlowModuleDataSource {
  private typealias Strings = CouchTrackerCoreStrings
  var modulePages: [ModulePage]

  init(buildConfig: BuildConfig) {
    let moviesView = MoviesManagerModule.setupModule()
    let moviesPage = ModulePage(page: moviesView, title: Strings.movies())

    let showsView = ShowsManagerModule.setupModule()
    let showsPage = ModulePage(page: showsView, title: Strings.shows())

    let appConfigsView = AppStateModule.setupModule()
    let appConfigsPage = ModulePage(page: appConfigsView, title: Strings.settings())

    if buildConfig.debug {
      let debugPage = ModulePage(page: DebugMenuModule.setupModule(), title: "Debug")
      modulePages = [moviesPage, showsPage, appConfigsPage, debugPage]
    } else {
      modulePages = [moviesPage, showsPage, appConfigsPage]
    }
  }
}
