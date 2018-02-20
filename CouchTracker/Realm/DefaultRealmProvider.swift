import RealmSwift
import RxSwift

final class DefaultRealmProvider: RealmProvider {
	private let configuration: Realm.Configuration
	private let buildConfig: BuildConfig

	init(buildConfig: BuildConfig, configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
		self.buildConfig = buildConfig
		self.configuration = configuration
	}

	lazy var realm: Realm = {
		do {
			let instance = try Realm(configuration: configuration)

			if buildConfig.debug {
				let realmPath = instance.configuration.fileURL?.absoluteString ?? "Realm in memory"
				print("Realm path: \(realmPath)")
			}

			return instance
		} catch {
			fatalError("Could not open Realm due to error: \(error.localizedDescription)")
		}
	}()
}
