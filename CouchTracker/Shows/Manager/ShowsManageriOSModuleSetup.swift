final class ShowsManageriOSModuleSetup: ShowsManagerDataSource {
  var options: [ShowsManagerOption] {
    let progress = ShowsManagerOption.progress
    let now = ShowsManagerOption.now

    return [progress, now]
  }

  func modulePages() -> [ShowManagerModulePage] {
    let pages = options.map { option -> ShowManagerModulePage in
      let view = moduleViewFor(option: option)
      let name = moduleNameFor(option: option)

      return ShowManagerModulePage(page: view, title: name)
    }

    return pages
  }

  func defaultModuleIndex() -> Int {
    //TODO inject app config repository or something like that, to get the last selected module
    return 0
  }

  private func moduleNameFor(option: ShowsManagerOption) -> String {
    switch option {
    case .progress:
      return "Progress"
    case .now:
      return "Now"
    }
  }

  private func moduleViewFor(option: ShowsManagerOption) -> BaseView {
    switch option {
    case .progress:
      return ShowsProgressModule.setupModule()
    case .now:
      return ShowsNowModule.setupModule()
    }
  }
}
