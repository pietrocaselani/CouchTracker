final class ShowsNowModule {
  private init() {}

  static var showsManagerOption: ShowsManagerOption {
    return ShowsManagerOption.now
  }

  static func setupModule() -> BaseView {
    guard let view = R.storyboard.showsNow.showsNowViewController() else {
      fatalError("Can't instantiate showsNowViewController from ShowsNow storyboard")
    }

    return view
  }
}
