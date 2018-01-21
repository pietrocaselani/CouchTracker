final class MoviesManageriOSModuleSetup: MoviesManagerDataSource {
  var options: [MoviesManagerOption] {
    return [.trending]
  }

  func modulePages() -> [MovieManagerModulePage] {
    return options.map { option -> MovieManagerModulePage in
      let view = moduleViewFor(option: option)
      let title = moduleNameFor(option: option)

      return MovieManagerModulePage(page: view, title: title)
    }
  }

  func defaultModuleIndex() -> Int {
    //TODO inject app config repository or something like that, to get the last selected module
    return 0
  }

  private func moduleNameFor(option: MoviesManagerOption) -> String {
    switch option {
    case .trending:
      return "Trending"
    }
  }

  private func moduleViewFor(option: MoviesManagerOption) -> BaseView {
    switch option {
    case .trending:
      return TrendingModule.setupModule(for: .movies)
    }
  }
}
