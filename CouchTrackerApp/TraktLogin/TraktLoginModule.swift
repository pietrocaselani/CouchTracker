import CouchTrackerCore

enum TraktLoginModule {
  static func setupModule() -> BaseView {
    let appStateManager = Environment.instance.appStateManager
    let traktProvider = Environment.instance.trakt

    let policyDecider = TraktTokenPolicyDecider(traktProvider: traktProvider)

    let interactor = TraktLoginService(appStateManager: appStateManager, policyDecider: policyDecider)

    let view = TraktLoginViewController()
    let presenter = TraktLoginDefaultPresenter(view: view, interactor: interactor)

    view.presenter = presenter

    return view
  }
}
