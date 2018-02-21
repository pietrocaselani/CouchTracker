import CouchTrackerCore

final class TraktLoginModule {
	private init() {}

	static func setupModule(loginOutput: TraktLoginOutput) -> BaseView {
		let traktProvider = Environment.instance.trakt

		guard let interactor = TraktLoginService(traktProvider: traktProvider) else {
			fatalError("Tried to create OAuth URL without redirect URL? See Trakt.swift")
		}

		let outputs = CompositeLoginOutput(outputs: [loginOutput, Environment.instance.defaultOutput])

		let view = TraktLoginViewController()
		let presenter = TraktLoginiOSPresenter(view: view, interactor: interactor, output: outputs)
		let policyDecider = TraktTokenPolicyDecider(loginOutput: outputs, traktProvider: traktProvider)

		view.presenter = presenter
		view.policyDecider = policyDecider

		return view
	}
}
